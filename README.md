Nginx to be used a Docker deployment on Render.

# Why does this exist?
Render is great in that you can build and run any dockerized service. However, in order to do so, you must provide the Dockerfile within a repository for it to build, so publicly available images can't be used directly. That said, this repository simply wraps nginx in another Dockerfile that render will build and run.

nginx makes a good reverse proxy so that you can create all of your services as "Private Services" on Render except for this nginx service. This helps provide a level of security and also allows you to route traffic by path on the same hostname.

# How to use

1. Reference the repository URL as a public repository when launching a new service.
2. Create a secret file named `nginx.conf`. This will be the configuration file nginx will use.

## Sample `nginx.conf`

Below is an example of a configuration file with a health check and a path for which nginx serves as a reverse proxy.

```
upstream my_service {
  server myservice:1000;
}

server {
  listen 1000;
  listen [::]:1000;

  server_name foobar.onrender.com;

  location /healthz {
    return 200 'ok';
    add_header Content-Type text/plain;
  }

  location /some/path {
    proxy_pass http://my_service/;
    proxy_cache_bypass $http_upgrade;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Port $server_port;
  }
} 
```

In this example, `foobar.onrender.com` is the hostname of the service on Render, listening on port 1000. You'll need to change both the hostname and port to match the service.

`foobar.onrender.com/healthz` is a health check URL that does nothing by return a 200 status code.

`foobar.onrender.com/some/path` is reverse proxied to the upstream service titled "my_service". This service is defined by the host:port combination `myservice:1000`. Change this to match the private service you want to reverse proxy on Render.

# Contributing

* Please file an issue if there's a bug or feature request.
* Pull requests are welcome and will be reviewed/merged as appropriate.

# License

MIT License