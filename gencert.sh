/bin/bash

#create cert
   cd ~
   mkdir cert && cd cert
   openssl genrsa -aes256 -out ca.key 4096 
   chmod 400 ca.key
   openssl req -new -x509 -sha256 -days 730 -key ca.key -out ca.crt
   chmod 444 ca.crt
   openssl genrsa -out client-sclient-ssl.bauland42.com.key 2048
   chmod 400 client-ssl.bauland42.com.key
   openssl req -new -key client-sclient-ssl.bauland42.com.key -sha256 -out client-ssl.bauland42.com.csr
 
   openssl x509 -req -days 365 -sha256 -in client-ssl.bauland42.com.csr -CA ca/ca.crt -CAkey ca.key -set_serial 1 -out client-ssl.bauland42.com.crt
   chmod 444 client-ssl.bauland42.com.crt
 
 #client cert
   openssl genrsa -out heiko.key 2048
   openssl req -new -key heiko.key -out heiko.csr
   openssl x509 -req -days 365 -sha256 -in heiko.csr -CA ca.crt -CAkey ca.key -set_serial 2 -out heiko.crt
   openssl pkcs12 -export -clcerts -in heiko.crt -inkey heiko.key -out heiko.p12
