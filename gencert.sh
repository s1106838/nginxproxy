/bin/bash

#Create the CA Key and Certificate for signing Client Certs
openssl genrsa -aes256 -out ca.key 4096
openssl req -new -x509 -days 365 -key ca.key -out ca.crt

#Create the Server Key, CSR, and Certificate
openssl genrsa -aes256 -out server.key 1024
openssl req -new -key server.key -out server.csr

#Self-sign the certificate with our CA cert
openssl x509 -req -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt

#Create the Client Key and CSR
openssl genrsa -aes256 -out client.key 1024
openssl req -new -key client.key -out client.csr

#Sign the client certificate with our CA cert
openssl x509 -req -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out client.crt
