# Tell us who you employ

A Rails app and OAuth consumer, backed by a PostgreSQL database.

It allows users to review and update details of who they employ, for compliance reasons.

For Buckinghamshire Council's family information team.

It uses [Outpost](https://github.com/wearefuturegov/outpost) as an identity provider, but can theoretically use any OAuth 2.0 provider.

## Running it locally

```
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

## Running it on the web

Suitable for Heroku and other 12-factor compliant hosting.