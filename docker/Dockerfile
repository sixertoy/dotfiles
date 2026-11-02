# Ubuntu 26.04 LTS — session user réaliste (pas root).
# git est préinstallé ; fnm/yarn restent hors image (via setup.sh).
FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y sudo curl ca-certificates nano libatomic1 unzip git \
  && rm -rf /var/lib/apt/lists/* \
  && echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu \
  && chmod 0440 /etc/sudoers.d/ubuntu

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER ubuntu
WORKDIR /home/ubuntu
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bash"]
