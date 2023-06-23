# Local Development (for dep introspection and intellisense) 

## Install Brew 

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    
    sudo apt-get install build-essential
    brew install gcc

## Install Requirements 

    brew install python=3.11
    cd backend 
    pip install -r requirements.dev.txt

# Run  

## First time 

    echo "DJANGO_DEBUG=1" > .env 
    docker compose build 
    
## Default Admin creds 

    admin:admin

## Next times 

    docker compose up --build

## Admin interface 

    http://localhost:8000/admin/

# Working with deps 

## Build base image 

    docker build -t djangoheads/{{ cookiecutter.project_short_description }}:base .

## Update poetry.lock and pyproject.toml

    docker run -it -v $(pwd)/backend:/app -w /app djangoheads/{{ cookiecutter.project_short_description }}:base poetry update --lock

## Update requirements.txt

    docker run -it -v $(pwd)/backend:/app -w /app djangoheads/{{ cookiecutter.project_short_description }}:base poetry export -o requirements.txt
    
### Development 
    docker run -it -v $(pwd)/backend:/app -w /app djangoheads/{{ cookiecutter.project_short_description }}:base poetry export --with dev -o requirements.dev.txt