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
docker compose build 
```
    
## Default Admin creds 

    admin:admin

## Next times 
```shell
docker compose up --build
```

## Admin interface 
http://localhost:8000/admin/

# Working with deps 

## Build base image 
```shell
docker build -f base.Dockerfile -t djangoheads/{{ cookiecutter.project_slug }}:base .
```

## Add Dependency to pyproject.toml example
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/{{ cookiecutter.project_slug }}:base poetry add [dependency name]
```

## Update poetry.lock and pyproject.toml
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/{{ cookiecutter.project_slug }}:base poetry update --lock
```

## Update requirements.txt
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/{{ cookiecutter.project_slug }}:base poetry export -o requirements.txt
```
    
### Development 
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/{{ cookiecutter.project_slug }}:base poetry export --with dev -o requirements.dev.txt
```
