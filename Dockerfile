FROM alpine:latest

RUN apk --no-cache add wget libcap-dev build-base && \ 
        wget https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p12.tar.gz && \
        tar -xzf ntp-4.2.8p12.tar.gz && \
        cd ntp-4.2.8p12 && sed -e 's/"(\\S+)"/"?([^\\s"]+)"?/' -i scripts/update-leap/update-leap.in && \
             ./configure CFLAGS="-O2 -g -fPIC" \
            --prefix=/usr/ntp         \
            --bindir=/usr/ntp/sbin    \
            --sysconfdir=/etc     \
            --enable-linuxcaps    \
            --with-lineeditlibs=readline \
            --docdir=/usr/share/doc/ntp-4.2.8p12 && \
            make && make install && \
            install -v -o root -g root -d /var/lib/ntp  &&\
            apk del wget build-base && rm -rf /var/cache/apk/*   && cd / && rm -rf ntp-4.2.8p12*

COPY [ "ntp.conf", "/etc/ntp.conf" ]
COPY [ "entrypoint", "/entrypoint" ]

ENTRYPOINT [ "/entrypoint" ]
