# teachtolearn.club

[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)

## Development

A `docker-compose-dev.yml` is provided, to use it simply run

```
docker-compose -f docker-compose-dev.yml build
docker-compose -f docker-compose-dev.yml up
```

However to experience hot reload we highly suggest to run natively

0. setup `pre-commit`: `pipenv run pre-commit install`
1. start database `docker-compose -f infra/storage.yml`
2. start backend
   ```cd backend
   pipenv install
   pipenv run flask createdb
   pipenv run flask run
   ```
3. start frontend
   ```
   cd frontend
   npm install
   npm run dev -- --open
   ```

## testing

Pytest is used to test backend, to run tests:

```
pipenv install --dev
pytest --vv
```

Run test and get coverage report (from backend folder):
```
pytest --cov-config=.coveragerc --cov=. --cov-report=html
```

## Enviroment variables

In production the only config needed is `.env.prod`, make sure to create it by editing `.env.prod.sample`.

`SENDGRID_API_KEY` is [Sengrid](https://sendgrid.com)'s api key, make sure to get one and follow instructions to authenticate your sender domain.

## Infrastructure

### GitLab runner

Docker images are built in CI, jobs are picked up by a self-hosted [runner](https://docs.gitlab.com/runner/).

```
docker run -d \
    --name gitlab-runner \
    --restart always \
    -v gitlab-runner:/etc/gitlab-runner \
    -v /var/run/docker.sock:/var/run/docker.sock \
    gitlab/gitlab-runner:latest
```

`docker exec -it gitlab-runner bash`

get a registration token: <kbd>Settings > General > CI/CD > Runners</kbd>

```
gitlab-runner \
    register -n \
    --name "teachtolearn Runner" \
    --executor docker \
    --docker-image docker:latest \
    --docker-volumes /var/run/docker.sock:/var/run/docker.sock \
    --url https://gitlab.com \
    --registration-token <GITLAB_TOKEN> \
```

## misc

- `docker-compose-prod.yml` assumes an external network was created by running `docker network create web` and a fully configured [traefik](https://traefik.com) instance to route traffic.

- Python dependencies are managed using [Pipenv](https://pipenv.pypa.io/en/latest/), to lock dependencies for prodcution use `pipenv lock -r > requirements.txt`

- promote a user to admin using `flask promote --u <USERNAME>`
