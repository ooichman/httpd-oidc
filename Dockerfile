# Base on the Fedora
FROM centos:7
MAINTAINER  Oren Oichman email me@comefind.me # not a real email

# Update image and install httpd
RUN echo "Updating all centos packages"; yum -y update && echo "installing EPEL"; yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm && echo "Installing httpd"; yum -y install httpd mod_auth_openid mod_auth_openidc policycoreutils-python-utils 

#ADD main.conf /etc/httpd/conf.d/
#ADD index.html /var/www/html/
ADD httpd-run.sh /usr/sbin/
RUN mkdir /home/apache && mkdir /home/apache/logs && chown apache:apache -R /home/apache
RUN chown apache:apache /usr/sbin/httpd-run.sh && chmod 4755 /usr/sbin/httpd-run.sh
RUN echo "IncludeOptional /home/apache/*.conf" >> /etc/httpd/conf/httpd.conf
RUN echo "You have logged in successfully" > /var/www/html/index.html
RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf
RUN sed -i 's/ErrorLog .*/ErrorLog \/dev\/stderr/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/CustomLog .*/CustomLog \/dev\/stdout combined/g' /etc/httpd/conf/httpd.conf
RUN sed -i 's/LoadModule auth_digest_module modules\/mod_auth_digest.so//' /etc/httpd/conf.modules.d/00-base.conf
RUN echo "PidFile /home/apache/httpd.pid" >> /etc/httpd/conf/httpd.conf

# Expose the default httpd port 8080
ENV APACHE_HTTP_PORT_NUMBER=8080
EXPOSE 8080

USER apache
# Run the httpd
CMD ["/usr/sbin/httpd-run.sh"]
