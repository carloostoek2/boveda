# Prompt de Sistema para OpenRouter
## PromptVault - Extracción de Metadata

**Versión:** 1.0  
**Fecha:** 14 de Abril 2026  
**Modelo:** openrouter/auto (free tier)  

---

## 1. Prompt de Sistema Principal

```json
{
  "system": "Eres un analizador experto de prompts para IA generativa. Tu tarea es analizar prompts y extraer metadata estructurada en formato JSON.\n\nREGLAS IMPORTANTES:\n1. Responde ÚNICAMENTE con JSON válido, sin markdown, sin explicaciones\n2. El JSON debe estar completo y bien formateado\n3. Usa valores null si no puedes determinar algo\n4. Los tags deben ser relevantes y específicos\n5. La confianza debe reflejar tu certeza (0.0 - 1.0)\n\nCATEGORÍAS VÁLIDAS:\n- IMAGEN: prompts para generación de imágenes (DALL-E, Midjourney, Stable Diffusion, etc.)\n- VIDEO: prompts para generación de video (Runway, Pika, etc.)\n- TEXTO: prompts para LLMs (ChatGPT, Claude, etc.)\n- AUDIO: prompts para generación de audio/música/voz\n\nESTRUCTURA DE RESPUESTA:\n{\n  \"title\": \"string - título conciso y descriptivo (max 100 chars)\",\n  \"description\": \"string - descripción breve de qué hace el prompt (max 300 chars)\",\n  \"category\": \"IMAGEN|VIDEO|TEXTO|AUDIO\",\n  \"subcategory\": \"string - subcategoría específica según la categoría\",\n  \"tags\": [\"array\", \"de\", \"tags\", \"relevantes\", \"en\", \"inglés\"],\n  \"metadata\": {\n    // campos específicos según categoría (ver abajo)\n  },\n  \"confidence\": 0.0-1.0\n}"
}
```

---

## 2. Prompt de Usuario (Template)

```javascript
const userPrompt = `
Analiza el siguiente prompt y extrae la metadata estructurada:

---
${promptContent}
---

Instrucciones adicionales:
1. Determina la categoría principal basándote en el contenido y contexto
2. Extrae un título que describa claramente el propósito del prompt
3. Escribe una descripción breve de lo que el prompt genera/hace
4. Genera entre 3-8 tags relevantes (en inglés, lowercase, separados por guiones)
5. Extrae metadata específica según la categoría detectada
6. Asigna una puntuación de confianza (0.0 - 1.0)

Responde ÚNICAMENTE con el JSON, sin texto adicional.
`;
```

---

## 3. Estructura de Metadata por Categoría

### 3.1 Categoría: IMAGEN

```json
{
  "metadata": {
    "style": "fotorealista|anime|ilustración|3d|pintura|pixel-art|concept-art|sketch|watercolor|oil-painting|digital-art|vector",
    "pose": "retrato|panorámica|primer-plano|medio-cuerpo|cuerpo-completo|extreme-close-up|wide-shot|aerial-view",
    "camera": "35mm|50mm|85mm|24mm|135mm|gran-angular|telefoto|macro|fisheye|tilt-shift",
    "lighting": "natural|estudio|contraluz|hora-dorada|blue-hour|nocturna|dramática|suave|neon|candlelight",
    "aspect_ratio": "1:1|16:9|9:16|4:3|3:2|21:9|2:3",
    "color_palette": "vibrante|monocromático|sepia|pastel|neon|bw|desaturated|warm|cool",
    "mood": "alegre|melancólico|dramático|pacífico|misterioso|épico|íntimo|tenso|sereno",
    "quality": "8k|4k|hd|masterpiece|highly-detailed|photorealistic"
  }
}
```

### 3.2 Categoría: VIDEO

```json
{
  "metadata": {
    "duration": "corto|medio|largo",
    "duration_seconds": 30,
    "movement": "estático|pan|zoom|tracking|dolly|handheld|gimbal|drone",
    "transitions": "suave|abrupta|fade|wipe|cut|dissolve|morph",
    "pace": "lento|moderado|rápido|time-lapse|slow-motion",
    "style": "cinematográfico|documental|experimental|animado|vlog|commercial",
    "camera_work": "steady-cam|handheld|drone|crane|dolly"
  }
}
```

### 3.3 Categoría: TEXTO

```json
{
  "metadata": {
    "type": "copywriting|código|análisis|creativo|resumen|traducción|revisión|brainstorming|qa|tutorial",
    "tone": "profesional|casual|humorístico|académico|persuasivo|empático|autoritario|amigable|formal",
    "length": "corto|medio|largo",
    "target_audience": "general|técnico|ejecutivo|niños|expertos|principiantes",
    "language": "es|en|fr|de|pt|it|zh|ja|ko",
    "format": "lista|párrafo|tabla|código|json|markdown|email|social-media"
  }
}
```

### 3.4 Categoría: AUDIO

```json
{
  "metadata": {
    "type": "voz|música|efectos|podcast|audiobook",
    "style": "narrativo|conversacional|musical|ambiental|dramático|documental",
    "genre": "rock|electrónica|clásica|jazz|pop|hip-hop|folk|ambient|lo-fi|cinematic",
    "mood": "energético|relajado|triste|alegre|dramático|épico| íntimo|suspense",
    "tempo": "lento|moderado|rápido|variable",
    "voice_gender": "masculino|femenino|neutral",
    "voice_age": "joven|adulto|mayor|child",
    "instruments": ["piano", "guitarra", "batería", "strings", "synth"]
  }
}
```

---

## 4. Ejemplos de Prompts y Respuestas Esperadas

### Ejemplo 1: Prompt de Imagen

**Input:**
```
A stunning portrait of a cyberpunk woman with neon blue hair, wearing futuristic glasses, 
standing in a rain-soaked street at night. The scene is illuminated by vibrant pink and 
blue neon signs. Photorealistic, 8k resolution, cinematic lighting, shot on 85mm lens, 
bokeh background, highly detailed skin texture.
```

**Output Esperado:**
```json
{
  "title": "Cyberpunk Portrait with Neon Lighting",
  "description": "Retrato futurista de mujer cyberpunk con iluminación de neón en calle lluviosa nocturna",
  "category": "IMAGEN",
  "subcategory": "retrato-futurista",
  "tags": ["cyberpunk", "neon", "portrait", "futuristic", "night", "rain", "photorealistic", "8k"],
  "metadata": {
    "style": "fotorealista",
    "pose": "retrato",
    "camera": "85mm",
    "lighting": "neon",
    "aspect_ratio": "3:2",
    "color_palette": "neon",
    "mood": "misterioso",
    "quality": "8k"
  },
  "confidence": 0.95
}
```

---

### Ejemplo 2: Prompt de Texto

**Input:**
```
Eres un experto en marketing digital. Escribe 5 ideas creativas para una campaña de 
redes sociales para una marca de café artesanal. El tono debe ser joven, auténtico 
y cercano. Incluye hashtags relevantes y sugerencias de imágenes para cada idea.
```

**Output Esperado:**
```json
{
  "title": "Ideas de Campaña para Café Artesanal",
  "description": "Prompt para generar ideas creativas de marketing para marca de café en redes sociales",
  "category": "TEXTO",
  "subcategory": "copywriting-marketing",
  "tags": ["marketing", "social-media", "copywriting", "coffee-brand", "campaign-ideas"],
  "metadata": {
    "type": "copywriting",
    "tone": "casual",
    "length": "medio",
    "target_audience": "general",
    "language": "es",
    "format": "lista"
  },
  "confidence": 0.92
}
```

---

### Ejemplo 3: Prompt de Video

**Input:**
```
Create a cinematic drone shot flying over a misty mountain landscape at sunrise. 
The camera slowly descends through the clouds revealing a hidden valley with a 
serene lake. 4K quality, smooth movement, peaceful atmosphere, nature documentary style.
```

**Output Esperado:**
```json
{
  "title": "Cinematic Mountain Drone Shot",
  "description": "Toma aérea cinematográfica de montañas brumosas al amanecer revelando valle con lago",
  "category": "VIDEO",
  "subcategory": "nature-documentary",
  "tags": ["drone", "mountain", "sunrise", "cinematic", "nature", "aerial", "4k"],
  "metadata": {
    "duration": "medio",
    "movement": "drone",
    "transitions": "suave",
    "pace": "lento",
    "style": "documental",
    "camera_work": "drone"
  },
  "confidence": 0.88
}
```

---

### Ejemplo 4: Prompt de Audio

**Input:**
```
Generate a lo-fi hip hop beat for studying. Include soft piano melodies, 
gentle rain sounds in the background, and a relaxed, chill atmosphere. 
Duration: 3 minutes, no vocals, perfect for focus and relaxation.
```

**Output Esperado:**
```json
{
  "title": "Lo-Fi Study Beat with Rain",
  "description": "Beat lo-fi hip hop para estudiar con piano suave y sonidos de lluvia",
  "category": "AUDIO",
  "subcategory": "lo-fi-beats",
  "tags": ["lo-fi", "hip-hop", "study", "chill", "rain", "focus", "instrumental"],
  "metadata": {
    "type": "música",
    "style": "musical",
    "genre": "lo-fi",
    "mood": "relajado",
    "tempo": "lento",
    "instruments": ["piano", "beats"]
  },
  "confidence": 0.94
}
```

---

## 5. Manejo de Casos Edge

### 5.1 Prompt Ambiguo

**Input:**
```
Create something beautiful and inspiring.
```

**Output Esperado:**
```json
{
  "title": "Beautiful and Inspiring Creation",
  "description": "Prompt genérico para crear algo hermoso e inspirador",
  "category": "IMAGEN",
  "subcategory": "general",
  "tags": ["beautiful", "inspiring", "creative"],
  "metadata": {
    "style": null,
    "mood": "alegre"
  },
  "confidence": 0.45
}
```

### 5.2 Prompt Técnico/Código

**Input:**
```
Write a Python function that takes a list of integers and returns the sum of all 
even numbers. Include error handling for non-integer inputs and document the function 
with docstrings following PEP 257.
```

**Output Esperado:**
```json
{
  "title": "Python Function for Even Numbers Sum",
  "description": "Función Python para sumar números pares con manejo de errores y docstrings",
  "category": "TEXTO",
  "subcategory": "coding-python",
  "tags": ["python", "function", "even-numbers", "error-handling", "docstrings"],
  "metadata": {
    "type": "código",
    "tone": "profesional",
    "language": "en",
    "format": "código"
  },
  "confidence": 0.96
}
```

---

## 6. Implementación en Node.js

```typescript
// services/openRouter.service.ts
import axios from 'axios';

interface AnalysisResult {
  title: string;
  description: string;
  category: 'IMAGEN' | 'VIDEO' | 'TEXTO' | 'AUDIO';
  subcategory: string;
  tags: string[];
  metadata: Record<string, any>;
  confidence: number;
}

const SYSTEM_PROMPT = `Eres un analizador experto de prompts...`; // Del apartado 1

export async function analyzePrompt(promptContent: string): Promise<AnalysisResult> {
  const response = await axios.post(
    'https://openrouter.ai/api/v1/chat/completions',
    {
      model: 'openrouter/auto', // Free tier
      messages: [
        { role: 'system', content: SYSTEM_PROMPT },
        { role: 'user', content: `Analiza el siguiente prompt:\n\n${promptContent}` }
      ],
      temperature: 0.3, // Bajo para consistencia
      max_tokens: 1000
    },
    {
      headers: {
        'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': process.env.WEB_URL,
        'X-Title': 'PromptVault'
      },
      timeout: 30000 // 30 segundos
    }
  );

  const content = response.data.choices[0].message.content;
  
  // Parsear JSON de la respuesta
  try {
    const result: AnalysisResult = JSON.parse(content);
    return result;
  } catch (error) {
    throw new Error('Invalid JSON response from OpenRouter');
  }
}
```

---

## 7. Manejo de Errores

```typescript
// Retry logic con backoff exponencial
export async function analyzePromptWithRetry(
  promptContent: string, 
  maxRetries = 3
): Promise<AnalysisResult> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      return await analyzePrompt(promptContent);
    } catch (error) {
      if (attempt === maxRetries) throw error;
      
      // Backoff exponencial: 1s, 2s, 4s
      const delay = Math.pow(2, attempt - 1) * 1000;
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
  throw new Error('Max retries exceeded');
}
```

---

## 8. Rate Limiting Consideraciones

OpenRouter Free Tier:
- Límite: 20 requests/minuto
- Estrategia: Implementar cola con rate limiting

```typescript
// Rate limiter simple
import { RateLimiter } from 'limiter';

const limiter = new RateLimiter({
  tokensPerInterval: 20,
  interval: 'minute'
});

export async function analyzePromptRateLimited(promptContent: string) {
  await limiter.removeTokens(1);
  return analyzePrompt(promptContent);
}
```

---

**Notas:**
- El prompt de sistema debe ajustarse según los resultados reales
- Monitorear la calidad de las extracciones
- Considerar fine-tuning si se usa modelo propio en el futuro
