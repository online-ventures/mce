FROM nginx

# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils

# establish where Nginx should look for files
ENV RAILS_ROOT /var/www/html

# Set our working directory inside the image
WORKDIR $RAILS_ROOT

# Copy Nginx config template
COPY config/docker/web/nginx.conf /etc/nginx/conf.d/default.conf

# Pipe logging to stdout
RUN ln -sf /dev/stdout /var/log/nginx/access.log

# And error logging to stderr
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]
