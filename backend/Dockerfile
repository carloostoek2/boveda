FROM node:20-alpine

WORKDIR /app

# Install OpenSSL for Prisma
RUN apk add --no-cache openssl libssl3

# Install all dependencies (including devDependencies for build)
COPY package*.json ./
RUN npm ci

# Copy prisma schema
COPY prisma ./prisma/

# Generate Prisma client
RUN npx prisma generate

# Copy app
COPY . .

# Build TypeScript
RUN npm run build

# Create uploads directory
RUN mkdir -p uploads

# Expose port
EXPOSE 3001

# Start
CMD ["npm", "run", "start"]
