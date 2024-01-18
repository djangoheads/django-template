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

## Pull latest DjangoHeads tools image
```shell
docker pull djangoheads/tools:3.11-latest
```

## Add Dependency to pyproject.toml example
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/tools:3.11-latest poetry add [dependency name]
```

## Update poetry.lock and pyproject.toml
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/tools:3.11-latest poetry update --lock
```

## Update requirements.txt
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/tools:3.11-latest poetry export -o requirements.txt
```
    
### Development 
```shell
docker run -it -v $(pwd):/app -w /app djangoheads/tools:3.11-latest poetry export --with dev -o requirements.dev.txt
```
