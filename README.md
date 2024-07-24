# Next-Strapi-Docker using Docker-compose

This project contains a Strapi and Next.js application using Docker. This guide explains how to set up and run the project with Docker and without Docker.

## Requirements

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Node.js](https://nodejs.org/) (for running without Docker)
- [PostgreSQL](https://www.postgresql.org/) (for running without Docker)

## Project Setup

```
1. Clone the Repository

    ```sh
    git clone https://github.com/your-repo/next-strapi-docker.git
    cd next-strapi-docker
    ```

2. Create Environment File

    Create a `.env` file based on the example:

    ```sh
    cp dev-config/.env.example dev-config/.env
    ```

3. Fill Environment File

    Generate unique keys and fill the `.env` file:

    ```sh
    openssl rand -base64 32 # Run this command for each key
    ```

    Example `.env` file:

    ```env
    APP_KEYS=your_app_keys
    API_TOKEN_SALT=your_api_token_salt
    ADMIN_JWT_SECRET=your_admin_jwt_secret
    TRANSFER_TOKEN_SALT=your_transfer_token_salt
    DATABASE_CLIENT=postgres
    DATABASE_PORT=5432
    DATABASE_NAME=cms
    DATABASE_USERNAME=admin
    DATABASE_PASSWORD=admin
    DATABASE_SSL=false
    NODE_ENV=development
    ```

### Run with Docker

1. Go to the directory with `docker-compose.yml`:

    ```sh
    cd dev-config
    ```

2. Start the containers:

    ```sh
    docker-compose up --build
    ```

### Run Without Docker

1. Make sure you have Node.js and PostgreSQL installed.

2. Create a database and user in PostgreSQL:

    ```sql
    CREATE DATABASE cms;
    CREATE USER admin WITH ENCRYPTED PASSWORD 'admin';
    GRANT ALL PRIVILEGES ON DATABASE cms TO admin;
    ```

3. Install dependencies:

    ```sh
    cd cms
    npm install
    cd ../frontend
    npm install
    ```

4. Run Strapi and Next.js in separate terminals:

    For Strapi:
    ```sh
    cd ../cms
    npm run develop
    ```

    For Next.js:
    ```sh
    cd ../frontend
    npm run dev
    ```

## Access the Applications

- Strapi: [http://localhost:1337](http://localhost:1337)
- Next.js: [http://localhost:3000](http://localhost:3000)

## Notes

- Do not commit the `.env` file to the repository because it contains sensitive data.
- Change the environment variables to your own values if needed.




