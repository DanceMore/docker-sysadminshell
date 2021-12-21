FROM debian:latest

RUN apt update -y && apt upgrade -y

RUN apt install -y curl git wget zsh

WORKDIR /tmp

# awscli
RUN apt install -y python3-pip
RUN pip3 install awscli

# kyml https://github.com/frigus02/kyml
RUN curl -sfL -o /usr/local/bin/kyml https://github.com/frigus02/kyml/releases/download/v20210610/kyml_20210610_linux_amd64
RUN chmod +x /usr/local/bin/kyml

# kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# cleanup
RUN rm -rf /tmp/*

# add non-root user
RUN adduser --disabled-password --home=/home/user --gecos "" user

CMD ["/bin/zsh"]
