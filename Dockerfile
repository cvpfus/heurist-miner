FROM nvcr.io/nvidia/pytorch:24.01-py3

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /

RUN apt-get update && \
    apt-get install git jq wget bc curl -y

RUN apt-get install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3-venv -y

RUN git clone https://github.com/heurist-network/miner-release

WORKDIR /miner-release

COPY install_flashattention.sh /miner-release

RUN chmod +x install_flashattention.sh && ./install_flashattention.sh

RUN chmod +x llm-miner-starter.sh