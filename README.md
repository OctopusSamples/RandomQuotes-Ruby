Install Unicorn with `gem install unicorn`

Start Unicorn with `unicorn -c unicorn.rb -E development`

Save the following as `/etc/nginx/conf.d/sinatra.conf` (assumes this code is in `/opt/RandomQuotes-Ruby`):

```
# use the socket we configured in our unicorn.rb
upstream unicorn_server {
    server unix:/opt/RandomQuotes-Ruby/tmp/sockets/unicorn.sock fail_timeout=0;
}

# configure the virtual host
server {
    # replace with your domain name
    server_name my-sinatra-app.com;
    # replace this with your static Sinatra app files, root + public
    root /opt/RandomQuotes-Ruby/lib/public;
    # port to listen for requests on
    listen 8080;
    # maximum accepted body size of client request
    client_max_body_size 4G;
    # the server will close connections after this time
    keepalive_timeout 5;

    location / {
        try_files $uri @app;
    }

    location @app {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        # pass to the upstream unicorn server mentioned above
        proxy_pass http://unicorn_server;
    }
}
```

Run NGINX with `nginx -g 'daemon off;'`

Open http://localhost:8080/index.html