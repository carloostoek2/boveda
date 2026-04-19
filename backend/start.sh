#!/bin/sh
echo "Running database setup..."
npx prisma db push --accept-data-loss
echo "Starting server..."
node dist/app.js
