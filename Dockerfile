# syntax=docker/dockerfile:1.2

FROM nginx

# Disable nginx welcome page
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.disabled

# Copy nginx conf from Render secret named `nginx.conf`
COPY nginx.conf /etc/nginx/conf.d/nginx.conf

# Test config
RUN nginx -t
