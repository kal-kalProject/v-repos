# Extension en TypeScript / frontend

> **Rol.** Lado UI de una Extension. Contribuye vistas, comandos, panels, status items al Workbench. Se conecta al backend de la misma Extension vía Provider proxies normales sobre Wire.
>
> **Espejo del backend:** [`../dotnet/21-extension.md`](../dotnet/21-extension.md). **Slot system:** `@vortech/core/extensions`.

---

## 1. Qué es en concreto

Una Extension UI es:

1. **Bundle JS** distribuible (parte del paquete dual backend+frontend de la Extension).
2. **Manifest** — declarado del lado backend; el frontend recibe la parte UI vía Wire.
3. **Módulo TS** que registra contribuciones en los slots de `@vortech/core/extensions`.
4. **Componentes** `@vortech/components` que renderizan las vistas/paneles/items.

El backend de la misma Extension ya está activo en el Host. El frontend lo consume por Wire como cualquier dominio.

---

## 2. Forma del contrato

### 2.1 Punto de entrada

```ts
// extension.ts (entry point del bundle)
import { defineExtensionEntry } from '@vortech/extensions-loader';

export default defineExtensionEntry({
  id: 'vortech.inventory.analytics',
  activate(ctx: IExtensionUIContext) {
    ctx.contribute(ViewsSlot, {
      id: 'analytics.dashboard',
      title: 'Analytics',
      component: AnalyticsDashboard,    // de @vortech/components
      when: ctx => ctx.scope.matches('inventory'),
    });

    ctx.contribute(CommandsSlot, {
      id: 'analytics.exportReport',
      title: 'Export Report',
      handler: () => ctx.providers.get(IAnalyticsProvider).exportReport(),
    });

    ctx.contribute(StatusBarSlot, {
      id: 'analytics.lastSync',
      component: LastSyncIndicator,
      align: 'right',
    });
  },

  deactivate(ctx) {
    // Recursos liberados automáticamente por dispose-reverso de slots.
    // Aquí solo lógica adicional si la hay.
  }
});
```

### 2.2 Slots canónicos

`@vortech/workbench` expone slots tipados:

| Slot | Qué contribuye |
|---|---|
| `ViewsSlot` | Vistas en sidebar / auxiliary bar |
| `EditorsSlot` | Editores en la editor part |
| `PanelsSlot` | Paneles inferiores |
| `CommandsSlot` | Comandos invocables |
| `MenusSlot` | Items de menú contextual / global |
| `StatusBarSlot` | Items de la status bar |
| `ActivityBarSlot` | Iconos de la activity bar |
| `KeybindingsSlot` | Atajos |
| `NotificationsSlot` | Patrones de notificación |
| `ThemesSlot` | Temas custom |
| `LanguagesSlot` | Sintaxis / providers de lenguaje |

Cada slot tiene su tipo; contribuir requiere cumplirlo.

---

## 3. Carga de Extensions UI

### 3.1 Discovery

- El shell consulta al Host por `IExtensionsProvider.list()` (Wire) → recibe metadatos + URLs de bundles UI activos.
- El Loader del shell descarga los bundles según política (lazy, on-demand, all-on-startup).

### 3.2 Aislamiento

- Cada bundle se carga en un **contexto de módulo aislado** (dynamic `import()` con manifest signature check).
- Errores en una Extension no tumban el shell.
- Unload: las contribuciones registradas vía slots se disponen reverso al unload.

### 3.3 Hot-load

- Una Extension instalada caliente en el Host emite evento Wire.
- El shell recibe el evento, descarga el bundle UI, lo activa.
- El nuevo `ViewsSlot` aparece en el sidebar **sin reload del shell** — el atom de "vistas registradas" cambia, el part rerinde.

---

## 4. Comunicación backend ↔ frontend de la misma Extension

```ts
// El backend de la Extension expone IAnalyticsProvider (Provider C#)
// v-gen emite el proxy TS y lo publica en el bundle de la Extension.
import { IAnalyticsProvider } from './generated';

// La Extension UI lo registra en su scope DI
ctx.providers.register(IAnalyticsProvider);

// Componentes lo consumen como Provider normal
class AnalyticsDashboard {
  private readonly api = inject(IAnalyticsProvider);
  readonly summary = derivedAsync(() => this.api.summary());
}
```

No hay protocolo especial entre frontend y backend de la misma Extension — es Wire normal con Scope/permisos validados por el pipeline del Host.

---

## 5. Permisos y Scope

- La Extension declara permisos en su manifest (backend).
- Toda llamada del frontend de la Extension pasa por el pipeline Wire del Host con esos permisos validados.
- Si el principal no tiene permiso, llega `DomainError` tipado y la UI degrada.

---

## 6. Reglas invariantes

1. **Frontend y backend de la Extension se versionan juntos.** No hay mismatch.
2. **Cero acceso a APIs internas del Workbench.** Solo slots públicos.
3. **Contribuciones idempotentes.** Activar/desactivar N veces sin estado residual.
4. **DI scope propio.** Cada Extension tiene su sub-injector aislado.
5. **Errores aislados.** Una Extension que falla no tumba otras ni el shell.

---

## 7. Qué no es

- **No es un script suelto.** Una Extension es paquete versionado.
- **No es solo UI.** El bundle UI siempre tiene contraparte backend (aunque en algunos casos sea trivial).
- **No es un plugin del navegador.** No usa la API de extensiones de Chrome/Firefox.

---

## 8. Inspiración

- **VSCode extensions** — `contributes`, activation events, API namespace, slot pattern.
- **Theia** — modelo de extensiones JS sobre shell tipo VSCode.

Leídas como fuente; no adoptadas como dependencia.
