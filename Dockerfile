error_log /var/log/nginx/error.log notice;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server {
        listen 8080;
        listen [::]:8080; # Fly.io bruger IPv6 internt

        resolver [fdaa::3] valid=5s;

        location /api/ {
            set $api_backend "http://docker-compose-exercise.internal:8080"; 
            
            proxy_pass $api_backend;
            
            rewrite /api/(.*) /$1 break; 

            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }

        location / {
            set $frontend_backend "http://docker-compose-exercise.internal:3000"; 
            
            proxy_pass $frontend_backend;
            
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
