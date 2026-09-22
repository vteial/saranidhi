# PocketBase image for Practice Sync (hosted backend — Fly.io / Railway / any container host).
# Single static binary + baked-in migrations. The SQLite data lives on a mounted volume
# (see fly.toml [[mounts]]), so it survives restarts and image rebuilds.
#
# Migrations are the SAME files used for local dev (tool/dev/pb_migrations) — this Dockerfile
# is built with the REPO ROOT as context so it can COPY them (see deploy note below).
#
#   Build context = repo root:  fly deploy --config deploy/pocketbase/fly.toml --dockerfile deploy/pocketbase/Dockerfile .
#
FROM alpine:3.20

ARG PB_VERSION=0.22.21
RUN apk add --no-cache unzip ca-certificates
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# One source of truth for the schema: the same migrations local dev uses.
COPY tool/dev/pb_migrations /pb/pb_migrations

EXPOSE 8080
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pb/pb_data", "--migrationsDir=/pb/pb_migrations"]
