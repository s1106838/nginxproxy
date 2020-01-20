#FROM firesh/nginx-lua

FROM nginx
#FROM openresty/openresty:latest

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)4433;/listen 8080;/' /etc/nginx/conf.d/default.conf
EXPOSE 8080
EXPOSE 4433

RUN addgroup nginx root



# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    wget \
    openssh-client \
    unzip \
    zip \
    curl \
    nginx-extras \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*
 


 
 
 
 # configer nginx
RUN wget --no-check-certificate --no-cache --no-cookies https://github.com/s1106838/nginxproxy/raw/master/clientcert_conf22.zip
RUN unzip clientcert_conf22.zip

#this is used for the backend api
#ENV backendIpWithPort http://127.0.0.1:8080


#get scipt for setting the backend server when it starts
#CMD sed -s "s/\$backendIpWithPort/$backendIpWithPort/g" default >> /etc/nginx/nginx.conf


#backup default config
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.back
#move new config to nginx 
RUN mv default nginx.conf
RUN mv nginx.conf /etc/nginx/nginx.conf


#make hello page
#RUN mkdir -p /var/www/html/

#RUN wget https://raw.githubusercontent.com/webcomponents/hello-world-element/master/hello-world.html
#RUN mv hello-world.html index.html
#RUN mv index.html /var/www/html/




# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf


#move the certs

RUN mkdir -p /etc/nginx/ssl/nginx/
RUN mv /*.crt /etc/nginx/ssl/nginx/
RUN mv /*.key /etc/nginx/ssl/nginx/
RUN mv /*.csr /etc/nginx/ssl/nginx/
RUN mv /*.pem /etc/nginx/ssl/nginx/
RUN mv /*.pfx /etc/nginx/ssl/nginx/





# support running as arbitrary user which belogs to the root group
#RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx
RUN chown -R www-data:www-data /var/lib/nginx
RUN chmod -R 777 /var/lib/nginx/


USER nginx
