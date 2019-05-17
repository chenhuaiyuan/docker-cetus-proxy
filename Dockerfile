FROM centos:latest

MAINTAINER chy

RUN yum update -y && \
    yum install -y make cmake gcc git glib2-devel flex libevent-devel mysql-devel gperftools-libs net-tools && \
    cd / && \
    git clone https://github.com/Lede-Inc/cetus.git && \
    cd cetus && \
    mkdir build && \
    cd build && \
    cmake ../ -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=/cetus/build -DSIMPLE_PARSER=ON && \
    make install && \
    cp plugins/proxy/libproxy.so plugins/libproxy.so && \
    cp plugins/admin/libadmin.so plugins/libadmin.so && \
    yum clean all
    
EXPOSE 6001
EXPOSE 7001

WORKDIR /cetus/build

COPY ./conf/proxy.conf /cetus/build/conf
COPY ./conf/users.json /cetus/build/conf

RUN chown -R root /cetus/build/conf && chmod -R 660 /cetus/build/conf

ENTRYPOINT ["/cetus/build/bin/cetus", "--defaults-file=/cetus/build/conf/proxy.conf"]

#CMD ["/bin/bash"]
