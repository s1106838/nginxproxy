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
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*
 
 
 
 
 
 # configer nginx
RUN wget --no-check-certificate --no-cache --no-cookies https://raw.githubusercontent.com/s1106838/nginxproxy/master/nginx.conf.13
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
RUN mv nginx.conf.13 /etc/nginx/nginx.conf




# comment user directive as master process is run as user in OpenShift anyhow
RUN sed -i.bak 's/^user/#user/' /etc/nginx/nginx.conf


#download the certs


RUN wget https://github.com/s1106838/nginxproxy/raw/master/cert.zip
RUN unzip cert.zip
RUN rm -rf *.zip
RUN mkdir /etc/nginx/cert/
RUN mv /*.crt /etc/nginx/cert/
RUN mv /*.key /etc/nginx/cert/
RUN mv /*.csr /etc/nginx/cert/







# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx

USER nginx
