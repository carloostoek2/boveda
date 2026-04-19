# PromptVault - Documentación Técnica

Sistema de Repositorio de Prompts con Análisis Automático mediante IA

---

## 📁 Estructura de Documentos

Este directorio contiene toda la documentación técnica del proyecto PromptVault.

### 📖 Documentos Principales

| Documento | Descripción | Prioridad |
|-----------|-------------|-----------|
| **[00_RESUMEN_Entregables.md](00_RESUMEN_Entregables.md)** | Resumen ejecutivo, checklist y guía rápida | ⭐⭐⭐ |
| **[01_PRD_PromptVault.md](01_PRD_PromptVault.md)** | Product Requirements Document - Requisitos del producto | ⭐⭐⭐ |
| **[02_SRS_PromptVault.md](02_SRS_PromptVault.md)** | Software Requirements Specification - Especificación técnica detallada | ⭐⭐⭐ |
| **[03_Arquitectura_Tecnica.md](03_Arquitectura_Tecnica.md)** | Arquitectura del sistema y stack tecnológico | ⭐⭐⭐ |
| **[04_Diagramas_Flujo.md](04_Diagramas_Flujo.md)** | Diagramas de flujo de usuario (Mermaid) | ⭐⭐ |
| **[05_Estructura_Base_Datos.md](05_Estructura_Base_Datos.md)** | Esquema de base de datos (Prisma schema) | ⭐⭐⭐ |
| **[06_Prompt_Sistema_OpenRouter.md](06_Prompt_Sistema_OpenRouter.md)** | Prompt de sistema para análisis con IA | ⭐⭐ |

---

## 🚀 Cómo Usar Esta Documentación

### Para Desarrolladores
1. Empezar con **[00_RESUMEN_Entregables.md](00_RESUMEN_Entregables.md)** para entender el alcance
2. Revisar **[03_Arquitectura_Tecnica.md](03_Arquitectura_Tecnica.md)** para entender la arquitectura
3. Consultar **[05_Estructura_Base_Datos.md](05_Estructura_Base_Datos.md)** para el schema de DB
4. Usar **[02_SRS_PromptVault.md](02_SRS_PromptVault.md)** como referencia de implementación

### Para Product Owners
1. Revisar **[01_PRD_PromptVault.md](01_PRD_PromptVault.md)** para requisitos funcionales
2. Ver **[04_Diagramas_Flujo.md](04_Diagramas_Flujo.md)** para flujos de usuario
3. Consultar **[00_RESUMEN_Entregables.md](00_RESUMEN_Entregables.md)** para métricas de éxito

### Para DevOps/Infra
1. Revisar **[03_Arquitectura_Tecnica.md](03_Arquitectura_Tecnica.md)** sección de Railway
2. Consultar **[05_Estructura_Base_Datos.md](05_Estructura_Base_Datos.md)** para configuración DB

---

## 📋 Checklist de Desarrollo

Ver **[00_RESUMEN_Entregables.md](00_RESUMEN_Entregables.md)** sección "Checklist de Desarrollo"

---

## 🏗️ Arquitectura Rápida

```
Frontend (React + TypeScript + Vite)
    ↓
Backend (Node.js + Express + TypeScript)
    ↓
PostgreSQL + Redis + File Storage
    ↓
OpenRouter API (Análisis IA)
```

---

## 🛠️ Stack Tecnológico

- **Frontend:** React 18, TypeScript, Vite, Tailwind CSS, shadcn/ui
- **Backend:** Node.js 20, Express, TypeScript, Prisma
- **Base de Datos:** PostgreSQL 15, Redis 7
- **Infraestructura:** Railway, Docker
- **IA:** OpenRouter API

---

## 📞 Contacto y Soporte

- **Documentación Railway:** https://docs.railway.app/
- **OpenRouter API:** https://openrouter.ai/docs
- **Prisma Docs:** https://www.prisma.io/docs

---

**Versión:** 1.0  
**Fecha:** 14 de Abril 2026  
**Estado:** ✅ Listo para Desarrollo
