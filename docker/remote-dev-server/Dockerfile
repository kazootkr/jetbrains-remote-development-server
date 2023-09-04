FROM php:8.2.10-cli-bookworm

RUN pecl install xdebug-3.2.1 && \
    docker-php-ext-enable xdebug

COPY --from=composer /usr/bin/composer /usr/bin/composer

ENV xdebug.mode=debug xdebug.start_with_request=yes xdebug.client_host=host.docker.internal

# openssh
RUN apt-get update && apt-get install -y openssh-server && \
    sed -i 's/#\(PermitRootLogin .*\)/\1/' /etc/ssh/sshd_config && \
    mkdir -p /run/sshd

# Setup for remote developmemt ==========
RUN apt-get update && apt-get install -y git curl unzip procps time
ARG USERNAME=root
# ARG GROUPNAME=intellij
# ARG UID=1000
# ARG GID=1000
ARG MaximumHeapSize=4096m
ARG IDEURL=https://download.jetbrains.com/webide/PhpStorm-2023.2.2.tar.gz

ENV PROJDIR=${PROJDIR:-project}

#Create non-root user
# RUN groupadd -g $GID $GROUPNAME && \
#    useradd -m -s /bin/bash -u $UID -g $GID $USERNAME
# USER $USERNAME

WORKDIR /$USERNAME

RUN curl -L -fsSL -o ide.tar.gz $IDEURL && \
    mkdir ide && \
    tar xfz ide.tar.gz --strip-components=1 -C ide && \
    sed -e "s/-Xmx.*/-Xmx${MaximumHeapSize}/" -i ide/bin/phpstorm64.vmoptions && \
    rm ide.tar.gz

ENV REMOTE_DEV_TRUST_PROJECTS=/root/projects

# ssh setting
COPY ssh-key/remote_server_ed25519.pub .ssh/authorized_keys

## ========== Setup for remote developmemt

## supervisord ==========

COPY supervisord.conf /etc/supervisord.conf

RUN apt-get install -y supervisor

## ========== supervisord


VOLUME ["/root/.config"]
VOLUME ["/root/.cache"]
VOLUME ["/root/projects"]

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
CMD /usr/bin/supervisord -c /etc/supervisord.conf --pidfile /root/supervisord.pid
