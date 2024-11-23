# Crea la imagen a partir de la imagen de Ubuntu 24.04

FROM ubuntu:24.04

# Añade metadatos con información descriptiva

LABEL \
	authors="antlopez" \
	version="1.1" \
	description="DEAW02 TE01" \
	creationDate="23-11-2024"

# Ejecuta los comandos necesarios

RUN \
	apt update \
	&& apt -y install nano apache2 \
	&& a2enmod ssl

# Copia los ficheros y directorios adaptados a la tarea

## Default Site
COPY html/index.html /var/www/html/
COPY html/css_index /var/www/html/

## antlopez.eus
COPY html/virtualhost.html /var/www/html/antlopez/
COPY html/css_virtualhost /var/www/html/antlopez/

## Privado
COPY html/privado.html /var/www/html/antlopez/privado/
COPY html/css_privado /var/www/html/antlopez/privado/

## Configuración del sitio www.antlopez.eus
COPY conf/virtualhost.conf /etc/apache2/sites-available/
COPY conf/virtualhost-ssl.conf /etc/apache2/sites-available/

## Certificado y clave privada
COPY conf/certs/antlopez-eus.pem /etc/ssl/certs/antlopez-eus.pem
COPY conf/certs/antlopez-eus.key /etc/ssl/private/antlopez-eus.key

## Fichero de contraseñas para Basic Auth
COPY conf/passwd /etc/apache2/

# Activa los sitios
RUN a2ensite virtualhost.conf virtualhost-ssl.conf

# Indica los puertos que deberían ser publicados al crear el contenedor
EXPOSE 80 443

# Al iniciar el contenedor se ejecuta Apache
CMD apachectl -D FOREGROUND
