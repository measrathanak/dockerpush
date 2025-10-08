# Use the Node.js builder image
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /usr/src/app
# Alpine uses 'apk add' instead of 'apt-get install'.
RUN apk update && \
    apk add --no-cache \
    curl \
    nano \
    bash

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install --production


# Copy the rest of the application code
COPY . .

# Build the app (if necessary, e.g., for React, Angular)
# RUN npm run build

# Use a distroless base image for the final stage
FROM gcr.io/distroless/nodejs18

# Set the working directory
WORKDIR /usr/src/app

# Copy the built application from the build stage
COPY --from=build /usr/src/app .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the app
CMD ["app.js"]