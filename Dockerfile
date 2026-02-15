# --- Build Stage ---
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN corepack enable && corepack prepare pnpm@9.14.4 --activate
RUN pnpm install
COPY . .
RUN pnpm build

# --- Production Stage ---
FROM node:20-alpine AS production
WORKDIR /app

RUN corepack enable && corepack prepare pnpm@9.14.4 --activate

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

EXPOSE 4321
CMD ["pnpm", "preview", "--host", "0.0.0.0"]