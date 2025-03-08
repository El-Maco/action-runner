## First run
Set the `runner.env` variables
```bash
REPO_URL=
RUNNER_TOKEN=
NAME= #Optional
```

And then run
```bash
docker compose up -d
```
should do everything

## Rebuild
```bash
docker compose build --no-cache
```
