# Using nginx docker image running as unprivileged user
FROM nginxinc/nginx-unprivileged:1-alpine

LABEL maintainer="thalescandidorosa@gmail.com"

USER root

# Overwrite the default configuration
COPY ./default.conf /etc/nginx/conf.d/default.conf
RUN mkdir /etc/nginx/locations
ADD ./locations/ /etc/nginx/locations

# Create static files folder and change its permission
RUN mkdir /vol
RUN chmod 755 /vol

# Switch back to unprivileged user
USER nginx
