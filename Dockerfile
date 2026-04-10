# Dockerfile

# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app

# Copy package.json and pnpm-lock.yaml files for dependencies installation
COPY package.json pnpm-lock.yaml ./

# Install pnpm
RUN npm install -g pnpm

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy the entire monorepo
COPY . .

# Build the application
RUN pnpm build


# Stage 2: Production
FROM node:18 AS production
WORKDIR /app

# Copy only the necessary files from build stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./

# Install only production dependencies
RUN npm install --production --frozen-lockfile

# Start the application
CMD [ "node", "./dist/index.js" ]
