FROM nginx

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

# users are not allowed to listen on priviliged ports
RUN sed -i.bak 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf
EXPOSE 8081
EXPOSE 4433



RUN addgroup nginx root



# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    wget \
    openssh-client \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*
 
 
 
 
 
 # configer nginx
RUN wget https://raw.githubusercontent.com/s1106838/nginxproxy/master/nginx.conf
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
#RUN mv nginx.conf /etc/nginx/nginx.conf

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx


# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf

USER nginx
