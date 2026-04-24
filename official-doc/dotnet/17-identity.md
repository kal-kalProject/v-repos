# Identity en .NET

> **Rol.** Host autónomo dedicado a cuentas, credenciales, autenticación, autorización y sesión. Siempre proceso propio. Replicable para HA.
>
> **Regla fundacional.** Identity se construye **con** las primitivas de Vortech. Es dogfooding estructural del modelo.

---

## 1. Qué es en concreto

Identity es **un deploy específico de Host** ([`16-host.md`](16-host.md)) con un conjunto de Providers, Drivers y Extensions dedicados a la identidad. No es "un Provider de identidad montado en cualquier Host" — es proceso separado.

Composición canónica:

- **`IAccountProvider`** — registro, consulta, actualización, desactivación de cuentas.
- **`ICredentialProvider`** — gestión de credenciales (password hashing, passkeys/FIDO2, OTP, claves API).
- **`IAuthenticationProvider`** — validación de credenciales, emisión de sesión.
- **`IAuthorizationProvider`** — evaluación de permisos sobre Scope + principal.
- **`ISessionProvider`** — creación, refresco, revocación de sesiones.
- **`ITokenProvider`** — emisión/validación de tokens (access, refresh, federados).
- **`IFederationProvider`** — integración OIDC / SAML externa.
- **`IAuditProvider`** — registro inmutable de eventos de identidad.

Cada uno es un Provider ordinario, con Drivers intercambiables ([`10-provider.md`](10-provider.md), [`11-driver.md`](11-driver.md)).

---

## 2. Forma del contrato

```csharp
[VortechProvider(Domain = "identity.authentication")]
public interface IAuthenticationProvider
{
    Task<AuthResult> AuthenticateAsync(AuthRequest req, CancellationToken ct);
    Task<AuthResult> RefreshAsync(RefreshRequest req, CancellationToken ct);
    Task RevokeAsync(SessionId id, CancellationToken ct);
}

public sealed record AuthResult(
    Principal Principal,
    Session   Session,
    TokenPair Tokens);
```

Los tipos (Principal, Session, TokenPair, Claims) son **canónicos de la plataforma** — viven en `Vortech.Identity.Contracts` y son consumidos por el pipeline del Host de cualquier producto para resolver el principal activo por request.

---

## 3. Runtime y topología

- **Proceso dedicado.** Nunca montado dentro del Host de producto.
- **Comunicación vía Wire.** El Host de producto habla con el Host Identity por Wire como con cualquier otro Host.
- **Replicación master/slave.** Soportada nativamente por ser Host ordinario.
- **Persistencia** — típicamente base relacional para cuentas/credenciales; almacén rápido (cache) para sesiones activas; almacén append-only para audit.

El aislamiento responde a principios:

- Blast-radius acotado: un bug en Identity no compromete los dominios de negocio.
- Escalado independiente.
- Auditabilidad del binario (Identity cambia con frecuencia distinta al producto).

---

## 4. Integración con el pipeline del Host de producto

El pipeline del Host de producto ([`16-host.md §3`](16-host.md)) tiene una etapa **Identity** que:

1. Extrae el token del sobre Wire.
2. Valida localmente la firma si es posible (claves públicas de Identity cacheadas).
3. Si es necesario consulta a Identity por Wire para revocación/freshness.
4. Construye el `Principal` y lo ancla al Scope activo.

Identity emite tokens firmados con claves cuya clave pública es distribuida a los Hosts consumidores. Los Hosts pueden validar offline casi siempre.

---

## 5. Código propio, no adopción de librería

Identity se implementa en **código propio** sobre BCL + ASP.NET Core. No se adopta Duende, IdentityServer, OpenIddict ni ASP.NET Core Identity como dependencia del núcleo ([cierre §1–§3](01-cierre-decisiones-dotnet.md)).

Lo que sí se usa tal cual:

- Primitivas criptográficas del BCL (`System.Security.Cryptography`).
- `Microsoft.AspNetCore.Authentication` como armazón si corresponde.
- Data protection API nativo de ASP.NET para almacenamiento de secretos efímeros.
- Kestrel como servidor.

Lo que se escribe propio:

- Flujos OAuth 2.1 / OIDC (authorization code + PKCE, client credentials, device, refresh).
- Modelo de clientes OIDC + consent.
- Hashing de passwords (Argon2/PBKDF2 con parámetros propios).
- Almacén de sesiones / refresh tokens / claves.
- Federación OIDC/SAML.
- RBAC/ABAC sobre Scope.

La **inspiración** viene de leer código fuente de OpenIddict, Duende IdentityServer, Keycloak, Ory — adoptando patrones, nunca importando. Ver [cierre §3](01-cierre-decisiones-dotnet.md).

---

## 6. Reglas invariantes

1. **Proceso separado, siempre.** No hay Identity embebido.
2. **Tokens firmados con claves cuya pública es distribuida.** Validación offline como default.
3. **Sesiones revocables.** Lista de revocación o TTL corto con refresh activo.
4. **Auditoría append-only** de eventos de identidad — obligatoria, no opcional.
5. **Código criptográfico sobre APIs nativas.** Nada de hashing artesanal, nada de JWT artesanal cuando hay primitivas del BCL disponibles.
6. **Scope forma parte de la autorización** — no existe "permisos globales" sin Scope.

---

## 7. Qué no es

- **No es un IdP genérico comercial.** No se ofrece como producto externo para terceros (a menos que un vertical explícitamente lo haga).
- **No es un ORM de usuarios.** Es dominio completo con lógica, no CRUD de tabla `users`.
- **No es opcional.** Todo Host de producto consume Identity; sin Identity no hay Principal y el pipeline falla ante cualquier operación autenticada.

---

## 8. Modelo mental

> *Identity es el Host ejemplar del modelo: demuestra que la plataforma se construye a sí misma con sus propias primitivas. Si Identity se puede escribir limpio sobre Provider/Driver/Wire/Scope, cualquier otro dominio también.*
