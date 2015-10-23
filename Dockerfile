FROM debian:latest
MAINTAINER FROYO75

RUN apt-get update && apt-get install -y wget gcc make curl net-tools \
&& cd /tmp/ \
&& echo 'Downloading...Openssl-1.0.1f' && wget -q https://www.openssl.org/source/old/1.0.1/openssl-1.0.1f.tar.gz \
&& /bin/tar -xzf openssl-1.0.1f.tar.gz \
&& echo 'Downloading...PCRE-4.4' && wget -q "http://sourceforge.net/projects/pcre/files/pcre/4.4/pcre-4.4.tar.gz/download" -O pcre-4.4.tar.gz \
&& /bin/tar -xzf pcre-4.4.tar.gz \
&& echo 'Downloading...ZLIB-1.2.8' && wget -q http://zlib.net/zlib-1.2.8.tar.gz \
&& /bin/tar -xzf zlib-1.2.8.tar.gz \
&& echo 'Downloading...NGINX-1.9.5' && wget -q http://nginx.org/download/nginx-1.9.5.tar.gz \
&& /bin/tar -xzmf nginx-1.9.5.tar.gz \
&& cd nginx-1.9.5 \
&& echo 'INSTALLING NGINX WITH OPENSSL-1.0.1f...' \
&& ./configure --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module --with-openssl=../openssl-1.0.1f --with-pcre=../pcre-4.4 --with-zlib=../zlib-1.2.8 \
&& make && make install && make clean \
&& echo 'CONFIGURING NGINX...' \
&& sed -i '98,115s/#//g' /usr/local/nginx/nginx.conf \
&& sed -ie 's/cert.pem/nginx.crt/g;s/cert.key/nginx.key/g' /usr/local/nginx/nginx.conf \
&& echo 'daemon off;' >> /usr/local/nginx/nginx.conf

COPY entrypoint.sh /usr/local/nginx/entrypoint.sh
RUN chmod a+x /usr/local/nginx/entrypoint.sh

EXPOSE 80 443

WORKDIR /usr/local/nginx

ENTRYPOINT ["/usr/local/nginx/entrypoint.sh"]
CMD ["/usr/local/nginx/nginx"]




