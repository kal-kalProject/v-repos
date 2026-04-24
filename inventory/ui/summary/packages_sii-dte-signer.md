---
kind: package-summary
repo: ui
package_name: "@vortech/security"
package_path: packages/sii-dte-signer
language: ts
manifest: package.json
inventoried_at: 2026-04-24T00:00:00Z
inventoried_by: copilot-inventario
source_repo: ui
source_commit: 2c226b12f89365eba996cee9abc8641bb4c86363
madurez: experimental
---

## 1. Identidad

| Campo         | Valor                                      |
|---------------|--------------------------------------------|
| name          | `@vortech/security`                        |
| version       | 0.0.1                                      |
| directorio    | `packages/sii-dte-signer`                  |
| type          | module (ESM)                               |
| private       | true                                       |
| entrypoint    | `dist/index.mjs`                           |
| types         | `dist/index.d.mts`                         |

> **Nota crítica:** El nombre del paquete (`@vortech/security`) no coincide con el nombre del directorio (`sii-dte-signer`). El propósito real es firma/validación DTE para el SII chileno, más un conversor XSD→JSON Schema y utilidades CSV, lo que sugiere un rename incompleto o una agrupación de seguridad más amplia planeada.

## 2. Propósito

### 2.1 Declarado

No hay campo `description` en `package.json`.

### 2.2 Inferido + Evidencia

El paquete agrupa herramientas para interoperar con el **SII (Servicio de Impuestos Internos) de Chile** en el contexto de **Documentos Tributarios Electrónicos (DTE)**:

- **Firma digital de DTE**: usa `xml-crypto`, `node-forge`, `jose` — criptografía XML y JWT.
- **Validación XSD → JSON Schema**: directorio `src/shcema/` [typo] — conversor `XsdConverter` + generador de contratos de runtime.
- **Autenticación ante el SII**: `src/sii/` contiene `SiiClient`.
- **Utilidades CSV**: `CsvSchemaBuilder`, `CsvConfigBuilder`, `parseCsv`, `writeCsvFile` — probablemente para exportar datos tributarios.

Evidencia: `packages/sii-dte-signer/src/index.ts:1-40`.

## 3. Superficie pública

Entry points (campo `exports`):

| Export | Archivo dist           |
|--------|------------------------|
| `.`    | `dist/index.mjs`       |

Símbolos clave exportados desde `src/index.ts`:

- **Certificados**: `CertificateContract`, `CertificateValidationResult` (solo tipos)
- **XSD**: `XsdConverter`, `convertXsdFile`, `convertXsdString`, `XsdConverterOptions`, `XsdConversionResult`, `JsonSchema7`
- **Models generator**: `buildModelsFromXsd`, `createRuntimeValidatorFromSchema`, `generateContractsFromSchema`, + tipos asociados
- **SII**: `Certificate`, `SiiClient`
- **CSV**: `CsvSchemaBuilder`, `CsvConfigBuilder`, `parseCsv`, `writeCsvFile`, `compareCsv`, `stringConverter`, `optionalStringConverter`, `rutValidator`, `emailValidator`

## 4. Dependencias

### 4.1 Internas

| Paquete          | Tipo       |
|------------------|------------|
| `@vortech/apis`  | runtime    |

### 4.2 Externas

| Paquete           | Versión     | Propósito                        |
|-------------------|-------------|----------------------------------|
| `@xmldom/xmldom`  | ^0.8.11     | Parseo XML en Node.js            |
| `ajv`             | ^8.18.0     | Validación JSON Schema           |
| `ajv-formats`     | ^3.0.1      | Formatos adicionales para ajv    |
| `jose`            | 6.1.3       | JWT / JWS / JWK                  |
| `node-forge`      | ^1.3.3      | Criptografía (certificados X.509)|
| `xml-crypto`      | ^6.1.2      | Firma digital XML (XMLDSig)      |

## 5. Consumidores internos

No se encontraron referencias a `@vortech/security` o `sii-dte-signer` en los `package.json` del workspace en la revisión estática. Probable uso desde proyectos/servicios fuera del directorio `packages/`.

## 6. Estructura interna

```
packages/sii-dte-signer/src/
├── certificates/     # Loader y tipos de certificados X.509
├── cryptography/     # Primitivas de firma y verificación
├── csv/              # Parser, writer y schema builder para CSV
├── index.ts          # Barrel público
├── shcema/           # [typo: debería ser "schema"] XSD→JSON Schema + models generator
└── sii/              # Cliente SII (autenticación, envío DTE)
```

> **Typo**: `src/shcema/` tiene una 'h' transpuesta — debería ser `schema/`. `packages/sii-dte-signer/src/index.ts:4`.

## 7. Estado

| Campo          | Valor                                                                 |
|----------------|-----------------------------------------------------------------------|
| Madurez        | experimental                                                          |
| Justificación  | v0.0.1 private, nombre incoherente con directorio, typo en src/, sin descripción en manifest |
| Build          | no ejecutado (inventario estático)                                    |
| Tests          | No detectados (`scripts` no incluye `test`)                          |
| Último cambio  | desconocido (no se accedió a git log)                                 |

## 8. Dominios que toca

- Firma digital / criptografía XML
- Integración regulatoria (SII Chile / DTE)
- Transformación de esquemas (XSD → JSON Schema → contratos TS)
- Validación de datos (CSV, RUT, email)

## 9. Observaciones

- La discrepancia entre nombre de paquete (`@vortech/security`) y directorio (`sii-dte-signer`) indica una refactorización incompleta. El nombre `security` es demasiado genérico para lo que hace.
- `jose` está fijado a una versión exacta (6.1.3), no a un rango — posible pin por breaking changes.
- La función `loadCertificate` está comentada en el barrel (`// export { loadCertificate }`) — API en progreso.

## 10. Hipótesis

- El directorio `sii-dte-signer` fue el nombre original y se intentó renombrar el paquete a `@vortech/security` para que pudiera albergar utilidades criptográficas más generales, pero la migración quedó inconclusa.
- `SiiClient` probablemente gestiona la autenticación por certificado ante el web service del SII (folios, envío de sobres XML).

## 11. Preguntas abiertas

1. ¿Por qué `loadCertificate` está comentada? ¿Rotura de API o funcionalidad movida?
2. ¿El nombre `@vortech/security` es intencional y se planea ampliar el scope más allá del SII?
3. ¿Hay planes de hacer el paquete público (`private: true` actualmente)?
4. ¿Quién consume `SiiClient`? ¿Existe un proyecto específico de facturación electrónica?
