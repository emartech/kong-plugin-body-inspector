FROM kong:0.12.1

RUN yum install -y gcc git unzip

ENV PATH=$PATH:/usr/local/bin:/usr/local/openresty/bin:/opt/stap/bin:/usr/local/stapxx:/usr/local/openresty/nginx/sbin

RUN git clone https://github.com/Kong/kong
RUN cd kong && git checkout 0.12.1
RUN cd kong && make dev

EXPOSE 8000 8001 8443 8444

CMD /kong/bin/kong start --v