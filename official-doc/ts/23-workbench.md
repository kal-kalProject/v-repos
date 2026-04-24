# Workbench — `@vortech/workbench`

> **Rol.** Shell de aplicación tipo VSCode. Hospeda Activity Bar, Sidebar, Editor area, Panel, Status bar, Auxiliary bar, Title bar. Carga Extensions UI vía `@vortech/core/extensions`. Es el contenedor visible donde el usuario pasa todo su tiempo.
>
> **No es Host de plataforma** ([`16-host.md`](16-host.md)). Es UI.

---

## 1. Qué es en concreto

`@vortech/workbench` proporciona:

1. **Estructura del shell** — Workbench raíz + 7 parts canónicas.
2. **Sistema de comandos** — registro, ejecución, command palette.
3. **Sistema de keybindings** — atajos contextuales con `when` clauses.
4. **Tree-view** — primitiva de árbol genérica usada por Explorer, Outline, etc.
5. **Notifications / dialogs / toasts** — superficie de feedback.
6. **Activity-bar-driven navigation** — modelo de "área activa" más que SPA-routing.
7. **Slots de contribución** — superficies tipadas donde Extensions añaden vistas, comandos, paneles, status items.
8. **Persistencia del layout** — qué partes están visibles, tamaños de splits, vista activa.

Es un **port refactorizado del Workbench de VSCode** sobre `@vortech/components` y `@vortech/layout`, con el sistema de contribución reescrito sobre `@vortech/core/extensions`.

---

## 2. Las 7 parts canónicas

| Part | Contenido |
|---|---|
| **TitleBar**     | Window controls, breadcrumbs globales, indicadores de estado de Identity / Wire |
| **ActivityBar**  | Iconos de áreas (Inventory, CRM, Settings...) — navegación primaria |
| **Sidebar**      | Vista activa del área (tree, search, source-control style) |
| **Editor**       | Editor groups con tabs, splits, multi-editor |
| **Panel**        | Bottom panel: terminal, problems, output, debug-console |
| **AuxiliaryBar** | Right-side panel para tooling, properties, AI-assist |
| **StatusBar**    | Items de estado y acciones rápidas en bottom |

Cada part es un componente `@vortech/components` que renderiza contribuciones provenientes de slots.

---

## 3. Slots canónicos

```ts
// Definidos en @vortech/workbench/slots
export const ViewsSlot         = defineExtensionSlot<ViewContribution>('views');
export const CommandsSlot      = defineExtensionSlot<CommandContribution>('commands');
export const KeybindingsSlot   = defineExtensionSlot<KeybindingContribution>('keybindings');
export const StatusBarSlot     = defineExtensionSlot<StatusBarContribution>('status');
export const ActivityBarSlot   = defineExtensionSlot<ActivityContribution>('activity');
export const ContextMenuSlot   = defineExtensionSlot<MenuContribution>('context-menu');
export const PanelSlot         = defineExtensionSlot<PanelContribution>('panels');
export const EditorSlot        = defineExtensionSlot<EditorContribution>('editors');
export const ThemeSlot         = defineExtensionSlot<ThemeContribution>('themes');
```

Cada slot tiene tipo concreto. Las Extensions las consumen con `ctx.use(...)` ([`21-extension.md`](21-extension.md)).

---

## 4. Modelo de navegación (no es SPA-routing por defecto)

VSCode no tiene "rutas URL". Tiene:

- **Área activa** — qué icono de la ActivityBar está seleccionado.
- **Vista activa de Sidebar** — derivada del área.
- **Editor activo** — qué tab tiene foco; cada tab es un input + tipo de editor.
- **Comandos** — la "navegación" se ejecuta como comandos (`workbench.action.openSettings`, `analytics.openDashboard`).
- **Deep-link** opcional — secuencia replay de comandos con argumentos.

`@vortech/workbench` **adopta este modelo por defecto**. La discusión sobre si añadir un router URL clásico encima vive en [`20-router.md §X`](20-router.md) y queda pendiente.

---

## 5. Sistema de comandos

```ts
@Component({ /* ... */ })
class SkuListView {
  constructor(@inject(ICommandRegistry) private cmds: ICommandRegistry) {}

  override async onMount() {
    this.onDispose(this.cmds.register({
      id: 'inventory.refreshList',
      title: 'Refresh',
      keybinding: 'F5',
      when: scope('inventory.skus'),
      handler: () => this.refresh(),
    }));
  }
}
```

- Comandos se invocan por id.
- Command palette muestra comandos cuyo `when` se cumple bajo el contexto activo.
- Keybindings son contribuciones a comandos existentes — desacopladas.

---

## 6. Persistencia de layout

El estado del Workbench se serializa como atom persistible:

- Qué parts están visibles, tamaños, ratios.
- Tabs abiertas en cada editor group.
- Vista activa de Sidebar y AuxiliaryBar.
- Ítem activo de ActivityBar.

Storage: Provider local `IShellLayoutStorageProvider` con Drivers (`LocalStorage`, `IndexedDb`).

Al recargar shell, el layout se restaura.

---

## 7. Theming

- `@vortech/theming` provee tokens base.
- Extensions pueden contribuir themes vía `ThemeSlot`.
- `IThemeProvider` (Provider local) gestiona el theme activo y rota variables CSS raíz.

---

## 8. Reglas invariantes

1. **Sistema de contribución único** — `@vortech/core/extensions`. Sin registries internos paralelos.
2. **Una sola Workbench instance por shell.** No anidados.
3. **Cero acceso fuera de las parts.** Todo render canalizado por las 7 parts.
4. **Extensions aisladas** — un fallo en una contribución no tumba el shell.
5. **Layout serializable** — persistencia es estado, no efecto.
6. **Comandos como API pública del shell** — todo lo invocable es comando con id.

---

## 9. Qué no es

- **No es un Host de plataforma** — solo UI. Ver [`16-host.md`](16-host.md).
- **No es un framework de SPA tipo Next/Nuxt** — es shell IDE-like.
- **No es opcional** — toda app Vortech monta un Workbench (mínimo o completo).
- **No reescribe `@vortech/components`** — usa, no implementa.

---

## 10. Inspiración

- **VSCode Workbench** — port directo refactorizado.
- **Eclipse Workbench / IntelliJ IDEA** — modelos históricos de IDE-shell.
- **Theia** — esfuerzo paralelo de Workbench-en-web.

VSCode es la base portada (con licencia respetada); el sistema de contribución y de DI se reescriben sobre `@vortech/core`.

---

## 11. Casos típicos

- App de gestión interna multi-área (CRM + Inventory + Reports) con ActivityBar + Sidebars.
- Herramientas para desarrolladores (editor + terminal + problems).
- Consolas de operador (paneles laterales con widgets reactivos).
- Dashboards complejos con vistas anidadas y splits.
- Cualquier UI donde "una sola pantalla con un router" se queda corto.
