# Documento de Arquitectura Técnica
## PromptVault - Sistema de Repositorio de Prompts

**Versión:** 1.0  
**Fecha:** 14 de Abril 2026  
**Arquitecto:** -  

---

## 1. Visión General de la Arquitectura

### 1.1 Patrón Arquitectónico
**Arquitectura de 3 Capas (3-Tier):**
```
┌─────────────────────────────────────────────────────────────┐
│                    CAPA DE PRESENTACIÓN                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   React App  │  │  PWA Assets  │  │   Offline    │       │
│  │  (TypeScript)│  │  (Manifest)  │  │   Cache      │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    CAPA DE APLICACIÓN                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Express    │  │   BullMQ     │  │   OpenRouter │       │
│  │    API       │  │    Worker    │  │   Integration│       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    CAPA DE DATOS                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │  PostgreSQL  │  │    Redis     │  │  File Store  │       │
│  │   (Data)     │  │   (Queue)    │  │  (Images)    │       │
│  └──────────────┘  └──────────────┘  └──────────────┘       │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Principios de Diseño
1. **Separación de responsabilidades:** Cada capa tiene una función clara
2. **Escalabilidad horizontal:** Servicios stateless, fáciles de replicar
3. **Resiliencia:** Retry, circuit breakers, graceful degradation
4. **Observabilidad:** Logging, métricas, tracing
5. **Railway-native:** Optimizado para deployment en Railway

---

## 2. Stack Tecnológico

### 2.1 Frontend
| Componente | Tecnología | Justificación |
|------------|------------|---------------|
| Framework | React 18 | Popular, ecosistema maduro |
| Lenguaje | TypeScript | Type safety, mejor DX |
| Build Tool | Vite | Rápido, HMR, optimizado |
| UI Library | Tailwind CSS | Utility-first, customizable |
| Componentes | shadcn/ui | Base sólida, accesible |
| Estado | Zustand | Simple, performante |
| Query | TanStack Query | Caching, sincronización |
| Router | React Router v6 | Estándar de la industria |
| Icons | Lucide React | Consistente, ligero |
| PWA | Vite PWA Plugin | Offline-first capability |

### 2.2 Backend
| Componente | Tecnología | Justificación |
|------------|------------|---------------|
| Runtime | Node.js 20 | LTS, performance |
| Framework | Express.js | Minimalista, flexible |
| Lenguaje | TypeScript | Type safety |
| ORM | Prisma | Type-safe queries, migrations |
| Validación | Zod | Schema validation |
| Upload | Multer | File upload handling |
| Images | Sharp | Optimización de imágenes |

### 2.3 Base de Datos y Storage
| Componente | Tecnología | Justificación |
|------------|------------|---------------|
| Database | PostgreSQL 15 | Relacional, full-text search |
| Cache/Queue | Redis 7 | BullMQ, sesiones, cache |
| Storage | Railway Volumes / AWS S3 | Archivos persistentes |

### 2.4 Infraestructura
| Componente | Tecnología | Justificación |
|------------|------------|---------------|
| Hosting | Railway | Simple, escalable, buen precio |
| Container | Docker | Portabilidad |
| CI/CD | GitHub Actions | Automatización |

---

## 3. Estructura del Proyecto

### 3.1 Monorepo Structure
```
promptvault/
├── README.md
├── package.json
├── turbo.json                    # Monorepo orchestration
├── docker-compose.yml            # Local development
│
├── apps/
│   ├── web/                      # Frontend React
│   │   ├── src/
│   │   │   ├── components/       # UI Components
│   │   │   ├── hooks/            # Custom hooks
│   │   │   ├── stores/           # Zustand stores
│   │   │   ├── services/         # API clients
│   │   │   ├── types/            # TypeScript types
│   │   │   ├── utils/            # Utilities
│   │   │   ├── pages/            # Route pages
│   │   │   └── App.tsx
│   │   ├── public/
│   │   ├── index.html
│   │   ├── vite.config.ts
│   │   └── package.json
│   │
│   └── api/                      # Backend Express
│       ├── src/
│       │   ├── config/           # Configuration
│       │   ├── controllers/      # Route handlers
│       │   ├── services/         # Business logic
│       │   ├── models/           # Prisma models
│       │   ├── middleware/       # Express middleware
│       │   ├── routes/           # API routes
│       │   ├── workers/          # BullMQ workers
│       │   ├── utils/            # Utilities
│       │   ├── types/            # TypeScript types
│       │   └── app.ts
│       ├── prisma/
│       │   └── schema.prisma
│       ├── uploads/              # Image storage (dev)
│       ├── Dockerfile
│       └── package.json
│
└── packages/
    ├── shared/                   # Shared types & utils
    └── ts-config/                # Shared TS config
```

---

## 4. Diagramas de Componentes

### 4.1 Diagrama de Componentes Frontend
```
┌────────────────────────────────────────────────────────────────┐
│                        FRONTEND (React)                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      PAGES                                │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │  HomePage   │  │  SearchPage │  │  FavoritesPage  │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                   COMPONENTS                              │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │ PromptCard  │  │ PromptModal │  │  CreateModal    │  │  │
│  │  │   (Grid)    │  │  (Detail)   │  │   (Create)      │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │ FilterBar   │  │  SearchBox  │  │   TagCloud      │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     SERVICES                              │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │  apiClient  │  │ imageService│  │  promptService  │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      STORES                               │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │ promptStore │  │  uiStore    │  │  filterStore    │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

### 4.2 Diagrama de Componentes Backend
```
┌────────────────────────────────────────────────────────────────┐
│                        BACKEND (Express)                        │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      ROUTES                               │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │  prompts.ts │  │   tags.ts   │  │  analysis.ts    │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                   CONTROLLERS                             │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │promptController│ │tagController│  │analysisController│  │ │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    SERVICES                               │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │promptService│  │ imageService│  │ analysisService │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │  tagService │  │searchService│  │ openRouterService│  │ │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     WORKERS                               │  │
│  │  ┌─────────────────────────────────────────────────────┐ │  │
│  │  │              AnalysisWorker (BullMQ)                 │ │  │
│  │  └─────────────────────────────────────────────────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                      DATA                                 │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐  │  │
│  │  │   Prisma    │  │   BullMQ    │  │   FileSystem    │  │  │
│  │  │  (PostgreSQL)│  │   (Redis)   │  │   (Storage)     │  │  │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────────┘
```

---

## 5. Flujo de Datos

### 5.1 Crear Prompt con Análisis IA
```
Usuario
   │
   ▼
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Frontend   │────▶│  POST /api/  │────▶│   Express    │
│  (React)     │     │   prompts    │     │    API       │
└──────────────┘     └──────────────┘     └──────┬───────┘
   │                                              │
   │ Toast: "Procesando..."                       │ 1. Guardar prompt
   │                                              │    status="processing"
   │                                              │ 2. Encolar job en Redis
   │                                              │
   │                                     ┌────────▼───────┐
   │                                     │  BullMQ Queue  │
   │                                     │   (Redis)      │
   │                                     └────────┬───────┘
   │                                              │
   │                                     ┌────────▼───────┐
   │                                     │ AnalysisWorker │
   │                                     │  (Background)  │
   │                                     └────────┬───────┘
   │                                              │
   │                                              ▼
   │                                     ┌────────────────┐
   │                                     │  OpenRouter    │
   │                                     │    API         │
   │                                     └────────────────┘
   │                                              │
   │                                              │ Parse response
   │                                              ▼
   │                                     ┌────────────────┐
   │                                     │  Update prompt │
   │                                     │ status="completed"
   │                                     └────────┬───────┘
   │                                              │
   │◀─────────────────────────────────────────────┤
   │                                              │
   ▼                                              │
Toast: "¡Prompt guardado!"                       │
   │                                              │
   ▼                                              │
Grid se actualiza                                │
```

### 5.2 Búsqueda con Filtros
```
Usuario
   │
   ▼
┌──────────────┐     ┌──────────────────────────────┐
│   Frontend   │────▶│ GET /api/prompts/search      │
│  (React)     │     │ ?q=anime&category=imagen     │
└──────────────┘     └──────────────┬───────────────┘
                                    │
                                    ▼
                           ┌────────────────┐
                           │searchService   │
                           │                │
                           │ 1. Parse query │
                           │ 2. Build SQL   │
                           │ 3. Execute     │
                           └────────┬───────┘
                                    │
                                    ▼
                           ┌────────────────┐
                           │  PostgreSQL    │
                           │ Full-text +    │
                           │ Filters        │
                           └────────┬───────┘
                                    │
                                    ▼
                           ┌────────────────┐
                           │   Results      │
                           │   (JSON)       │
                           └────────┬───────┘
                                    │
◀───────────────────────────────────┘
│
▼
Grid actualizado
```

---

## 6. Configuración de Railway

### 6.1 Servicios Necesarios
```yaml
# railway.yaml
services:
  web:
    build: apps/web
    start: npm run preview
    port: 4173
    
  api:
    build: apps/api
    start: npm run start
    port: 3000
    
  postgres:
    image: postgres:15
    env:
      POSTGRES_DB: promptvault
      
  redis:
    image: redis:7-alpine
    
  storage:
    type: volume
    mount: /app/uploads
```

### 6.2 Variables de Entorno
```bash
# Database
DATABASE_URL="postgresql://user:pass@localhost:5432/promptvault"

# Redis
REDIS_URL="redis://localhost:6379"

# OpenRouter
OPENROUTER_API_KEY="sk-or-v1-..."
OPENROUTER_MODEL="openrouter/auto"  # Free tier random model

# Storage
UPLOAD_DIR="./uploads"
MAX_FILE_SIZE="10485760"  # 10MB

# App
NODE_ENV="production"
PORT="3000"
API_URL="https://api.yourapp.railway.app"
WEB_URL="https://yourapp.railway.app"
```

### 6.3 Dockerfile (API)
```dockerfile
# apps/api/Dockerfile
FROM node:20-alpine

WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci --only=production

# Copy app
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Expose port
EXPOSE 3000

# Start
CMD ["npm", "run", "start"]
```

---

## 7. Estrategia de Caché

### 7.1 Niveles de Caché
```
┌─────────────────────────────────────────────────────────────┐
│  NIVEL 1: Browser Cache (Service Worker)                    │
│  - App shell (HTML, CSS, JS)                                │
│  - Static assets (icons, fonts)                             │
│  - TTL: 1 día                                               │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  NIVEL 2: TanStack Query Cache                              │
│  - API responses                                            │
│  - Prompts list, tags                                       │
│  - TTL: 5 min / Stale-while-revalidate                      │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│  NIVEL 3: Redis Cache (Server)                              │
│  - Search results                                           │
│  - Popular tags                                             │
│  - TTL: 10 min                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. Seguridad

### 8.1 Medidas Implementadas
| Amenaza | Mitigación |
|---------|------------|
| XSS | Sanitización de inputs, CSP headers |
| CSRF | SameSite cookies, tokens |
| Injection | Prisma ORM (parameterized queries) |
| File Upload | Validación de tipo, tamaño, escaneo |
| Rate Limiting | express-rate-limit (100 req/min) |
| CORS | Whitelist de orígenes permitidos |

### 8.2 Headers de Seguridad
```javascript
app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'", "'unsafe-inline'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "blob:"],
    },
  },
}));
```

---

## 9. Monitoreo y Logging

### 9.1 Estrategia de Logging
```
┌─────────────────────────────────────────────────────────────┐
│  Estructura de Logs (JSON)                                  │
│  {                                                          │
│    "timestamp": "2026-04-14T10:00:00Z",                     │
│    "level": "info|warn|error",                              │
│    "service": "api|worker",                                 │
│    "requestId": "uuid",                                     │
│    "message": "...",                                        │
│    "metadata": {...}                                        │
│  }                                                          │
└─────────────────────────────────────────────────────────────┘
```

### 9.2 Métricas Clave
- Request latency (p50, p95, p99)
- Error rate
- Queue depth (BullMQ)
- Database query time
- OpenRouter API latency

---

## 10. Escalabilidad

### 10.1 Escalado Horizontal
```
                    ┌─────────────┐
                    │   Railway   │
                    │   Load      │
                    │   Balancer  │
                    └──────┬──────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
    │  API Pod 1  │ │  API Pod 2  │ │  API Pod N  │
    │  (Express)  │ │  (Express)  │ │  (Express)  │
    └─────────────┘ └─────────────┘ └─────────────┘
           │               │               │
           └───────────────┼───────────────┘
                           │
                    ┌──────┴──────┐
                    │  PostgreSQL │
                    │   (Primary) │
                    └─────────────┘
```

### 10.2 Optimizaciones de Base de Datos
- Índices en campos de búsqueda frecuente
- Particionamiento por fecha (si > 1M registros)
- Connection pooling (PgBouncer)
- Read replicas (si es necesario)

---

## 11. Plan de Migración

### 11.1 Fases de Implementación
```
Fase 1: MVP (Semanas 1-2)
├── Setup proyecto
├── Database schema
├── API básica (CRUD)
├── Frontend base
└── Integración OpenRouter

Fase 2: Mejoras (Semanas 3-4)
├── Sistema de tags inteligente
├── Búsqueda avanzada
├── Optimización de imágenes
└── PWA features

Fase 3: Pulido (Semanas 5-6)
├── Testing
├── Performance tuning
├── Monitoreo
└── Documentación
```

---

## 12. Referencias

- [Railway Docs](https://docs.railway.app/)
- [OpenRouter API](https://openrouter.ai/docs)
- [Prisma Docs](https://www.prisma.io/docs)
- [BullMQ Docs](https://docs.bullmq.io/)
- [React Query](https://tanstack.com/query/latest)

---

**Notas:**
- Esta arquitectura está optimizada para Railway pero puede adaptarse
- Los servicios son stateless para facilitar el escalado
- El uso de colas (BullMQ) permite manejar picos de carga
