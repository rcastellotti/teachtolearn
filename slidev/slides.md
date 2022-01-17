---
class: "text-center"
highlighter: shiki
drawings:
  persist: true
---

# teachtolearn.club

a project by: [Roberto Castellotti](https://rcastellotti.dev), [Fabio Fontana](https://fabifont.github.io), [Federico Fontana](https://github.com/fedfontana)

<div class="abs-br m-6 flex gap-2">
  <a href="https://gitlab.com/rcastellotti/teachtolearn" target="_blank" alt="GitHub"
    class="text-xl icon-btn opacity-50 !border-none !hover:text-white">
    <file-icons-gitlab />
  </a>
</div>

---
layout: center
---
<div class=" text-2xl md:text-6xl flex font-extrabold line-xs">
  <div>
      wanna learn? <br> start
      <span
        class="inline-block bg-blue-500 p-2 text-white"
        style="border-radius: 91% 9% 90% 10% / 29% 82% 18% 71%"
        >teaching
      </span>
  </div>
</div>
<ol class="list-decimal list-inside">
  <li><a href="https://teachtolearn.club/signup">signup</a></li>
  <li>enroll in a course</li>
  <li>find something you want to learn</li>
  <li>teachtolearn!</li>
</ol>
---

# our tech stack

Here is a list of libraries/tools/services we are using

- <simple-icons-insomnia/> - Insomnia and Insomnia documenter ([docs.teachtolearn.club](https://docs.teachtolearn.club))
- <vscode-icons-file-type-docker/> - Fully containerized source code and database ([production.yml](https://gitlab.com/rcastellotti/teachtolearn/-/blob/main/production.yml))
- <vscode-icons-file-type-python/> - Python backend ([Flask](https://flask.palletsprojects.com/en/2.0.x/), [SQLalchemy](https://www.sqlalchemy.org/), [Marshmallow](https://marshmallow.readthedocs.io/en/stable/))
- <logos-postgresql/> - [PostgreSQL](https://www.postgresql.org/) The World's Most Advanced Open Source Relational Database
- <vscode-icons-file-type-svelte/> - Frontend [Sveltekit](https://kit.svelte.dev) and [Svelte](https://svelte.dev)
- <vscode-icons-file-type-gitlab/> - [GitLab](https://gitlab.com) as code hosting / CI-CD tool / container registry
- <carbon-email/> - [Sendgrid](https://sendgrid.com) to send emails
- <entypo-bucket/> - [min.io](https://min.io) an high performance, S3 compatible, distributed object storage system.

-  <span class="flex"> <img class="w-4 mr-2" src="/traefik.png"> - <span class="mx-2">[Traefik](https://traefik.io)</span> a high performance cloud-native reverse proxy and loadbalancer. </span>

---

# cat ./backend/Pipfile

```
...

[packages]
flask = "*"
flask-sqlalchemy = "*"
sqlalchemy = "*"
python-dotenv = "*"
flask-cors = "*"
marshmallow = "*"
pyjwt = "*"
sendgrid = "*"
minio = "*"
cryptography = "*"
nanoid = "*"
pygments = "*"
pg8000 = "*"
gunicorn = "*"
ua-parser = "*"
requests = "*"
...


```

<style>
  pre{
    @apply text-xs !important

  }
  </style>

---

## untested code is broken code

Untested code is broken code, we are using [pytest](https://docs.pytest.org/en/6.2.x/) and [pytest-cov](https://pytest-cov.readthedocs.io/en/latest/) to test our code, tests are run both locally and in CI.

```yaml
test:
  stage: test
  image:
    name: registry.gitlab.com/rcastellotti/teachtolearn/backend:$CI_COMMIT_SHORT_SHA
  script:
    - apk update && apk add postgresql
    - pip3 install pytest testing.postgresql
    - adduser -D test
    - su - test -c "pytest --cov /app"
  rules:
    - if: '$CI_PIPELINE_SOURCE == "merge_request_event"'
      changes:
        - backend/app/*
```

---
layout: center
---
```text
 ----------- coverage: platform linux, python 3.9.7-final-0 -----------
Name                         Stmts   Miss  Cover
------------------------------------------------
app/admin/routes.py            124      1    99%
app/admin/utils.py              12      2    83%
app/constants.py                21      1    95%
app/courses/routes.py           67      1    99%
app/lectures/routes.py          79      0   100%
app/models.py                  195     20    90%
app/reservations/routes.py      62      0   100%
app/reviews/routes.py           43      0   100%
app/schemas.py                 127      9    93%
app/search/routes.py            32      0   100%
app/users/routes.py            192     20    90%
app/users/utils.py              29     14    52%
app/utils.py                    30      0   100%
------------------------------------------------
TOTAL                         1013     68    93%
```

<style>
  pre{
    @apply text-xs !important

  }
  </style>

---

# sqlachemy models

```python
class Course(db.Model):
    __tablename__ = "courses"
    abbreviation = db.Column(db.String(8), primary_key=True, index=True)
    name = db.Column(db.String(64), nullable=False)
    icon = db.Column(db.String(32), nullable=False)
    color = db.Column(db.String(16), nullable=False)
    latitude = db.Column(db.Float)
    longitude = db.Column(db.Float)
    address = db.Column(db.String(256))
    syllabus = db.Column(db.String(1024), nullable=False)
    maxStudents = db.Column(db.Integer, nullable=False)
    enrolledStudents = db.Column(db.Integer, nullable=False)
    teacher = db.relationship("User", back_populates="courses")
    teacherId = db.Column(
        db.String(16),
        db.ForeignKey(User.id, ondelete="cascade", onupdate="cascade"),
        nullable=False,
    )
    isBanned = db.Column(db.Boolean, default=False, nullable=False)
    isDeleted = db.Column(db.Boolean, default=False, nullable=False)
    lectures = db.relationship("Lecture", back_populates="course")

```

---

<img  class="mx-auto h-full" src="/db-schema.png">

---

# security

- <emojione-v1-cookie/> - [cookies](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie) are: `sameSite` (CSRF-proof),`secure` (https only),`httpOnly` (no js allowed)

- <fluent-password-24-regular/> + <tabler-salt/> passwords are stored hashed with a salt using

  ```python
  werkzeug.security.generate_password_hash(password, method='pbkdf2:sha256', salt_length=16)
  ```

  and are compared using

  ```python
  werkzeug.security.check_password_hash(pwhash, password)
  ```

- svelte by default does html escaping, making it [XSS-proof](https://svelte.dev/docs#template-syntax-html)
- `.execute()` used internally by [pg8000](https://github.com/tlocke/pg8000) [uses prepared statements](https://www.python.org/dev/peps/pep-0249/#id15) making it SQLInjection-proof

- TLS certificates provided by [Let's Encrypt](https://letsencrypt.org/) and managed automatically by [traefik](https://doc.traefik.io/traefik/https/acme/)
---

# further improvements

Here is a list of possible improvements:

- <vscode-icons-file-type-graphql/> - switch to [graphQL](https://graphql.org) (solves overfetching,underfetching, data manipulation)

- <vscode-icons-file-type-go/> - rewrite backend in Golang to have a single binary
- <vscode-icons-file-type-typescript/> - rewrite frontend in Typescript (better development experience)
- <logos-vercel-icon/> - [vercel/pkg](https://github.com/vercel/pkg) to compile node to single binary
- <logos-nomad/> - <logos-consul/> deploy using [nomad](https://nomadproject.io) (orchestrator) and [consul](https://consulproject.io) (service mesh) on a cloud provider
- <logos-vault-icon/> - manage secrets using [vault](https://www.vaultproject.io/) on a cloud provider
- <logos-prometheus/> - configure logging using [prometheus](https://prometheus.io/)
- <carbon-data-backup/> - backup Postgres using [rcastellotti/postgres-backup-s3](https://gitlab.com/rcastellotti/postgres-backup-s3)
<!--overfetching is a problem whenever connection degrades -->
