# Litestream, Pocketbase/PocketCMS on Google Cloud Run

Combined with Google Cloud Build and Google Cloud Run, you can make GCloud build your Dockerfile for Pocketbase/PocketCMS and run it in a serverless environment, with replication / backup using Litestream to backup to a Google Cloud Storage bucket.

This repo was build from the following guides / repos:

- https://litestream.io/guides/gcs/
- https://github.com/steren/litestream-cloud-run-example/tree/main
- https://github.com/bscott/pocketbase-litestream

# Steps

1. fork this repo
2. create a Google Cloud storage bucket (does not need to be publicly available)
3. create a new Google Cloud Run service, set it to continuously deploy from a GitHub repository (the one you forked) using the `/Docerfile`
4. make sure the service is public, has an always allocated CPU, and has minimum (and maximum) CPUs set to 1
5. the default port that Google Cloud Run listens on is `8090`, but pocketcms/pocketbase uses `8090`, make sure to change the container port to `8090`
6. in VARIABLES & SECRETS, set: `REPLICA_URL` to `gcs://YOUR_BUCKET_NAME/db`
7. once the service is set up it will automatically trigger a build. any time a new change is pushed to the repo the service will be built and re-deployed.
