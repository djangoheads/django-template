FROM python:3.11

ARG DOCKER_BUILD_REQUIREMENTS=requirements.txt

ENV DOCKER_BUILD_ENVIRONMENT=${DOCKER_BUILD_ENVIRONMENT}
ENV DJANGO_SETTINGS_MODULE=service.settings
ENV ROOT_PATH_FOR_DYNACONF=/home/app/config

# Install core libs
RUN apt-get update && apt-get install -y \
  apt-utils \
  netcat-traditional \
  binutils \
  libproj-dev \
  libpq-dev \
  gdal-bin

# Install deps
COPY $DOCKER_BUILD_REQUIREMENTS /tmp/install/
WORKDIR /tmp/install
RUN pip install -r $DOCKER_BUILD_REQUIREMENTS

# Limited scope (User) context
# Prepare app user
RUN useradd --create-home app
WORKDIR /home/app

# Prepare app bin
COPY --chown=app ./entrypoint.sh /home/app/bin/entrypoint.sh
RUN chmod -R +x /home/app/bin
ENV PATH="/home/app/bin:$PATH"

# Install source code
RUN mkdir -p /home/app/libs
WORKDIR /home/app/libs
ENV PYTHONPATH="/home/app/libs"

# Prepare Gunicorn Conf
COPY --chown=app ./gunicorn.conf.py /home/app/config/gunicorn.conf.py

# Move base Config
COPY --chown=app ./settings.yaml /home/app/config/settings.yaml

# Move app source
COPY --chown=app ./src /home/app/libs/

# Init static
RUN mkdir -p /var/www/static && chown -R app:app /var/www/static

RUN chmod +664 -R /home/app
RUN chmod +x -R /home/app/libs
USER app
EXPOSE 8000

# Init media 
RUN mkdir -p /var/www/media && chown -R app:app /var/www/media
VOLUME /var/www/media

ENTRYPOINT ["entrypoint.sh"]

CMD ["serve"]
