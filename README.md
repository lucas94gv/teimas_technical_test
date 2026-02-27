# ⚽ Football App – Backend API (Ruby on Rails)

API REST para la aplicación de fútbol.  
Gestiona autenticación con JWT, usuarios y equipos favoritos.

---

## Tecnologías

- Ruby 3.4.6
- Rails 8.1.2
- PostgreSQL

---

## Instalación

```
git clone git@github.com:lucas94gv/teimas_technical_test.git
cd football-api
bundle install
```

- Edit config/database.yml
```
rails db:create
rails db:migrate
```

## Variables de entorno

- touch .env
- Edit .env
- Add JWT_SECRET
- Add DB_HOST, DB_PORT, DB_USERNAME, DB_PASSWORD, DB_NAME_DEVELOPMENT, DB_NAME_TEST, DB_NAME_PRODUCTION
- Due to restrictions with the api-football API, mock data has been added and this environment variable must be added:
- USE_MOCK=true

## Autenticación
- POST /register → crea usuario
- POST /login → devuelve token
- El frontend guarda el token
- Se envía en cada request protegida:
- Authorization: Bearer TU_TOKEN

## Tests
. Rspec spec