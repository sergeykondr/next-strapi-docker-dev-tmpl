# Next.js - Strapi - Postgres using Docker-compose

This project contains a Strapi, PostgreSQL and Next.js application using Docker. This guide explains how to set up and run the project with Docker and without Docker.

## Requirements

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Node.js](https://nodejs.org/) (for running without Docker)
- [PostgreSQL](https://www.postgresql.org/) (for running without Docker)

## Project Setup

\```
1. Clone the Repository

    ```sh
    git clone https://github.com/sergeykondr/next-strapi-docker-dev-tmpl.git
    cd next-strapi-docker-dev-tmpl
    ```

2. Create Environment File

    Create a `.env` file based on the example:

    ```sh
    cp dev-config/.env.example dev-config/.env
    ```

3. Fill Environment File

    option A. Generate unique keys and fill the `.env` file (exclude Windows):

    ```sh
    openssl rand -base64 32 # Run this command for each key
    ```

    option B. Generate unique keys and fill the `.env` file (for Windows PowerShell). Run this command for each key:

    ```sh
      [Convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 }))
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

3. For subsequent starts:
   ```sh
    docker-compose down
    ```
    
   ```sh
    docker-compose up -d
    ```

### Manual Export Postgres dump
1.
   ```sh
   docker ps
   docker exec -t <your_db_container_id> pg_dump -U admin -d cms -F c -b -v -f /var/lib/postgresql/data/postgres.dump
   docker cp <your_db_container_id>:/var/lib/postgresql/data/postgres.dump /Users/<YOUR_USER>/documents/postgres.dump
   ```

### Manual Import Postgres dump to db
#### Go to db container and using psql
   ```sh
   docker ps
   docker exec -it <db_container_name> bash
   psql -U admin -d cms
   ```
#### Drop tables
   ```sh
            DO $$ DECLARE
           r RECORD;
         BEGIN
           FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = current_schema()) LOOP
             EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(r.tablename) || ' CASCADE';
           END LOOP;
         END $$;
         \q
   ```
#### After exiting from psql
```sh
pg_restore -U admin -d cms /dump_importing/postgres.dump
docker exec -t <your_db_container_id> pg_dump -U admin -d cms -F c -b -v -f /var/lib/postgresql/data/postgres.dump
```

### Manual copy /uploads (images) to strapi cms
   copy images from your colleague to /next-strapi-docker/cms/public/uploads

____

### DON'T WORK (Automate DB import via db/init_db.sh) 
1. Place your database dump file in the `db/dump_importing` directory.
2. On container startup, `db/init_db.sh` will automatically import the first file found.
3. The existing database will be fully overwritten.
4. After import, the file will be moved to `db/dump_importing/imported` to prevent re-importing.



===========================
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




