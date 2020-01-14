FROM nginx

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
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*
 
 
 
 
 
 # configer nginx
RUN wget --no-check-certificate --no-cache --no-cookies https://github.com/s1106838/nginxproxy/raw/master/clientcert_conf12.zip
RUN unzip clientcert_conf12.zip
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.back

RUN mv default nginx.conf
RUN mv nginx.conf /etc/nginx/nginx.conf




#make hello page
RUN mkdir -p /var/www/html/

RUN wget https://raw.githubusercontent.com/webcomponents/hello-world-element/master/hello-world.html
RUN mv hello-world.html index.html
RUN mv index.html /var/www/html/




# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf


#move the certs

RUN mkdir -p /etc/nginx/ssl/nginx/
RUN mv /*.crt /etc/nginx/ssl/nginx/
RUN mv /*.key /etc/nginx/ssl/nginx/
RUN mv /*.csr /etc/nginx/ssl/nginx/
RUN mv /*.pem /etc/nginx/ssl/nginx/
RUN mv /*.pfx /etc/nginx/ssl/nginx/


#Environment Variables
#change for different servers to proxy to
#max 1 backend name
ENV BACKEND_API http://172.17.0.16:8080;


# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

USER nginx
