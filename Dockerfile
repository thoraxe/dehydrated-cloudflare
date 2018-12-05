FROM registry.centos.org/centos:7
MAINTAINER Erik M Jacobs <erikmjacobs@gmail.com>

# https://b3n.org/intranet-ssl-certificates-using-lets-encrypt-dns-01/

# configs go in this folder
VOLUME /usr/local/etc/dehydrated

RUN useradd -u 10101 dehydrated && \
    chown dehydrated:dehydrated /usr/local/etc/dehydrated && \
    yum -y install epel-release && \
    yum -y install openssl git python-pip gcc python-devel libffi-devel openssl-devel && \
    mkdir /etc/dehydrated && \
    cd /etc/dehydrated && \
    mkdir certs accounts && \
    cd /opt && \
    git clone https://github.com/lukas2511/dehydrated.git -b v0.6.2 && \
    cd dehydrated && \
    ln -s /opt/dehydrated/dehydrated /usr/local/bin/ && \
    cd /opt && \
    git clone https://github.com/kappataumu/letsencrypt-cloudflare-hook && \
    pip install -r letsencrypt-cloudflare-hook/requirements-python-2.txt && \
    yum -y remove python-devel gcc openssl-devel keyutils-libs-devel krb5-devel \
      libcom_err-devel libselinux-devel libsepol-devel libverto-devel pcre-devel \
      zlib-devel && \
    yum clean all && rm -rf /var/cache/yum

# libffi-devel isn't removed because of a bug in the RPM itself causing removal to fail
USER 10101
