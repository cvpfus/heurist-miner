FROM nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /

RUN apt-get update && \
    apt-get install git jq wget bc curl screen -y

RUN apt-get install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt install python3-venv -y

RUN git clone https://github.com/heurist-network/miner-release

WORKDIR /miner-release

RUN chmod +x llm-miner-starter.sh