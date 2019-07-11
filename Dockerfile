FROM ubuntu:18.04
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server rabbit language-pack-ja fonts-noto-cjk sudo && apt-get clean && rm -rf /var/lib/apt/lists/*
ENV LANG "ja_JP.UTF-8"
RUN mkdir /var/run/sshd
RUN echo 'root:rabbit' | chpasswd
RUN sed -i 's/^[ #]*PermitRootLogin.*$/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo AddressFamily inet >> /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN useradd -m -s /bin/bash rabbit && echo 'rabbit:rabbit' | chpasswd
RUN echo "rabbit ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
