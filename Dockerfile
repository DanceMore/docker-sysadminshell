FROM debian:latest

WORKDIR /tmp

# regular packages
RUN apt update -y && apt upgrade -y
RUN apt install -y curl git openssl screen python3-pip tmux wget zsh

# root ohmyzsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sed -i -e "s/robbyrussell/gentoo/" /root/.zshrc

# add non-root user
RUN adduser --shell=/bin/zsh --disabled-password --home=/home/user --gecos "" user

# user ohmyzsh
USER user
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN sed -i -e "s/robbyrussell/gentoo/" /home/user/.zshrc
USER root

# awscli
#RUN pip3 install awscli

# huber, the tool that lets me stop installing directly to /usr/local/bin !!
# https://github.com/innobead/huber/releases/tag/v0.3.11
RUN apt install -y libarchive13 libssl3
RUN curl -sfL -o /usr/local/bin/huber https://github.com/innobead/huber/releases/download/v0.3.11/huber-linux-amd64
RUN chmod +x /usr/local/bin/huber
RUN echo 'export PATH="$HOME/.huber/bin:$PATH"' >> /root/.zshrc

# install kubernetes stuff
RUN huber update
RUN huber install kubectl krew k9s

# kyml https://github.com/frigus02/kyml
RUN curl -sfL -o /usr/local/bin/kyml https://github.com/frigus02/kyml/releases/download/v20210610/kyml_20210610_linux_amd64
RUN chmod +x /usr/local/bin/kyml

# install krew into shell ..?
RUN echo 'export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"' >> /root/.zshrc
ENV PATH "${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# install krew plugins
RUN /root/.krew/bin/kubectl-krew install access-matrix
RUN /root/.krew/bin/kubectl-krew install deprecations
RUN /root/.krew/bin/kubectl-krew install doctor
RUN /root/.krew/bin/kubectl-krew install get-all
RUN /root/.krew/bin/kubectl-krew install pv-migrate
RUN /root/.krew/bin/kubectl-krew install who-can
RUN /root/.krew/bin/kubectl-krew install whoami

# cleanup
RUN rm -rf /tmp/*

WORKDIR /root
CMD ["/bin/zsh"]
