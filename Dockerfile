ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ARG arch=x64

ARG ENV_FILE

ENV DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386

RUN apt-get update
RUN apt-get install -y \
    curl \
    jq \
    git \
    libicu-dev \
    sudo \
    make \
    build-essential \
    gcc-multilib \
    libc6-dev-i386 \
    && apt-get clean

RUN useradd runner && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER runner
WORKDIR /home/runner
RUN curl -o actions-runner-linux.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-$arch-2.321.0.tar.gz \
    && tar xzf actions-runner-linux.tar.gz \
    && rm ./actions-runner-linux.tar.gz

RUN sudo bash ./bin/installdependencies.sh

COPY ${ENV_FILE} /tmp/envfile
RUN export $(grep -v "^#" /tmp/envfile | xargs) && \
    ./config.sh --url ${REPO_URL} --token ${RUNNER_TOKEN} --name ${NAME} --unattended --replace && \
    sudo rm -f /tmp/envfile

# Copy the id_rsa to the repo root
COPY .id_rsa /home/runner/.ssh/id_rsa
COPY .known_hosts /home/runner/.ssh/known_hosts
RUN sudo chown runner:runner .ssh/id_rsa && sudo chown runner:runner .ssh/known_hosts


RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
    ~/.cargo/bin/rustup target add i686-unknown-linux-gnu

COPY entrypoint.sh .

RUN sudo chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

