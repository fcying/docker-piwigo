# Piwigo-Docker

This is an image for piwigo, linked with a mysql database.
Data must be stored on a volume.

## Features
- Easy deployment of Piwigo with a docker-compose.

## Deployment

Edit this `docker-compose.yml` and launch with the command `$ docker-compose up -d `

```
mysql:
image: mysql:5.7
  volumes:
    - ./mysql/:/var/lib/mysql
  environment:
    - MYSQL_ROOT_PASSWORD=MYROOTPASSWORD
    - MYSQL_DATABASE=piwigo
    - MYSQL_USER=piwigo
    - MYSQL_PASSWORD=MYUSERPASSWORD
  piwigo:
    image: fcying/piwigo
    links:
      - mysql:db
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - ./data:/data
      - ./galleries:/var/www/galleries
      - /var/log/piwigo:/var/log/apache2
    environment:
      - PGID=1000
      - PUID=1000
    ports:
      - "MYPORT:80"
    hostname: piwigo
    domainname: MYDOMAIN.COM
```

After db initialization (first launch), environment variables can me removed.
