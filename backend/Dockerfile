FROM node:20

WORKDIR /app

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

# Push schema to database and start server
CMD ["sh", "-c", "npx prisma db push --accept-data-loss && node dist/app.js"]
