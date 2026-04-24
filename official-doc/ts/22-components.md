# Componentes — `@vortech/components`

> **Rol.** Render runtime canónico del frontend Vortech. Framework de componentes propio, inspirado en Angular zoneless, sobre atoms de `@vortech/core`.
>
> **No es primitiva** del modelo de plataforma (las 12 primitivas son cross-stack); es el render runtime específico del lado TS.

---

## 1. Qué es en concreto

`@vortech/components` proporciona:

1. **Decoradores de clase** — `@Component`, `@Directive`, `@Pipe`, `@Injectable`.
2. **Primitivas reactivas** — `input()`, `output()`, `inject()`, `model()`, `viewChild()`, `contentChild()`.
3. **Templates** — tagged template literal `html\`\`` con parser propio.
4. **Control flow** — `@if`, `@for`, `@switch` al estilo Angular 17+.
5. **Scoped styles** — encapsulación real (nada de "global mode").
6. **Scheduler** — coordinador de rerenders sobre el GlitchFreeScheduler de atoms.
7. **ComponentRegistry** — descubrimiento por selector, registro central.

Es **zoneless por diseño**. Sin Zone.js, sin digest cycle, sin `ChangeDetectionStrategy`. Reactividad fina sobre atoms.

---

## 2. Modelo central — atoms sobre decoradores de campo

Decisión clave del cierre ([`01-cierre-decisiones-ts.md §5`](01-cierre-decisiones-ts.md)):

- **Decoradores solo de clase** (`@Component`, `@Directive`, `@Pipe`, `@Injectable`).
- **Primitivas reactivas como funciones** (`input()`, `output()`, `inject()`).
- **Sin `@Input()` / `@Output()` / `@Inject()` de campo.**

### 2.1 Forma canónica

```ts
@Component({
  selector: 'sku-detail',
  template: html`
    @if (sku()) {
      <header>{{ sku()!.code }}</header>
      <price-tag [value]="sku()!.price" (clicked)="onPriceClick($event)" />
    } @else {
      <loading-spinner />
    }
  `,
  styles: css`
    header { font-weight: bold; }
  `,
})
export class SkuDetail {
  // input() — devuelve atom de lectura, bindeado al atributo
  readonly skuId = input<SkuId>();                    // requerido
  readonly compact = input<boolean>(false);            // con default
  readonly title = input<string>().alias('label');     // con alias

  // input.required() — explícito
  readonly tenantId = input.required<TenantId>();

  // output() — devuelve emitter
  readonly select = output<Sku>();
  readonly close = output<void>();

  // model() — two-way (input + output como par)
  readonly expanded = model<boolean>(false);

  // inject() — función pura, en contexto de injection
  private readonly inv = inject(IInventoryProvider);
  private readonly nav = inject(INavigationProvider);

  // estado derivado — atom derivado
  readonly sku = derivedAsync(() => this.inv.getSku(this.skuId()));

  // viewChild() — referencia a hijo en template
  readonly priceTag = viewChild<PriceTag>('price-tag');

  onPriceClick(evt: MouseEvent) {
    this.select.emit(this.sku()!);
  }
}
```

### 2.2 Ventajas del modelo

- **Tipado preciso.** `input<T>()` lleva el tipo en el genérico; el atom es `Atom<T>`.
- **Reactividad nativa.** El template se re-evalúa solo donde un atom cambia — no rerender de componente entero.
- **Sin metaprogramación oculta.** No hay `Object.defineProperty` mágica sobre los campos; lo que ves es lo que hay.
- **Composabilidad.** `input()` y `output()` se pasan, se derivan, se componen como cualquier atom.
- **Tree-shakeable.** Solo se incluye lo que se usa.

---

## 3. Templates

### 3.1 `html\`\``

Tagged template literal **propio** — no `lit-html`, no Angular template compiler.

- Parser produce `PreparedTemplate` con marcadores tipados (`ControlFlowNode`, `ControlFlowBranch`, `TemplateContext`, `TemplateSlot`).
- Las interpolaciones son **expresiones** que se re-ejecutan cuando un atom leído cambia.
- Bindings:
  - `[prop]="expr"` — property binding.
  - `(event)="handler($event)"` — event binding.
  - `[(model)]="atom"` — two-way con `model()`.
  - `{{ expr }}` — text interpolation.
  - `*directive="expr"` — structural directives (rara; se prefiere control flow).

### 3.2 Control flow

```html
@if (cond()) { ... } @else if (other()) { ... } @else { ... }

@for (item of items(); track item.id) { ... }
@empty { <p>Sin elementos</p> }

@switch (state()) {
  @case ('loading') { <spinner /> }
  @case ('ready') { <view /> }
  @default { <error /> }
}
```

- Reactivo: cambia de rama si la condición/colección cambia.
- `@for` con `track` exigido — sin track, error en compile-time del template.

### 3.3 Slots de contenido

```html
<card>
  <slot name="header"><h2>Default header</h2></slot>
  <slot>{{ /* default slot */ }}</slot>
</card>
```

- Sintaxis Web Components-style.
- Permite composición padre-hijo sin acoplar.

---

## 4. Estilos

### 4.1 `styles: css\`\``

Tagged template para CSS scoped real:

- Parser inyecta atributo único por instancia/clase de componente.
- Cada selector se transforma con el atributo → encapsulación garantizada.
- Soporta variables CSS de `@vortech/theming`.

### 4.2 `:host`, `:host-context`, `::part`

Sintaxis Web Components-aware. `@vortech/components` no usa Shadow DOM por default (mejor DX en devtools), pero soporta `encapsulation: 'shadow'` por componente cuando aporta.

### 4.3 Theming

- Tokens CSS desde `@vortech/theming` (`--vortech-color-primary`, `--vortech-spacing-md`, etc.).
- Componentes consumen tokens — el tema se cambia inyectando `IThemeProvider` y rotando variables raíz.

---

## 5. DI dentro de componentes

- `inject()` invocable solo en **contexto de injection**: constructor, factory, o función `runInInjectionContext`.
- `providers: []` en `@Component({...})` declara providers de scope-componente.
- Hijos heredan injectors padre por default; aislan con sub-Injector si lo declaran.
- Ciclo de vida del Injector atado al ciclo de vida del componente — destruirse libera providers scoped.

---

## 6. Ciclo de vida

Hooks (todos opcionales):

| Hook | Cuándo |
|---|---|
| `onInit()` | Tras inputs iniciales aplicados |
| `onConnect()` | Insertado en DOM |
| `onDisconnect()` | Removido del DOM (puede reconectarse) |
| `onDestroy()` | Disposición final, libera scope DI |

**No hay** `ngOnChanges` — los cambios de input son atoms; cualquier `derived` reacciona automáticamente. **No hay** `ngAfterViewChecked` — sin digest cycle, no aplica.

---

## 7. Pipes

```ts
@Pipe({ name: 'currency' })
export class CurrencyPipe implements IPipe<Money, string> {
  transform(value: Money, locale: string = 'es-CL'): string {
    return Intl.NumberFormat(locale, { style: 'currency', currency: value.currency })
      .format(value.amount);
  }
}
```

Uso: `{{ price() | currency:'es-CL' }}`.

- Pipes son **funciones puras** (clases con un único `transform`).
- Cacheable por entrada cuando son puros (default).

---

## 8. Reglas invariantes

1. **Cero Zone.** Nada de `Zone.js`, nada de `NgZone`.
2. **Decoradores solo de clase.** `@Input()` / `@Output()` / `@Inject()` de campo no existen.
3. **Atoms son la única fuente de reactividad.** No `BehaviorSubject`, no `EventEmitter` framework.
4. **Templates 100% tipados** — `skuId()` debe devolver `SkuId`, no `any`.
5. **Sin imports de Angular / React / Vue / Lit / Solid** en componentes Vortech.
6. **`track` obligatorio en `@for`.**
7. **Encapsulación de estilos por default.**

---

## 9. Qué no es

- **No es Angular.** Inspiración superficial, no importación.
- **No es Lit.** Tagged templates parecidos pero parser propio y modelo reactivo distinto.
- **No es Solid.** Modelo de signals similar pero con decoradores y DI.
- **No es Web Components puros.** Puede compilar a Custom Elements opcionalmente.

---

## 10. Inspiración

- **Angular zoneless / signal-based** — decoradores de clase + funciones reactivas (input/output/inject).
- **Solid** — modelo de signals fine-grained, sin VDOM.
- **Lit** — tagged templates, encapsulación.
- **Web Components** — slots, custom elements, scoped styling.
- **Stencil** — modelo de compilación AOT a Custom Elements.

Leídos como fuente; no adoptados como dependencia.
