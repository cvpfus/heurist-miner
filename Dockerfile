FROM nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04

WORKDIR /

RUN apt-get update && \
    apt-get install git -y

RUN git clone https://github.com/heurist-network/miner-release

WORKDIR /miner-release

RUN chmod +x llm-miner-starter.sh

CMD ["./llm-miner-starter.sh", "openhermes-2.5-mistral-7b-gptq"]