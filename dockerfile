apt-get update
apt-get upgrade
apt install wget -y
apt install unzip -y
apt install net-tools -y
apt install curl -y
apt install vim -y
apt install telnet  -y
timedatectl set-timezone UTC
apt install build-essential unzip -y
apt install openssl libssl-dev -y
apt-get install lua5.2 -y
apt-get install libcurl4-openssl-dev -y
apt-get install libexpat1-dev -y




########################################################


######################################################

FROM apacheapispreinstall



RUN mkdir /usrdata/
RUN mkdir /usrdata/archive
RUN mkdir /usrdata/apps
RUN mkdir /usrdata/apps/syspacks
RUN mkdir /usrdata/apps/syspacks/pcre
RUN mkdir /usrdata/apps/httpserver/
RUN mkdir /usrdata/apps/syspacks/python3.5.2
RUN mkdir /usrdata/apps/syspacks/python3.4.2
RUN mkdir /usrdata/apps/syspacks/libxml2
RUN mkdir /usrdata/apps/syspacks/mod-security/
RUN mkdir  -p /usrdata/apps/httpserver/certificates/ca/

RUN  mkdir /usrdata/logs
RUN mkdir /usrdata/logs/httplogs/




RUN  groupadd servicesusrgroup
RUN useradd -d /home/jersey -m -N -g servicesusrgroup -c 'User to Run Services' jersey

RUN  cd /usrdata/archive

COPY pcre-8.35.tar.gz  /usrdata/archive/
COPY httpd-2.4.6.tar.gz httpd-2.4.6.tar.gz
RUN cd /usrdata/archive
RUN tar -xvzf /usrdata/archive/pcre-8.35.tar.gz -C /usrdata/archive/

RUN  cd /usrdata/archive/pcre-8.35 &&  ./configure --prefix=/usrdata/apps/syspacks/pcre/ --enable-utf --enable-unicode-properties && make &&  make install   



RUN cd /usrdata/archive
COPY httpd-2.4.6.tar.gz /usrdata/archive

RUN tar -xvzf httpd-2.4.6.tar.gz -C /usrdata/archive/




RUN cd /usrdata/archive

COPY apr-1.5.1.tar.gz  /usrdata/archive

COPY apr-util-1.5.3.tar.gz  /usrdata/archive
RUN mkdir /usrdata/archive/httpd-2.4.6/srclib/apr
RUN mkdir /usrdata/archive/httpd-2.4.6/srclib/apr-util
RUN tar -xvzf /usrdata/archive/apr-1.5.1.tar.gz  -C /usrdata/archive/httpd-2.4.6/srclib/apr  --strip-components 1

RUN tar -xvzf /usrdata/archive/apr-util-1.5.3.tar.gz -C  /usrdata/archive/httpd-2.4.6/srclib/apr-util  --strip-components 1




RUN   cd /usrdata/archive/httpd-2.4.6 &&  ./configure --with-included-apr --with-pcre=/usrdata/apps/syspacks/pcre/ --with-openssl=/usr/bin/ --prefix=/usrdata/apps/httpserver/ --with-crypto --enable-mods-shared=all --enable-alias --enable-allowmethods --enable-asis --enable-authz_host --enable-bucketeer --enable-cache --enable-cache_socache --enable-cache_disk --enable-case_filter --enable-case_filter_in --enable-dav --enable-disk_cache --enable-echo --enable-expires --enable-file_cache --enable-headers --enable-heartbeat --enable-heartmonitor --enable-log_config --enable-log_forensic --enable-mime --enable-mime_magic --enable-proxy --enable-proxy_ajp --enable-proxy_balancer --enable-proxy_connect --enable-proxy_express --enable-proxy_http --enable-ratelimit --enable-remoteip --enable-rewrite --enable-session --enable-session_cookie --enable-session_crypto --enable-session_dbd --enable-ssl --enable-status --enable-unique_id --enable-usertrack && make && make install  && rm -rf  /usrdata/apps/httpserver/conf/workers.properties && rm -rf   /usrdata/apps/httpserver/conf/uriworkermap.properties && rm -rf  /usrdata/apps/httpserver/conf/security.conf  && rm -rf /usrdata/apps/httpserver/conf/performance.conf  && rm -rf  /usrdata/apps/httpserver/conf/mod_jk.conf  && rm -rf /usrdata/apps/httpserver/conf/mod-ssl.conf && rm -rf  /usrdata/apps/httpserver/conf/httpd.conf

COPY httpd.conf /usrdata/apps/httpserver/conf/httpd.conf



COPY httpd.conf /usrdata/apps/httpserver/conf/httpd.conf
COPY workers.properties /usrdata/apps/httpserver/conf/workers.properties 
COPY uriworkermap.properties /usrdata/apps/httpserver/conf/uriworkermap.properties
COPY security.conf /usrdata/apps/httpserver/conf/security.conf
COPY performance.conf /usrdata/apps/httpserver/conf/performance.conf
COPY mod_jk.conf /usrdata/apps/httpserver/conf/mod_jk.conf
COPY mod-ssl.conf /usrdata/apps/httpserver/conf/mod-ssl.conf
COPY certificates/AddTrustExternalCARoot.crt /usrdata/apps/httpserver/certificates 
COPY certificates/wildcard_switchnwalk_com.key  /usrdata/apps/httpserver/certificates 
COPY certificates/STAR_switchnwalk_com.crt /usrdata/apps/httpserver/certificates 
COPY certificates/COMODORSAAddTrustCA.crt  /usrdata/apps/httpserver/certificates 
COPY certificates/ca/CloudCAChain.pem /usrdata/apps/httpserver/certificates/ca
COPY certificates/ca/CloudCA.pem /usrdata/apps/httpserver/certificates/ca
RUN  ln -s    /usrdata/apps/httpserver/certificates/ca/CloudCA.pem /usrdata/apps/httpserver/certificates/ca/4192adfa.0  &&  ln -s  /usrdata/apps/httpserver/certificates/ca/CloudCA.pem /usrdata/apps/httpserver/certificates/ca/319100d0.0










RUN cd /usrdata/archive

COPY tomcat-connectors-1.2.40-src.tar.gz /usrdata/archive
RUN tar -xvzf  /usrdata/archive/tomcat-connectors-1.2.40-src.tar.gz -C /usrdata/archive

RUN cd /usrdata/archive/tomcat-connectors-1.2.40-src/native &&   ./configure --with-apxs=/usrdata/apps/httpserver/bin/apxs --with-apr-config=/usrdata/apps/httpserver/bin/apr-1-config && make && make install




RUN cd /usrdata/archive/

COPY mod_evasive_1.10.1.tar.gz /usrdata/archive/

RUN tar -xzvf /usrdata/archive/mod_evasive_1.10.1.tar.gz -C /usrdata/archive/

RUN cd /usrdata/archive/mod_evasive/ && cp mod_evasive20.c mod_evasive24.c  && sed s/remote_ip/client_ip/g -i mod_evasive24.c && /usrdata/apps/httpserver/bin/apxs -cia mod_evasive24.c


RUN cd ..




RUN cd /usrdata/archive

COPY mod_qos-11.7.tar.gz  /usrdata/archive

RUN  tar -xzvf  /usrdata/archive/mod_qos-11.7.tar.gz  -C  /usrdata/archive
RUN cd /usrdata/archive/mod_qos-11.7/apache2/

RUN export C_INCLUDE_PATH=/usrdata/apps/syspacks/pcre/include &&  /usrdata/apps/httpserver/bin/apxs -i -c  /usrdata/archive/mod_qos-11.7/apache2/mod_qos.c





RUN mkdir -p /usrdata/apps/syspacks/python3.4.2
RUN  cd /usrdata/archive
COPY Python-3.4.2.tgz  /usrdata/archive

RUN tar -xzvf /usrdata/archive/Python-3.4.2.tgz  -C /usrdata/archive

RUN  cd /usrdata/archive/Python-3.4.2 && ./configure --prefix=/usrdata/apps/syspacks/python3.4.2 && make && make install






RUN cd /usrdata/archive
COPY libxml2-2.9.2.tar.gz  /usrdata/archive

RUN tar -xvzf /usrdata/archive/libxml2-2.9.2.tar.gz  -C /usrdata/archive


RUN cd /usrdata/archive/libxml2-2.9.2 && ./configure --prefix=/usrdata/apps/syspacks/libxml2/ --with-python=/usrdata/apps/syspacks/python3.4.2 --disable-static --with-history && make && make install








RUN cd /usrdata/archive

COPY modsecurity-2.8.0.tar.gz /usrdata/archive

RUN tar -xzvf /usrdata/archive/modsecurity-2.8.0.tar.gz -C /usrdata/archive


RUN cd /usrdata/archive/modsecurity-2.8.0/ && ./configure --prefix=/usrdata/apps/syspacks/mod-security/ --with-libxml=/usrdata/apps/syspacks/libxml2/ --with-apr=/usrdata/apps/httpserver/bin/apr-1-config --with-apu=/usrdata/apps/httpserver/bin/apu-1-config --with-apxs=/usrdata/apps/httpserver/bin/apxs --with-pcre=/usrdata/apps/syspacks/pcre/ --with-lua && make && make install




COPY master.zip /usrdata/archive
RUN cd /usrdata/archive
RUN  unzip /usrdata/archive/master.zip -d  /usrdata/archive/ && mkdir /usrdata/apps/httpserver/mod-security-rules/ &&  mv /usrdata/archive/owasp-modsecurity-crs-master /usrdata/apps/httpserver/mod-security-rules && cd /usrdata/apps/httpserver/mod-security-rules/owasp-modsecurity-crs-master  &&  mv /usrdata/apps/httpserver/mod-security-rules/owasp-modsecurity-crs-master/modsecurity_crs_10_setup.conf.example /usrdata/apps/httpserver/mod-security-rules/owasp-modsecurity-crs-master/modsecurity_crs_10_setup.conf


ADD default.apache /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh
ENTRYPOINT /docker-entrypoint.sh

