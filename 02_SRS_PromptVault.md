# Software Requirements Specification (SRS)
## PromptVault - Sistema de Repositorio de Prompts

**Versión:** 1.0  
**Fecha:** 14 de Abril 2026  
**Estado:** Borrador  

---

## 1. Introducción

### 1.1 Propósito
Este documento especifica los requisitos técnicos detallados para el desarrollo de PromptVault, un sistema de gestión de prompts personales con análisis automático mediante IA.

### 1.2 Alcance
El sistema será una aplicación web progresiva (PWA) con:
- Frontend React con TypeScript
- Backend Node.js/Express
- Base de datos PostgreSQL
- Almacenamiento de archivos local/S3
- Integración con OpenRouter para análisis IA

### 1.3 Definiciones y Acrónimos
- **PWA:** Progressive Web App
- **API:** Application Programming Interface
- **LLM:** Large Language Model
- **CRUD:** Create, Read, Update, Delete
- **REST:** Representational State Transfer
- **JSON:** JavaScript Object Notation
- **JWT:** JSON Web Token
- **ORM:** Object-Relational Mapping

---

## 2. Descripción General

### 2.1 Perspectiva del Producto
PromptVault es una aplicación standalone que no depende de otros sistemas, excepto por:
- OpenRouter API (servicio externo)
- Servicio de almacenamiento de archivos

### 2.2 Funciones del Producto
1. Gestión completa de prompts (CRUD)
2. Análisis automático con IA
3. Categorización y tagging
4. Gestión de imágenes
5. Búsqueda y filtrado
6. Interfaz responsive mobile-first

### 2.3 Restricciones
- Compatible con Railway (containerization)
- Sin autenticación en MVP
- Presupuesto limitado (uso de servicios gratuitos donde sea posible)

---

## 3. Requisitos Funcionales Detallados

### 3.1 Módulo: Gestión de Prompts

#### RF-3.1.1 Crear Prompt
**Descripción:** El sistema debe permitir crear nuevos prompts.

**Entradas:**
- Contenido del prompt (texto, obligatorio)
- Imagen de ejemplo (archivo, opcional)
- Flag de análisis IA (booleano, opcional, default: true)

**Proceso:**
1. Validar que el prompt no esté vacío
2. Si hay imagen, validar formato (jpg, png, webp) y tamaño (< 10MB)
3. Si análisis IA = true, encolar para procesamiento
4. Si análisis IA = false, guardar con metadata mínima
5. Generar miniatura si hay imagen

**Salidas:**
- Prompt creado con ID único
- Confirmación de guardado
- Notificación de estado (procesando/completado)

**Casos de Error:**
- Prompt vacío: Error 400
- Imagen inválida: Error 400
- Fallo en análisis IA: Guardar como manual + notificación

#### RF-3.1.2 Leer Prompt
**Descripción:** Recuperar información de un prompt específico.

**Entradas:**
- ID del prompt

**Salidas:**
- Datos completos del prompt
- URL de imagen (si existe)
- Metadata extraída

#### RF-3.1.3 Actualizar Prompt
**Descripción:** Modificar datos de un prompt existente.

**Campos Editables:**
- Título
- Descripción
- Contenido del prompt
- Categoría y subcategoría
- Tags
- Imagen (reemplazar/eliminar)
- Metadata técnica adicional

**Restricciones:**
- No se puede editar el ID
- Fecha de creación no modificable
- Fecha de actualización se actualiza automáticamente

#### RF-3.1.4 Eliminar Prompt
**Descripción:** Eliminar permanentemente un prompt.

**Proceso:**
1. Confirmación de usuario
2. Eliminar registro de base de datos
3. Eliminar imagen asociada del storage
4. Eliminar miniatura

### 3.2 Módulo: Análisis con IA

#### RF-3.2.1 Procesamiento Asíncrono
**Descripción:** El análisis IA debe ejecutarse en background.

**Arquitectura:**
- Cola de tareas (Bull/BullMQ con Redis)
- Worker independiente para procesamiento
- API endpoint para encolar trabajos

**Flujo:**
```
1. Cliente POST /api/prompts/analyze
2. Servidor crea registro con status="processing"
3. Encola trabajo en Redis
4. Worker consume trabajo
5. Worker llama OpenRouter API
6. Worker parsea respuesta
7. Worker actualiza registro con status="completed"
8. Servidor notifica cliente vía WebSocket/SSE
```

#### RF-3.2.2 Extracción de Metadata
**Descripción:** La IA debe extraer campos estructurados.

**Prompt de Sistema para IA:**
```
Analiza el siguiente prompt y extrae la información en formato JSON:
{
  "title": "Título conciso y descriptivo (max 100 chars)",
  "description": "Descripción breve de qué hace el prompt (max 300 chars)",
  "category": "Una de: imagen, video, texto, audio",
  "subcategory": "Subcategoría específica según la categoría",
  "tags": ["array", "de", "tags", "relevantes"],
  "metadata": {
    // Campos específicos según categoría
  },
  "confidence": 0.0-1.0 // Confianza del análisis
}
```

**Campos por Categoría:**

**Imagen:**
- style: fotorealista, anime, ilustración, 3d, pintura, etc.
- pose: retrato, panorámica, primer-plano, etc.
- camera: 35mm, 50mm, gran-angular, etc.
- lighting: natural, estudio, contraluz, etc.
- aspect_ratio: 1:1, 16:9, 9:16, etc.

**Video:**
- duration: corto, medio, largo
- movement: estático, pan, zoom, tracking
- transitions: suave, abrupta

**Texto:**
- type: copywriting, código, análisis, creativo, resumen
- tone: profesional, casual, humorístico, académico
- length: corto, medio, largo

**Audio:**
- type: voz, música, efectos
- style: narrativo, conversacional, musical
- genre: rock, electrónica, clásica, etc.

#### RF-3.2.3 Manejo de Errores
**Escenarios:**
- Timeout de OpenRouter: Reintentar 3 veces, luego fallback
- Respuesta inválida: Guardar como manual + log
- Rate limiting: Delay y reintentar
- Servicio no disponible: Notificar usuario, guardar como manual

### 3.3 Módulo: Categorización

#### RF-3.3.1 Estructura Jerárquica
```
Categoría (nivel 1)
  └── Subcategoría (nivel 2)
        └── Atributos específicos (nivel 3)
```

#### RF-3.3.2 Sistema de Tags
**Reglas de Normalización:**
1. Convertir a lowercase
2. Eliminar espacios al inicio/final
3. Reemplazar espacios múltiples por uno
4. Reemplazar espacios internos con guiones
5. Eliminar caracteres especiales (excepto guiones)

**Ejemplos:**
- "Anime Style" → "anime-style"
- "  Color  Correction  " → "color-correction"
- "B&W" → "bw"

**Deduplicación:**
- Crear índice único en base de datos
- Sugerir tags existentes al usuario
- Merge automático de tags similares (Levenshtein distance < 2)

### 3.4 Módulo: Gestión de Imágenes

#### RF-3.4.1 Subida de Imágenes
**Especificaciones:**
- Formatos permitidos: image/jpeg, image/png, image/webp
- Tamaño máximo: 10MB
- Dimensiones recomendadas: 1200x1200px máximo

**Proceso:**
1. Validar formato y tamaño
2. Generar nombre único: `{uuid}-{timestamp}.{ext}`
3. Optimizar imagen (WebP, calidad 85%)
4. Guardar en storage
5. Generar miniatura (300x300px, WebP)
6. Guardar URLs en base de datos

#### RF-3.4.2 Generación de Miniaturas
**Especificaciones:**
- Tamaño: 300x300px
- Formato: WebP
- Calidad: 80%
- Object-fit: cover

#### RF-3.4.3 Eliminación de Imágenes
- Eliminar archivo original
- Eliminar miniatura
- Actualizar registro (setear image_url a null)

### 3.5 Módulo: Búsqueda y Filtrado

#### RF-3.5.1 Búsqueda por Texto
**Campos indexados:**
- title (full-text search)
- description (full-text search)
- content (full-text search)
- tags (exact match + partial)

**Algoritmo:**
- PostgreSQL full-text search con tsvector
- Ranking por relevancia
- Búsqueda fuzzy para typos (pg_trgm)

#### RF-3.5.2 Filtros
**Filtros Disponibles:**
- Categoría (dropdown)
- Subcategoría (dependiente de categoría)
- Tags (multiselect con chips)
- Favoritos (toggle)
- Fecha (rango)

**Comportamiento:**
- Filtros acumulativos (AND)
- Actualización en tiempo real
- URL sync para compartir búsquedas

#### RF-3.5.3 Ordenamiento
**Opciones:**
- Fecha de creación (desc/asc)
- Fecha de actualización (desc/asc)
- Título (A-Z/Z-A)
- Favoritos primero

### 3.6 Módulo: Interfaz de Usuario

#### RF-3.6.1 Vista de Tarjetas (Grid)
**Especificaciones:**
- Layout: CSS Grid
- Columnas responsive:
  - Mobile: 1 columna
  - Tablet: 2 columnas
  - Desktop: 3-4 columnas
- Gap: 16px
- Tarjeta mínima: 280px ancho

**Contenido de Tarjeta:**
- Miniatura de imagen (si existe) o placeholder
- Título (truncado a 2 líneas)
- Preview del prompt (truncado a 3 líneas)
- Tags (máximo 3 visibles)
- Badge de categoría
- Icono de favorito (si aplica)
- Fecha de creación

#### RF-3.6.2 Modal de Creación
**Campos:**
- Textarea para prompt (auto-expandible)
- Toggle "Analizar con IA" (default: on)
- Botón "Guardar sin analizar" (secundario)
- Botón "Analizar y Guardar" (primario)
- Área de drop para imagen (opcional)

**Comportamiento:**
- Cerrar con ESC o click fuera
- Validación en tiempo real
- Loading state en botón primario

#### RF-3.6.3 Modal de Detalle
**Secciones:**
1. Header: Título + acciones (editar, eliminar, favorito)
2. Imagen: Grande con zoom opcional
3. Prompt: Expandible con botón "Copiar"
4. Metadata: Categoría, subcategoría, tags
5. Descripción: Texto libre
6. Footer: Fechas de creación/actualización

**Acciones:**
- Copiar prompt al portapapeles
- Editar (abre modo edición)
- Eliminar (con confirmación)
- Toggle favorito
- Cerrar modal

#### RF-3.6.4 Notificaciones Toast
**Tipos:**
- Éxito: Prompt guardado, análisis completado
- Error: Fallo en análisis, validación
- Info: Procesando, cargando

**Especificaciones:**
- Posición: bottom-right (desktop), bottom-center (mobile)
- Duración: 3-5 segundos
- Auto-dismiss con animación
- Acción de undo cuando aplica

---

## 4. Requisitos de Interfaz

### 4.1 Interfaces de Usuario
- Navegador web moderno
- Soporte táctil
- Soporte para teclado (accesibilidad)

### 4.2 Interfaces de Hardware
- No aplica (web-based)

### 4.3 Interfaces de Software
- OpenRouter API (REST)
- PostgreSQL (SQL)
- Redis (para cola de tareas)
- Sistema de archivos/Storage

### 4.4 Interfaces de Comunicación
- HTTP/HTTPS
- WebSocket (para notificaciones en tiempo real)
- REST API (JSON)

---

## 5. Requisitos No Funcionales Detallados

### 5.1 Rendimiento

| Métrica | Objetivo | Cómo medir |
|---------|----------|------------|
| First Contentful Paint | < 1.5s | Lighthouse |
| Time to Interactive | < 3.5s | Lighthouse |
| API response time (p95) | < 200ms | Monitoring |
| Análisis IA | < 15s | Logs |
| Búsqueda | < 100ms | Logs |

### 5.2 Seguridad
- Sanitización de inputs (XSS prevention)
- Validación de archivos subidos
- Rate limiting en APIs (100 req/min por IP)
- Headers de seguridad (CSP, HSTS, etc.)

### 5.3 Fiabilidad
- Uptime objetivo: 99.5%
- Backup diario de base de datos
- Retry automático en fallos de IA

### 5.4 Mantenibilidad
- Cobertura de tests > 70%
- Documentación de API (OpenAPI/Swagger)
- Logging estructurado
- Monitoreo con alerts

### 5.5 Portabilidad
- Contenedor Docker
- Configuración via variables de entorno
- Sin dependencias de sistema operativo específicas

---

## 6. Modelo de Datos

### 6.1 Entidades Principales

#### Prompt
```
prompts
├── id: UUID (PK)
├── title: VARCHAR(200)
├── description: TEXT
├── content: TEXT (not null)
├── category: VARCHAR(50)
├── subcategory: VARCHAR(50)
├── metadata: JSONB
├── tags: ARRAY<VARCHAR>
├── image_url: VARCHAR(500)
├── thumbnail_url: VARCHAR(500)
├── is_favorite: BOOLEAN (default: false)
├── analysis_status: ENUM('pending', 'processing', 'completed', 'failed')
├── analysis_result: JSONB
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

#### Tag (para normalización)
```
tags
├── id: UUID (PK)
├── name: VARCHAR(100) (unique, not null)
├── normalized_name: VARCHAR(100) (unique, not null)
├── usage_count: INTEGER (default: 0)
├── created_at: TIMESTAMP
└── updated_at: TIMESTAMP
```

#### AnalysisJob (para cola)
```
analysis_jobs
├── id: UUID (PK)
├── prompt_id: UUID (FK)
├── status: ENUM('queued', 'processing', 'completed', 'failed')
├── attempts: INTEGER (default: 0)
├── max_attempts: INTEGER (default: 3)
├── result: JSONB
├── error_message: TEXT
├── created_at: TIMESTAMP
├── started_at: TIMESTAMP
└── completed_at: TIMESTAMP
```

### 6.2 Relaciones
- Prompt 1:N AnalysisJob (un prompt puede tener múltiples intentos)
- Prompt N:M Tag (vía tabla intermedia prompt_tags)

### 6.3 Índices
- prompts(title) - para búsqueda full-text
- prompts(category, subcategory) - para filtros
- prompts(created_at) - para ordenamiento
- tags(normalized_name) - para lookups rápidos

---

## 7. Apéndices

### 7.1 Esquema de API REST

#### Endpoints de Prompts
```
GET    /api/prompts              # Listar prompts (con filtros)
POST   /api/prompts              # Crear prompt
GET    /api/prompts/:id          # Obtener prompt
PUT    /api/prompts/:id          # Actualizar prompt
DELETE /api/prompts/:id          # Eliminar prompt
POST   /api/prompts/:id/favorite # Toggle favorito
```

#### Endpoints de Búsqueda
```
GET /api/prompts/search?q=query&category=imagen&tags=anime
```

#### Endpoints de Tags
```
GET /api/tags              # Listar tags
GET /api/tags/suggest?q=an # Sugerencias
```

#### Endpoints de Análisis
```
POST /api/analysis/queue   # Encolar análisis
GET  /api/analysis/:id     # Estado de análisis
```

### 7.2 Códigos de Error
- 400: Bad Request (validación)
- 404: Not Found
- 422: Unprocessable Entity (datos inválidos)
- 429: Too Many Requests (rate limit)
- 500: Internal Server Error

### 7.3 Referencias
- OpenRouter API Docs: https://openrouter.ai/docs
- PostgreSQL Full Text Search: https://www.postgresql.org/docs/current/textsearch.html
- Railway Docs: https://docs.railway.app/

---

**Historial de Cambios:**
| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 2026-04-14 | - | Documento inicial |
