FROM node:20

WORKDIR /app

# Force Prisma to download linux-glibc binaries instead of linux-musl
ENV PRISMA_CLIENT_ENGINE_TYPE="library"
ENV PRISMA_CLI_BINARY_TARGETS="linux-arm64-openssl-3.0.x,linux-arm64-openssl-1.1.x,linux-glibc"

# Install all dependencies
COPY package*.json ./
RUN npm ci

# Copy prisma schema
COPY prisma ./prisma/

# Copy app
COPY . .

# Build TypeScript
RUN npx prisma generate
RUN npm run build

# Create uploads directory
RUN mkdir -p uploads

# Expose port
EXPOSE 3001

# Start
CMD ["npm", "run", "start"]
