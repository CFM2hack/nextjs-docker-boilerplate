# Next.js Docker Golden Path 🚀

This is a boilerplate and a set of best practices for developing Next.js applications inside Docker, specifically tailored for macOS users. It is designed to be the definitive "Golden Path" that solves common, frustrating, and time-consuming issues related to cross-platform compatibility and container orchestration.

---

## The "Why": Core Problems This Boilerplate Solves

This configuration was born from a difficult debugging process and is engineered to permanently solve the following problems:

*   ✅ **Binary Incompatibility (The Mac vs. Linux Problem):** Prevents errors like `Cannot find module '../lightningcss.linux-x64-musl.node'`. It achieves this by creating a dedicated Docker volume for `node_modules`, ensuring dependencies are installed and compiled for the container's Linux environment, not your local macOS.

*   ✅ **File Mount Race Conditions:** Prevents errors like `No package.json was found in "/app"`. The custom `entrypoint.sh` script acts as a smart startup manager, forcing the container to wait until your local files are fully mounted before it attempts to install dependencies or start the server.

*   ✅ **Environment Consistency:** Ensures that the development environment is 100% consistent and reproducible, regardless of your local machine's configuration. What works on your machine will work for any collaborator, and it will work in production.

*   ✅ **Simplified Workflow:** Provides a simple, repeatable set of commands to start, stop, and interact with your application.

---

## 🛠️ Tech Stack

*   **Framework:** Next.js (with App Router)
*   **Containerization:** Docker & Docker Compose
*   **Database:** PostgreSQL
*   **Package Manager:** PNPM
*   **Styling:** Tailwind CSS

---

## 🚀 Quickstart: How to Use for a New Project

Follow these steps to go from zero to a running application in minutes.

### Step 1. Clone This Boilerplate
Clone this repository into a new directory with your project's name. **Remember to use all lowercase letters and hyphens.**

```bash
git clone [URL_TO_YOUR_BOILERPLATE_REPO] my-new-project-name
cd my-new-project-name
```

### Step 2: Customize `docker-compose.yml`
This is an optional but highly recommended step for keeping your projects organized. Open `docker-compose.yml` and change the default `container_name` fields to match your new project name.

*From:*
```yaml
container_name: my-app-name
container_name: my-app-db
```
*To:*

```yaml
container_name: my-new-project-name_app
container_name: my-new-project-name_db
```

### Step 3: Create the Next.js Project
Run the `create-next-app` installer in the current directory (`.`). This will populate the folder with the Next.js starter code.

```bash
npx create-next-app@latest . --typescript --eslint
```
(Answer "Yes" to Tailwind CSS and Turbopack when prompted.)

### Step 4: Convert to PNPM
The installer uses `npm` by default. We need to convert the project to use `pnpm` to match our Docker setup.

```bash
# Remove npm artifacts
rm -rf node_modules package-lock.json
# Install dependencies with pnpm
pnpm install
```

### Step 5: Make Entrypoint Executable
You only need to do this once per project clone. This gives the startup script permission to run.

```bash
chmod +x entrypoint.sh
```

### Step 6: Build and Run!
Bring your entire development environment online with a single command.

```bash
docker-compose up --build
```
The first build will take a minute to install dependencies inside the container's volume. Subsequent builds will be much faster. Your application will be running at http://localhost:3000.

## 💡 Daily Development Workflow

### Starting the Server
From the project root, simply run:
```bash
docker-compose up
```

### Stopping the Server
Press `Ctrl + C` in the terminal where the server is running. To ensure containers are fully stopped and removed, you can also run:
```bash
docker-compose down
```

### Running One-Off Commands
To run commands like database migrations, you need to execute them inside the running app container. Use the `docker-compose run --rm app` command.

Example: Running Prisma Migrate
```bash
docker-compose run --rm app pnpm prisma migrate dev
```

Example: Installing a new package (e.g., clsx)
```bash
# 1. Install the package inside the container
docker-compose run --rm app pnpm add clsx
# 2. Restart the server to use the new package
docker-compose up --build
```

### 🔧 Troubleshooting
`pnpm` or other weird errors: If things get strange, the most reliable fix is the `Hard Reset.`

```bash
# Stop all containers
docker-compose down

# Optional: Prune old volumes if you suspect data corruption
docker volume prune

# Rebuild everything from scratch
docker-compose up --build
```
If `Permission denied: ./entrypoint.sh`: You forgot to make the script executable. Run the command
```bash
chmod +x entrypoint.sh.
```

