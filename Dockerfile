# Stage 1: Build the site
FROM python:3.11-slim AS builder

WORKDIR /app
RUN pip install zensical
COPY . .
RUN zensical build

# Stage 2: Serve with Nginx as non-root
FROM nginxinc/nginx-unprivileged:stable-alpine

# Copy the built site from the builder stage
COPY --from=builder /app/site/ /usr/share/nginx/html/

# Expose the port (must be > 1024 for non-root)
EXPOSE 8080

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
