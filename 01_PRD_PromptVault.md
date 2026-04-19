# Product Requirements Document (PRD)
## PromptVault - Sistema de Repositorio de Prompts

**Versión:** 1.0  
**Fecha:** 14 de Abril 2026  
**Estado:** Borrador para aprobación  

---

## 1. Resumen Ejecutivo

### 1.1 Visión del Producto
PromptVault es una aplicación web personal de gestión de prompts que permite a usuarios individuales organizar, categorizar y recuperar eficientemente sus prompts de IA. El sistema utiliza análisis automático mediante IA para extraer metadata estructurada, eliminando la fricción de la organización manual.

### 1.2 Propuesta de Valor
- **Cero fricción:** El usuario solo escribe el prompt, la IA hace el resto
- **Organización inteligente:** Categorización y tagging automático
- **Recuperación rápida:** Búsqueda y filtros potentes
- **Mobile-first:** Diseñado primero para uso en dispositivos móviles

### 1.3 Alcance del MVP
- Gestión personal de prompts (sin autenticación, local-first)
- Análisis asíncrono con IA vía OpenRouter
- Categorización flexible con estructura base + tags dinámicos
- Subida de imágenes de ejemplo
- Interfaz tipo tarjetas con vista modal de detalle

---

## 2. Requisitos Funcionales

### 2.1 Gestión de Prompts

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| FR-001 | Crear nuevo prompt con análisis IA | Alta |
| FR-002 | Crear nuevo prompt sin análisis (modo manual) | Alta |
| FR-003 | Editar prompt existente (título, descripción, tags, metadata) | Alta |
| FR-004 | Eliminar prompt | Alta |
| FR-005 | Duplicar prompt existente | Media |
| FR-006 | Copiar prompt al portapapeles | Alta |

### 2.2 Análisis con IA

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| FR-007 | Análisis asíncrono en background | Alta |
| FR-008 | Extracción automática: título, descripción, tags, categoría, subcategoría | Alta |
| FR-009 | Notificación toast cuando el análisis completa | Alta |
| FR-010 | Fallback a modo manual si el análisis falla | Media |

### 2.3 Categorización y Metadata

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| FR-011 | Categorías predefinidas: Imagen, Video, Texto, Audio | Alta |
| FR-012 | Subcategorías específicas por tipo (ej: estilo, pose, cámara para imágenes) | Alta |
| FR-013 | Sistema de tags controlado (evitar duplicados/similares) | Alta |
| FR-014 | Tags sugeridos por IA con validación de usuario | Media |
| FR-015 | Campo libre para metadata técnica adicional | Media |

### 2.4 Gestión de Medios

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| FR-016 | Subir imagen de ejemplo (1 por prompt) | Alta |
| FR-017 | Generar miniatura automática de la imagen subida | Media |
| FR-018 | Visualizar imagen en modal de detalle | Alta |
| FR-019 | Eliminar/reemplazar imagen | Media |

### 2.5 Interfaz de Usuario

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| FR-020 | Vista de tarjetas (grid responsive) | Alta |
| FR-021 | Modal de creación rápida (solo campo de prompt) | Alta |
| FR-022 | Modal de detalle con toda la información | Alta |
| FR-023 | Expansión del prompt en modal (show/hide) | Alta |
| FR-024 | Favoritos con toggle rápido | Media |
| FR-025 | Búsqueda por texto | Alta |
| FR-026 | Filtros por categoría, tags, favoritos | Alta |
| FR-027 | Ordenamiento por fecha, nombre, favoritos | Media |
| FR-028 | Diseño mobile-first, responsive | Alta |

### 2.6 Sistema de Tags Inteligente

| ID | Requisito | Prioridad |
|----|-----------|-----------|
| FR-029 | Normalización de tags (lowercase, sin espacios) | Alta |
| FR-030 | Sugerencia de tags existentes al escribir | Media |
| FR-031 | Merge de tags similares (ej: "anime" y "Anime") | Media |
| FR-032 | Tags técnicos para prompts avanzados | Media |

---

## 3. Requisitos No Funcionales

### 3.1 Rendimiento
- Tiempo de carga inicial: < 2 segundos en 3G
- Análisis IA: procesamiento en background sin bloquear UI
- Búsqueda: resultados en < 100ms para < 1000 prompts

### 3.2 Escalabilidad
- Soporte para 10,000+ prompts por usuario
- Imágenes: optimización automática (WebP, max 2MB)

### 3.3 Compatibilidad
- Navegadores: Chrome, Firefox, Safari, Edge (últimas 2 versiones)
- Dispositivos: Mobile (iOS/Android), Tablet, Desktop

### 3.4 Seguridad
- Sanitización de inputs de usuario
- Validación de tipos de archivo (imágenes: jpg, png, webp)
- Sin datos sensibles (no auth, local-first)

### 3.5 Disponibilidad
- Offline-first: funcionalidad básica sin conexión
- Sincronización cuando hay conexión

---

## 4. Flujos de Usuario Principales

### 4.1 Crear Prompt con Análisis IA
```
1. Usuario abre modal de creación
2. Escribe/pega el prompt
3. Click en "Analizar y Guardar"
4. Modal se cierra, notificación "Procesando..."
5. IA analiza en background
6. Notificación "Prompt guardado exitosamente"
7. Tarjeta aparece en grid con datos extraídos
```

### 4.2 Crear Prompt sin Análisis
```
1. Usuario abre modal de creación
2. Escribe/pega el prompt
3. Click en "Guardar sin analizar"
4. Prompt se guarda inmediatamente con datos mínimos
5. Usuario puede editar después para agregar metadata
```

### 4.3 Editar Prompt
```
1. Usuario hace click en tarjeta
2. Se abre modal de detalle
3. Click en "Editar"
4. Usuario modifica cualquier campo
5. Guardar cambios
```

### 4.4 Buscar y Filtrar
```
1. Usuario escribe en barra de búsqueda
2. Resultados se filtran en tiempo real
3. Usuario puede aplicar filtros adicionales (categoría, tags)
4. Click en tarjeta para ver detalle
```

---

## 5. Estructura de Categorías y Metadata

### 5.1 Categorías Base

```
📁 IMAGEN
   ├── Estilo: fotorealista, anime, ilustración, 3d, pintura, pixel-art, etc.
   ├── Pose/Composición: retrato, panorámica, primer-plano, medio-cuerpo, etc.
   ├── Cámara/Lente: 35mm, 50mm, 85mm, gran-angular, telefoto, etc.
   ├── Iluminación: natural, estudio, contraluz, dorada, etc.
   └── Aspect Ratio: 1:1, 16:9, 9:16, 4:3, etc.

📁 VIDEO
   ├── Duración: corto, medio, largo
   ├── Estilo Movimiento: estático, pan, zoom, tracking
   └── Transiciones: suave, abrupta, etc.

📁 TEXTO
   ├── Tipo: copywriting, código, análisis, creativo, resumen, traducción
   ├── Tono: profesional, casual, humorístico, académico, persuasivo
   └── Longitud: corto, medio, largo

📁 AUDIO
   ├── Tipo: voz, música, efectos
   ├── Estilo: narrativo, conversacional, musical
   └── Género: (para música) rock, electrónica, clásica, etc.
```

### 5.2 Sistema de Tags
- **Tags sugeridos por IA:** Basados en contenido del prompt
- **Tags técnicos:** Para prompts avanzados (color-correction, post-proceso, etc.)
- **Tags personalizados:** Usuario puede crear los suyos
- **Control de calidad:** Normalización y deduplicación automática

---

## 6. Mockups y Referencias Visuales

### 6.1 Referencias de Diseño
- **Instagram:** Grid de tarjetas, navegación táctil
- **Notion:** Limpieza, organización, modalidad
- **Pinterest:** Descubrimiento visual, filtros

### 6.2 Principios de Diseño
- Mobile-first: todo diseñado primero para móvil
- Minimalista: información solo cuando se necesita
- Táctil: botones grandes, gestos intuitivos
- Feedback: estados de carga, notificaciones, transiciones

---

## 7. Métricas de Éxito

### 7.1 KPIs
- Tiempo para crear un prompt: < 30 segundos
- Tiempo para encontrar un prompt: < 10 segundos
- Tasa de prompts analizados vs manuales: > 70% IA
- Satisfacción: NPS > 50

### 7.2 Métricas Técnicas
- Tiempo de análisis IA: < 10 segundos promedio
- Uptime: > 99%
- Performance score (Lighthouse): > 90

---

## 8. Roadmap

### Fase 1: MVP (Mes 1)
- [ ] CRUD de prompts
- [ ] Análisis IA básico
- [ ] Grid de tarjetas
- [ ] Modal de detalle
- [ ] Filtros básicos

### Fase 2: Mejoras (Mes 2)
- [ ] Sistema de tags inteligente
- [ ] Búsqueda avanzada
- [ ] Favoritos
- [ ] Optimización de imágenes

### Fase 3: Escalabilidad (Mes 3)
- [ ] Autenticación opcional
- [ ] Sync entre dispositivos
- [ ] Exportar/Importar
- [ ] Extensiones de navegador

---

## 9. Glosario

- **Prompt:** Instrucción de texto para modelos de IA generativa
- **Metadata:** Información estructurada sobre el prompt (categoría, tags, etc.)
- **Análisis IA:** Proceso de extracción automática de metadata mediante LLM
- **Tag:** Etiqueta descriptiva para clasificación
- **Modal:** Ventana emergente para interacciones focalizadas

---

## 10. Aprobaciones

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| Product Owner | | | |
| Tech Lead | | | |
| Stakeholder | | | |

---

**Notas:**
- Este PRD es un documento vivo y puede actualizarse
- Las prioridades pueden ajustarse según feedback
- Las estimaciones de tiempo son aproximadas
