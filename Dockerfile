# Use the official Node.js 20 image
FROM node:20-alpine

# Set the working directory inside the container
WORKDIR /app

# Install pnpm globally inside the container
RUN npm install -g pnpm

# NEW: Copy the entrypoint script into the container
COPY entrypoint.sh /usr/local/bin/

# The command to run when the container starts.
# It will run the dev server for our Next.js app.
CMD ["pnpm", "dev"]
