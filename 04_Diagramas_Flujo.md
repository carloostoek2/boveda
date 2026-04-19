# Diagramas de Flujo de Usuario
## PromptVault - Sistema de Repositorio de Prompts

**Versión:** 1.0  
**Fecha:** 14 de Abril 2026  

---

## 1. Flujo Principal: Crear Prompt con Análisis IA

```mermaid
flowchart TD
    A[Usuario abre app] --> B[Click en + Nuevo Prompt]
    B --> C[Abre Modal de Creación]
    C --> D[Escribe/Pega Prompt]
    D --> E{¿Agregar imagen?}
    E -->|Sí| F[Drop/Seleccionar Imagen]
    E -->|No| G[Click en Analizar y Guardar]
    F --> G
    G --> H[Modal se cierra]
    H --> I[Toast: Procesando...]
    I --> J[Sistema encola análisis IA]
    J --> K[Worker procesa con OpenRouter]
    K --> L{¿Análisis exitoso?}
    L -->|Sí| M[Guarda metadata extraída]
    L -->|No| N[Guarda como manual]
    M --> O[Toast: ¡Prompt guardado!]
    N --> P[Toast: Guardado manualmente]
    O --> Q[Tarjeta aparece en Grid]
    P --> Q
```

---

## 2. Flujo: Crear Prompt sin Análisis

```mermaid
flowchart TD
    A[Usuario abre app] --> B[Click en + Nuevo Prompt]
    B --> C[Abre Modal de Creación]
    C --> D[Escribe/Pega Prompt]
    D --> E{¿Agregar imagen?}
    E -->|Sí| F[Drop/Seleccionar Imagen]
    E -->|No| G[Click en Guardar sin analizar]
    F --> G
    G --> H[Guardado inmediato]
    H --> I[Toast: Prompt guardado]
    I --> J[Tarjeta aparece en Grid]
    J --> K{¿Usuario quiere editar?}
    K -->|Sí| L[Abre Modal de Edición]
    K -->|No| M[Fin]
    L --> N[Usuario agrega metadata manual]
    N --> O[Guardar cambios]
    O --> P[Tarjeta actualizada]
```

---

## 3. Flujo: Ver y Editar Prompt

```mermaid
flowchart TD
    A[Usuario en Grid de Prompts] --> B[Click en Tarjeta]
    B --> C[Abre Modal de Detalle]
    C --> D[Ver información completa]
    D --> E{¿Acción del usuario?}
    
    E -->|Copiar Prompt| F[Copiar al portapapeles]
    F --> G[Toast: Copiado!]
    G --> D
    
    E -->|Toggle Favorito| H[Cambiar estado favorito]
    H --> I[Actualizar UI]
    I --> D
    
    E -->|Editar| J[Abrir modo edición]
    J --> K[Modificar campos]
    K --> L[Guardar cambios]
    L --> M[Toast: Actualizado]
    M --> C
    
    E -->|Eliminar| N[Confirmar eliminación]
    N --> O{¿Confirmar?}
    O -->|Sí| P[Eliminar prompt]
    P --> Q[Toast: Eliminado]
    Q --> R[Cerrar modal]
    O -->|No| D
    
    E -->|Cerrar| S[Cerrar modal]
```

---

## 4. Flujo: Búsqueda y Filtrado

```mermaid
flowchart TD
    A[Usuario en Grid] --> B{¿Tipo de búsqueda?}
    
    B -->|Texto libre| C[Escribir en SearchBox]
    C --> D[Búsqueda en tiempo real]
    D --> E[Resultados filtrados]
    
    B -->|Filtros| F[Abrir panel de filtros]
    F --> G[Seleccionar categoría]
    G --> H[Seleccionar subcategoría]
    H --> I[Seleccionar tags]
    I --> J[Toggle favoritos]
    J --> K[Aplicar filtros]
    K --> E
    
    E --> L{¿Encontrado?}
    L -->|Sí| M[Click en tarjeta]
    M --> N[Ver detalle]
    L -->|No| O[Mensaje: No results]
    O --> P{¿Limpiar filtros?}
    P -->|Sí| Q[Resetear filtros]
    Q --> A
    P -->|No| R[Fin]
```

---

## 5. Flujo: Análisis IA en Background (Detallado)

```mermaid
flowchart TD
    A[Usuario: Analizar y Guardar] --> B[API: Recibe request]
    B --> C[Validar datos]
    C --> D{¿Válido?}
    D -->|No| E[Error 400]
    D -->|Sí| F[Crear registro Prompt]
    F --> G[Status: PROCESSING]
    H --> I[Response 202: Accepted]
    I --> J[Notificar: Procesando]
    
    G --> K[Encolar job en Redis]
    K --> L[Worker consume job]
    L --> M[Llamar OpenRouter API]
    
    M --> N{¿Respuesta exitosa?}
    N -->|Sí| O[Parsear JSON response]
    O --> P[Extraer campos]
    P --> Q[Normalizar tags]
    Q --> R[Actualizar Prompt]
    R --> S[Status: COMPLETED]
    S --> T[Notificar: Completado]
    
    N -->|No| U{¿Reintentar?}
    U -->|Sí, < 3| V[Incrementar attempts]
    V --> W[Delay exponencial]
    W --> M
    U -->|No| X[Status: FAILED]
    X --> Y[Guardar error]
    Y --> Z[Notificar: Fallo]
    Z --> AA[Fallback a manual]
```

---

## 6. Flujo: Gestión de Imágenes

```mermaid
flowchart TD
    A[Usuario en Modal Creación] --> B{¿Subir imagen?}
    B -->|Sí| C[Drag & Drop o Seleccionar]
    C --> D[Validar archivo]
    D --> E{¿Válido?}
    
    E -->|No| F[Error: Formato/Tamaño]
    F --> C
    
    E -->|Sí| G[Mostrar preview]
    G --> H[Optimizar con Sharp]
    H --> I[Convertir a WebP]
    I --> J[Generar miniatura]
    J --> K[Guardar en storage]
    K --> L[Guardar URLs en DB]
    
    B -->|No| M[Continuar sin imagen]
    M --> N[Placeholder en tarjeta]
    
    L --> O[Tarjeta con miniatura]
```

---

## 7. Flujo: Sistema de Tags Inteligente

```mermaid
flowchart TD
    A[IA extrae tags] --> B[Normalizar tags]
    B --> C[Convertir a lowercase]
    C --> D[Eliminar espacios]
    D --> E[Reemplazar con guiones]
    
    E --> F{¿Tag existe?}
    F -->|Sí| G[Incrementar usage_count]
    F -->|No| H[Crear nuevo tag]
    
    G --> I{¿Tags similares?}
    H --> I
    
    I -->|Sí| J[Calcular distancia Levenshtein]
    J --> K{¿Distancia < 2?}
    K -->|Sí| L[Sugerir merge]
    K -->|No| M[Guardar tags]
    L --> N{¿Usuario acepta?}
    N -->|Sí| O[Merge tags]
    N -->|No| M
    
    O --> P[Actualizar prompts]
    P --> Q[Eliminar tag duplicado]
    M --> R[Asociar tags a prompt]
    Q --> R
```

---

## 8. Flujo de Estados del Prompt

```mermaid
stateDiagram-v2
    [*] --> Draft: Usuario escribe
    Draft --> Processing: Click Analizar
    Draft --> Completed: Guardar sin analizar
    
    Processing --> Completed: Análisis exitoso
    Processing --> Failed: Análisis falla
    
    Failed --> Completed: Fallback manual
    Failed --> Processing: Reintentar
    
    Completed --> Editing: Click Editar
    Editing --> Completed: Guardar cambios
    
    Completed --> Deleted: Click Eliminar
    Draft --> Deleted: Cancelar
    Processing --> Deleted: Cancelar
    
    Deleted --> [*]
```

---

## 9. Flujo de Navegación Principal

```mermaid
flowchart TD
    A[Página Principal] --> B[Grid de Prompts]
    
    B --> C[Barra de Búsqueda]
    B --> D[Filtros]
    B --> E[Botón Nuevo]
    B --> F[Grid Tarjetas]
    
    C --> G[Filtrar por texto]
    D --> H[Filtrar por categoría/tags]
    
    E --> I[Modal Creación]
    F --> J[Modal Detalle]
    
    I --> K[Input Prompt]
    I --> L[Drop Imagen]
    I --> M[Botón Analizar]
    I --> N[Botón Guardar Manual]
    
    J --> O[Ver Detalle]
    J --> P[Botón Copiar]
    J --> Q[Botón Favorito]
    J --> R[Botón Editar]
    J --> S[Botón Eliminar]
    
    R --> T[Modal Edición]
    T --> U[Editar campos]
    U --> V[Guardar cambios]
```

---

## 10. Flujo de Notificaciones

```mermaid
flowchart TD
    A[Evento ocurre] --> B{¿Tipo de evento?}
    
    B -->|Procesando| C[Toast info]
    C --> D[Spinner animado]
    D --> E[Auto-dismiss: No]
    
    B -->|Éxito| F[Toast success]
    F --> G[Icono check]
    G --> H[Auto-dismiss: 3s]
    
    B -->|Error| I[Toast error]
    I --> J[Icono X]
    J --> K[Auto-dismiss: 5s]
    K --> L[Botón reintentar]
    
    B -->|Info| M[Toast info]
    M --> N[Icono info]
    N --> O[Auto-dismiss: 3s]
    
    E --> P{¿Completó?}
    P -->|Sí| F
    P -->|No| Q[Timeout]
    Q --> I
```

---

## 11. Flujo de Interacción Móvil (Touch)

```mermaid
flowchart TD
    A[Usuario en móvil] --> B[Scroll vertical]
    B --> C[Ver tarjetas]
    
    C --> D{¿Interacción?}
    
    D -->|Tap tarjeta| E[Abrir modal detalle]
    D -->|Long press| F[Menú contextual]
    D -->|Pull down| G[Refresh lista]
    D -->|Swipe tarjeta| H[Acciones rápidas]
    
    F --> I[Opciones: Editar, Eliminar, Copiar]
    H --> J[Mostrar botones: Favorito, Eliminar]
    
    E --> K[Scroll en modal]
    K --> L[Ver toda la info]
    
    G --> M[Recargar datos]
    M --> C
```

---

## 12. Flujo de Exportar/Importar (Futuro)

```mermaid
flowchart TD
    A[Menú Configuración] --> B{¿Acción?}
    
    B -->|Exportar| C[Seleccionar prompts]
    C --> D[Elegir formato]
    D --> E[JSON]
    D --> F[CSV]
    E --> G[Generar archivo]
    F --> G
    G --> H[Download]
    
    B -->|Importar| I[Seleccionar archivo]
    I --> J[Validar formato]
    J --> K{¿Válido?}
    K -->|No| L[Error: Formato inválido]
    K -->|Sí| M[Parsear datos]
    M --> N[Validar cada prompt]
    N --> O[Importar a DB]
    O --> P[Toast: Importados X prompts]
```

---

## Leyenda de Símbolos

| Símbolo | Significado |
|---------|-------------|
| ⭕ | Inicio/Fin |
| ▭ | Proceso/Acción |
| ◇ | Decisión |
| → | Flujo de dirección |
| ⚡ | Evento asíncrono |

---

**Notas:**
- Estos diagramas representan los flujos principales
- Algunos flujos pueden tener variaciones según edge cases
- Los flujos de error están simplificados para claridad
