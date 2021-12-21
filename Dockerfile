FROM debian:latest

WORKDIR /tmp

# add non-root user
RUN adduser --disabled-password --home=/home/user --gecos "" user

# regular packages
RUN apt update -y && apt upgrade -y
RUN apt install -y curl git openssl screen python3-pip tmux wget zsh

# awscli
RUN pip3 install awscli

# kyml https://github.com/frigus02/kyml
RUN curl -sfL -o /usr/local/bin/kyml https://github.com/frigus02/kyml/releases/download/v20210610/kyml_20210610_linux_amd64
RUN chmod +x /usr/local/bin/kyml

# kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# install krew
ADD install-krew.sh /tmp
RUN chmod +x install-krew.sh
RUN ./install-krew.sh

# install krew plugins
RUN kubectl krew install access-matrix
RUN kubectl krew install deprecations
RUN kubectl krew install doctor
RUN kubectl krew install get-all
RUN kubectl krew install pv-migrate
RUN kubectl krew install who-can
RUN kubectl krew install whoami

# cleanup
RUN rm -rf /tmp/*

WORKDIR /root
CMD ["/bin/zsh"]
