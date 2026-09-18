# Minions with Docker Hub

The project consists of three containers:

- `api` is an ASP.NET Core application.
- `web` is the web application, which runs with Bun.
- `nginx` acts as a reverse proxy in front of the other two containers.

The API and web images are built locally and pushed to Docker Hub. When the
project is started, the two images are pulled from Docker Hub, while the Nginx
image is built from the project's `Dockerfile`.

## 1. Create repositories on Docker Hub

Create the following two repositories in your Docker Hub account:

- `minions-api`
- `minions-web`

They must be public unless the environment pulling them is logged in to Docker
Hub.

## 2. Log in to Docker Hub

```bash
docker login
```

## 3. Build and push the images

Replace `<dockerhub-account>` with your Docker Hub username:

```bash
docker buildx build \
  --platform linux/amd64 \
  --tag <dockerhub-account>/minions-api:latest \
  --push ./api

docker buildx build \
  --platform linux/amd64 \
  --tag <dockerhub-account>/minions-web:latest \
  --push ./react
```

`--push` uploads the image directly to Docker Hub when the build is complete.
The `linux/amd64` platform matches the VM on which the project runs by default
on Fly.io.

## 4. Update the image names in the Compose file

Replace `<dockerhub-account>` in `compose.yaml` so that the two services point
to your own images:

```yaml
api:
  image: <your-username>/minions-api:latest

web:
  image: <your-username>/minions-web:latest
```

## 5. Deploy to Fly.io

Log in and deploy the project from the project directory:

```bash
fly auth login
fly deploy
```

Fly.io builds the Nginx image and pulls the API and web images from Docker Hub
as specified in `compose.yaml`.

When the API or web application changes, the relevant images must be built and
pushed again. Then run `fly deploy` to create a new deployment.
