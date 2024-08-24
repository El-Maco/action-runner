ARG BASE_IMAGE=ubuntu:20.04
FROM ${BASE_IMAGE}

ARG arch=x64

ARG REPO_URL
ARG RUNNER_TOKEN
ARG NAME

ENV REPO_URL ${REPO_URL}
ENV RUNNER_TOKEN ${RUNNER_TOKEN}
ENV NAME ${NAME}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    jq \
    git \
    libicu-dev \
    sudo \
    && apt-get clean

RUN useradd runner && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER runner
WORKDIR /home/runner
RUN curl -o actions-runner-linux.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-$arch-2.319.1.tar.gz \
    && tar xzf actions-runner-linux.tar.gz \
    && rm ./actions-runner-linux.tar.gz

RUN sudo bash ./bin/installdependencies.sh

RUN ./config.sh --url ${REPO_URL} --token ${RUNNER_TOKEN} --name ${NAME} --unattended --replace

COPY entrypoint.sh .

RUN sudo chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

