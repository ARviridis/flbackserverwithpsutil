FROM centos:8
MAINTAINER kod
RUN yum -y install httpd

RUN yum install -y python3-mod_wsgi.x86_64
RUN yum install -y python3-devel
RUN yum install -y python3-setuptools
RUN yum install -y mc
RUN mkdir /var/www/testapp
COPY . /var/www/testapp/
RUN cd /usr/local/bin; ln -s /usr/bin/python3 python

RUN adduser testapp
RUN cd /var/www/testapp
RUN dnf install -y gcc.x86_64
RUN yum install -y python3-pip
RUN yum clean all
RUN chown -R testapp:disk /var/www/testapp
RUN apachectl configtest
COPY testapp.conf /etc/httpd/conf.d/testapp.conf

COPY /venv/lib/  /usr/local/lib/
COPY /venv/lib64/  /usr/local/lib64/

RUN mv -fv /var/www/testapp/app/timemonfs.py /var/www/testapp/app/timemon.py
RUN mv -fv /var/www/testapp/app/infofs.py /var/www/testapp/app/info.py

RUN yum clean all

RUN chmod 755 /usr/sbin/httpd 
EXPOSE 80
ENTRYPOINT ["/bin/bash", "/usr/sbin/apachectl", "-D", "FOREGROUND"]




