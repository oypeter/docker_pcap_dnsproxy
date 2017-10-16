FROM debian:jessie
WORKDIR /root
ENV TZ 'Asia/Shanghai'
#COPY sources.list /etc/apt/sources.list
RUN set -ex &&\
    apt-get update && \
    apt-get install -y git \
                       build-essential \
                       cmake \
                       libsodium-dev \
                       libpcap-dev \
                       libssl-dev \
                       flex \
                       bison \
                       libsodium13 \
                       libpcap0.8 && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo $TZ > /etc/timezone && \

    cd /tmp && \
        git clone --depth=1 https://github.com/chengr28/Pcap_DNSProxy.git /tmp/Pcap_DNSProxy && \
        cd /tmp/Pcap_DNSProxy/Source/Auxiliary/Scripts && \
        sh CMake_Build.sh && \
        mv /tmp/Pcap_DNSProxy/Source/Release /root/pcap_dnsproxy && \
        chmod +x /root/pcap_dnsproxy/Pcap_DNSProxy && \

    apt-get remove -y --purge \
                      --auto-remove cmake \
                                    build-essential \
                                    libsodium-dev \
                                    libpcap-dev \
                                    libssl-dev \
                                    flex \
                                    bison \
                                    git && \
    rm -rf /tmp/*
WORKDIR /root/pcap_dnsproxy
ENTRYPOINT ["/root/pcap_dnsproxy/Pcap_DNSProxy", "--disable-daemon"]

