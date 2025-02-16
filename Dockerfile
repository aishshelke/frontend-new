# Stage 1: Build the frontend with Node.js
FROM node:18-alpine AS build
WORKDIR /app

# Copy only the package files first to improve caching
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the project
COPY . .

# Build the frontend (adjust if needed)
RUN npm run build

# Stage 2: Serve the frontend using Nginx
FROM nginx:alpine
WORKDIR /usr/share/nginx/html

# Copy build output from the previous stage (Vite's default output is 'dist/')
COPY --from=build /app/dist/ . 

# Expose port 80 and start Nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]