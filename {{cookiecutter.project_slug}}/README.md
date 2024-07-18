# Local Development (for dep introspection and intellisense) 

## Install Brew 
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

sudo apt-get install build-essential
brew install gcc
```

## Install Requirements 
```shell
brew install python@3.11
pip3.11 install -r requirements.dev.txt
```

## Install Pre-Commits 
```shell
pre-commit install
```

# Run  

## First time 
```shell
echo "DJANGO_DEBUG=1" > .env 
docker compose -f docker/build.yml build
```
    
## Default Admin creds 

    admin:admin

## Next times 
```shell
docker compose -f docker/backend.yml up --build
```

## Admin interface 
http://localhost:8000/admin/

# Working with deps

## Add Dependency to pyproject.toml example
```shell
docker compose -f docker/utils.yml run poetry add [dependency name]
```

## Remove Dependency to pyproject.toml example
```shell
docker compose -f docker/utils.yml run poetry remove [dependency name]
```

## Update dependencies in pyproject.toml and poetry.lock
```shell
docker compose -f docker/utils.yml run poetry update --lock
```

## Export to requirements.txt and requirements.dev.txt
```shell
docker compose -f docker/utils.yml run poetry-export
```

# Create Django Migrations
```shell
docker compose -f docker/utils.yml run makemigrations
```
