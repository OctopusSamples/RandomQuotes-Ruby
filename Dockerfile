FROM alpine:3.10

# Install packages
RUN apk --no-cache add linux-headers build-base ruby ruby-dev ruby-rdoc ruby-etc nginx supervisor curl

# Configure nginx
COPY config/randomquotes.conf /etc/nginx/conf.d/randomquotes.conf
# Remove the default site
RUN rm /etc/nginx/conf.d/default.conf
# Add the location for the PID file
RUN mkdir /run/nginx

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /var/lib/nginx && \
  chown -R nobody.nobody /var/tmp/nginx && \
  chown -R nobody.nobody /var/log/nginx

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /var/www/html
RUN mkdir log; mkdir tmp; mkdir tmp/pids; mkdir tmp/sockets
COPY --chown=nobody lib/ /var/www/html/lib
COPY --chown=nobody unicorn.rb /var/www/html/unicorn.rb
COPY --chown=nobody config.ru /var/www/html/config.ru
COPY --chown=nobody Gemfile /var/www/html/Gemfile
COPY --chown=nobody Gemfile.lock /var/www/html/Gemfile.lock

ENV GEM_HOME /var/www/html/vendor
ENV GEM_PATH /var/www/html/vendor
ENV PATH "/var/www/html/vendor/bin:${PATH}"
RUN gem install bundler -v "$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1)"
RUN bundle install

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & unicorn
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]