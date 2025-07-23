#!/bin/sh

# Wait until the package.json from the volume mount is available
while [ ! -f "package.json" ]; do
  echo "Waiting for files to be mounted..."
  sleep 1
done

# Now, install dependencies INSIDE the container's own volume.
# This will install the correct binaries for Alpine Linux.
# On subsequent startups, this will be very fast as pnpm will see
# that everything is already installed.
echo "Dependencies installing inside the container..."
pnpm install

# Now that dependencies are correct, execute the main command (pnpm dev)
exec "$@"
