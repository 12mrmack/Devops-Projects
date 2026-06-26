# Use Alpine Image
FROM alpine:latest

# Maintainer Information
LABEL maintainer="Maqbool Alam"

# Update packages and install Node.js
RUN apk update && apk add --no-cache nodejs

# Copy current directory to /app
COPY . /app

# Set working directory
WORKDIR /app

# Default command
CMD ["node", "index.js"]
