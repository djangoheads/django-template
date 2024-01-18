FROM djangoheads/django:3.11-latest

ARG DOCKER_BUILD_REQUIREMENTS=requirements.txt
ENV DOCKER_BUILD_ENVIRONMENT=${DOCKER_BUILD_ENVIRONMENT}
ENV DJANGO_SETTINGS_MODULE=service.settings
ENV ROOT_PATH_FOR_DYNACONF=/home/app/config

USER root

# Install deps
COPY $DOCKER_BUILD_REQUIREMENTS /tmp/install/
WORKDIR /tmp/install
RUN pip install -r $DOCKER_BUILD_REQUIREMENTS

# Prepare Gunicorn Conf
COPY --chown=app ./config /home/app/config/

# Move app source
COPY --chown=app ./src /home/app/libs/

RUN chmod +664 -R /home/app
RUN chmod +x -R /home/app/libs

WORKDIR /home/app/libs

USER app
# NOTE: Do not set ENTRYPOINT as this image will become incompatible with PyCharm Remote Debugger
CMD ["manage.py", "runserver", "0.0.0.0:8000"]
