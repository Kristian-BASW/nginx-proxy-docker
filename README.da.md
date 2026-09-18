# Minions med Docker Hub

Projektet består af tre containere:

- `api` er en ASP.NET Core-applikation.
- `web` er webapplikationen, som kører med Bun.
- `nginx` fungerer som reverse proxy foran de to andre containere.

API- og web-images bygges lokalt og pushes til Docker Hub. Når projektet
startes, hentes de to images fra Docker Hub, mens Nginx-imaget bygges fra
projektets `Dockerfile`.

## 1. Opret repositories på Docker Hub

Opret disse to repositories på din Docker Hub-konto:

- `minions-api`
- `minions-web`

De skal være offentlige, medmindre miljøet, der skal hente dem, er logget ind
på Docker Hub.

## 2. Log ind på Docker Hub

```bash
docker login
```

## 3. Byg og push images

Erstat `<dockerhub-account>` med dit Docker Hub-brugernavn:

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

`--push` uploader imaget direkte til Docker Hub, når buildet er færdigt.
Platformen `linux/amd64` passer til den VM, som projektet som udgangspunkt
kører på hos Fly.io.

## 4. Ret image-navnene i Compose-filen

Udskift `<dockerhub-account>` i `compose.yaml`, så de to services peger på
dine egne images:

```yaml
api:
  image: <dit-brugernavn>/minions-api:latest

web:
  image: <dit-brugernavn>/minions-web:latest
```

## 5. Deploy til Fly.io

Log ind, og deploy projektet fra projektmappen:

```bash
fly auth login
fly deploy
```

Fly.io bygger Nginx-imaget og henter API- og web-imagene fra Docker Hub ud
fra `compose.yaml`.

Når der er ændringer i API'et eller webapplikationen, skal de pågældende
images bygges og pushes igen. Kør derefter `fly deploy` for at lave en ny
deployment.
