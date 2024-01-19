# Tell us who you employ

A Rails app and OAuth consumer, backed by a PostgreSQL database.

It allows users to review and update details of who they employ, for compliance reasons.

For Buckinghamshire Council's family information team.

It uses [Outpost](https://github.com/wearefuturegov/outpost) as an identity provider, but could be adapted to use any OAuth 2.0 provider.

## Running it locally

**Using docker:**

```
cp -rp sample.env .env
docker compose up -d
docker compose exec app yarn
```

**On your local machine:**

```
cp -rp sample.env .env
uncomment DATABASE_URL line
yarn
bundle install
rails db:setup
rails s
```

## Config

You need to set the following environment variables for it to work:

```
OAUTH_SERVER
OAUTH_CLIENT_ID
OAUTH_SECRET
```

Locally, you can use a `.env` file in the project root.

If you're using it with Outpost, you can get these from `/oauth/applications` while logged in as an administrator.

The redirect URI ends in `.../auth/outpost/callback`.

## Running it on the web

Suitable for Heroku and other 12-factor compliant hosting.

## Running production locally

When ssl is forced

```
# make a self signed certificate
mkdir certs && cd certs

mkcert \
-cert-file tell-us.local.crt \
-key-file tell-us.local.key \
tell-us.local

cd ..

docker compose -f docker-compose.production.yml up -d

```
