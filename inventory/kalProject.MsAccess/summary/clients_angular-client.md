---
kind: package-summary
source_repo: kalProject.MsAccess
source_commit: a778b34a5adc8f184f0a73be194466036100a127
repo: kalProject.MsAccess
package_name: (sin nombre de paquete npm)
package_path: Clients/angular-client
language: typescript
manifest: (ninguno — solo README y fuente)
inventoried_at: 2026-04-24T20:00:00Z
inventoried_by: cursor-inventario-fase1
madurez: experimental
---

# Clients/angular-client (TypeScript, sin `package.json`)

## 1. Identidad

- **Path:** `Clients/angular-client`
- **Lenguaje:** TypeScript
- **Manifest:** ausente en el directorio; no se listó `package.json` ni `angular.json` bajo un barrido al 2026-04-24 del clon
- **Publicado:** no

## 2. Propósito

### 2.1 Declarado

`Clients/angular-client/README.md:1-3` indica un cliente WebSocket con RxJS para apps Angular, con lista de features y dependencia documentada a `rxjs` vía el apartado de instalación.

### 2.2 Inferido

Código de cliente con observables, sobre envoltorios de protocolo (`ProtocolEnvelope`, `BroadcastPayload`); estructuralmente incompleto frente a un proyecto Angular de plantilla (no hay `package.json` ni `angular.json` bajo un listado al 2026-04-24 del clon, solo `README.md` y `src/kalproject-client.ts`).

**Evidencia:**

- `Clients/angular-client/src/kalproject-client.ts:1` — `import` de `rxjs` y definición de `ProtocolEnvelope`
- `Clients/angular-client/README.md:16-18` — instrucción `npm install rxjs` sin fijar `package.json` en el mismo tree

## 3. Superficie pública

- No exportable vía `npm` sin manifest; módulo TypeScript a copiar/integrar manualmente (hipótesis)

## 4. Dependencias

### 4.1 Internas

- Ninguna declarativa

### 4.2 Externas

- Indeterminadas (sin `package.json` no hay pares exactos; dependencias de Angular/TS inferidas en Fase 2 o lectura de imports en el `.ts` principal)

## 5. Consumidores internos

- Ninguno identificado; fragmento aislado

## 6. Estructura interna

```
Clients/angular-client/
├── README.md
└── src/
    └── kalproject-client.ts
```

## 7. Estado

- **Madurez:** `experimental` (sin cierre de build; carpeta a medio migrar o ejemplo adjunto)
- **Build:** no ejecutado
- **Tests:** 0

## 8. Dominios

- `wire` — cliente
- (puente) con `ui-kit` o similar si se integra a Angular: no aplica aún (sin app Angular en este directorio en el clon)

## 9. Observaciones

Candidato a completar con `ng new` o importar a un `apps/angular` con manifest en Fase 2; listado bajo "anomalías" en el completion report

## 10. Hipótesis

- `?:` la fuente pudo acompañar documentación bajo `docs/` o `Refactor-map.md:1` del repo (sin afirmar coincidencia sin leer el markdown completo en esta pasada; verificación opcional añadible)

## 11. Preguntas abiertas

- ¿Falta un `package.json` por omisión o git-lfs/ignore? (sin inspección de historial, solo anomalía estructural)
