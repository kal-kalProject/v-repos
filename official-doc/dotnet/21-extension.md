# Extension en .NET

> **Rol.** Unidad dual UI+backend contributable. Modelo inspirado en extensiones VSCode, pero con **backend real** adosado.

---

## 1. Qué es en concreto

Una Extension en la plataforma es un **paquete** que incluye:

1. **Backend .NET** — uno o más Providers, Drivers, Agents, handlers, migraciones, suscripciones a eventos del pipeline.
2. **Frontend TS** — vistas, comandos, paneles, iconos, status bar items, atajos — que se contribuyen al shell UI.
3. **Manifest** que declara ambas contribuciones + metadatos (id, versión, autor, dependencias, permisos requeridos).

Desde la perspectiva .NET, una Extension es **código .NET + metadatos cargable por el Host** que puede:

- **Instalarse en frío** — parte del bundle inicial, cargada en arranque.
- **Cargarse en caliente** — descubierta y activada sin reiniciar el Host.

---

## 2. Forma del contrato

### 2.1 Manifest

```json
{
  "id": "vortech.inventory.analytics",
  "version": "1.2.3",
  "displayName": "Inventory Analytics",
  "engines": { "vortech": ">=1.0" },
  "contributes": {
    "providers": [ "InventoryAnalyticsProvider" ],
    "agents":    [ "AnomalyDetectorAgent" ],
    "pipeline":  [ { "stage": "post-invocation", "handler": "AuditAppender" } ],
    "ui": {
      "views":    [ { "id": "analytics.dashboard", "when": "scope:inventory" } ],
      "commands": [ { "id": "analytics.exportReport", "title": "Export Report" } ]
    }
  },
  "permissions": [ "inventory:read", "analytics:write" ]
}
```

### 2.2 Descriptor .NET

```csharp
[VortechExtension(Id = "vortech.inventory.analytics")]
public sealed class InventoryAnalyticsExtension : IVortechExtension
{
    public void Configure(IExtensionBuilder builder)
    {
        builder.AddProvider<InventoryAnalyticsProvider>();
        builder.AddAgent<AnomalyDetectorAgent>();
        builder.AddPipelineStage<AuditAppender>(PipelineStage.PostInvocation);
    }

    public Task ActivateAsync(IExtensionContext ctx, CancellationToken ct) => Task.CompletedTask;
    public Task DeactivateAsync(IExtensionContext ctx, CancellationToken ct) => Task.CompletedTask;
}
```

Convenciones fijadas:

- **Dos caras, un paquete.** Backend y frontend se versionan y distribuyen juntos.
- **Contribuciones declarativas.** Manifest es la fuente de verdad para lo que la Extension añade.
- **Permisos explícitos.** Una Extension declara los permisos que requiere; el Host valida en activación.
- **Activación diferida.** El código se carga al instalarse; se activa bajo demanda según triggers.

---

## 3. Runtime

El Host mantiene un **Extension Runtime** que:

- Descubre Extensions en los folders configurados ([`16-host.md §2`](16-host.md)).
- Valida firma, versión, compatibilidad con el Host, y grafo de dependencias.
- Resuelve orden de activación.
- Crea un **AssemblyLoadContext** aislado por Extension — permite unload real en caliente.
- Registra las contribuciones (Providers, Agents, pipeline stages) en el DI y en el Router.
- Expone eventos a la UI sobre Extensions disponibles, activas, en error.

El aislamiento por AssemblyLoadContext es lo que permite:

- **Unload.** Desactivar una Extension libera su código, sin reiniciar.
- **Versionado independiente.** Dos Extensions pueden depender de versiones distintas de una utilidad común.
- **Blast radius.** Un fallo grave en una Extension no tumba el Host si la Extension falla en `DeactivateAsync`, el Runtime la aísla.

---

## 4. Carga en frío vs en caliente

### 4.1 Bundle (frío)
- Extension distribuida con el Host, cargada en arranque.
- Uso típico: extensiones core que casi todo deploy activa.

### 4.2 Hot-load (caliente)
- Extension instalada desde almacén (local, registry interno, marketplace).
- Activada sin reinicio.
- Uso típico: verticales, features experimentales, addons por tenant.

Ambos caminos usan el mismo contrato `IVortechExtension`; solo cambia el origen y el momento de carga.

---

## 5. Proyección vía codegen

- `v-gen` emite la plantilla del frontend TS para contribuir al shell, conectada por Wire a los Providers declarados en la Extension.
- Se genera un `types.d.ts` con los tipos que la Extension expone al resto del shell si publica API cross-extension.
- El manifest puede generarse parcialmente desde atributos C# (`[VortechExtension]` + `[VortechContributes(...)]`).

---

## 6. Relación con Feature (el concepto retirado)

En documentos anteriores existió un concepto "Feature". **Queda reemplazado por Extension + composición Provider/Driver/SDK**. No se introduce "Feature" como primitiva ([`PLATAFORMA-VISION-GLOBAL.v2.md §2`](../../inventory/_analysis-preview/PLATAFORMA-VISION-GLOBAL.v2.md)). Donde un doc antiguo diga "Feature", léase Extension + sus Providers.

---

## 7. Reglas invariantes

1. **Backend y frontend versionados juntos.** No hay Extension "solo UI" que consuma un backend de otra versión.
2. **Permisos declarados.** Toda operación de dominio hecha por la Extension pasa por el pipeline normal con sus permisos validados.
3. **Activación/desactivación idempotentes.** Se puede activar y desactivar N veces sin degradación.
4. **Aislamiento de assemblies.** Cada Extension vive en su AssemblyLoadContext.
5. **Manifest canónico.** El manifest no miente — lo que declara es lo que aporta.

---

## 8. Qué no es

- **No es un Driver con hot-reload.** Un Driver sirve a un Provider existente; una Extension **añade** Providers, Agents o UI nuevos.
- **No es un plugin pasivo.** Tiene ciclo de vida explícito (Activate / Deactivate).
- **No es un parche.** Si se usan Extensions para reparar el núcleo, el núcleo está mal.
- **No es solo UI.** Una Extension puede ser backend-only; lo esencial es que contribuye al sistema como unidad empaquetada.

---

## 9. Inspiración

- **VSCode extensions** — contributes + activation events + API namespace.
- **ASP.NET Core module pattern** — sin framework terceros; se replica el patrón mental.

Leídas como fuente; nada adoptado como dependencia.

---

## 10. Casos típicos de Extension

- Un vertical completo (inventario, firma digital, integración bancaria) shipeable como una unidad.
- Paneles de admin que no vienen con el Host base.
- Integraciones específicas por cliente (conexión a su ERP propietario vía Bridge).
- Features experimentales activables por flag de instalación.
