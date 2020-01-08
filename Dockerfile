FROM nginx

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081

# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

RUN addgroup nginx root



# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    wget \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*
 
 #create cert
 RUN cd ~
 RUN mkdir cert && cd cert
 RUN openssl genrsa -aes256 -out ca/ca.key 4096 chmod 400 ca/ca.key
 RUN openssl req -new -x509 -sha256 -days 730 -key ca/ca.key -out ca/ca.crt
 RUN chmod 444 ca/ca.crt
 RUN openssl genrsa -out server/client-ssl.bauland42.com.key 2048
 RUN chmod 400 server/client-ssl.bauland42.com.key
 RUN openssl req -new -key server/client-ssl.bauland42.com.key -sha256 -out server/client-ssl.bauland42.com.csr
 
 RUN openssl x509 -req -days 365 -sha256 -in server/client-ssl.bauland42.com.csr -CA ca/ca.crt -CAkey ca/ca.key -set_serial 1 -out server/client-ssl.bauland42.com.crt
 RUN chmod 444 server/client-ssl.bauland42.com.crt
 
 #client cert
 RUN openssl genrsa -out client/heiko.key 2048
 RUN openssl req -new -key client/heiko.key -out client/heiko.csr
 RUN openssl x509 -req -days 365 -sha256 -in client/heiko.csr -CA ca/ca.crt -CAkey ca/ca.key -set_serial 2 -out client/heiko.crt
 
 
 
 # configer nginx
 COPY nginx.conf /etc/nginx/nginx.conf
 
 
USER nginx
