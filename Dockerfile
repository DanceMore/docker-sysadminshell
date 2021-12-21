FROM debian:latest

RUN apt update -y && apt upgrade -y

RUN apt install -y curl git wget zsh

CMD ["/bin/zsh"]
