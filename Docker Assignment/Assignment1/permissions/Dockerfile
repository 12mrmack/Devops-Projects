FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y sudo bash && \
    rm -rf /var/lib/apt/lists/*

# Create group and users
RUN groupadd -g 2000 ninjas && \
    useradd -m -u 1001 -g ninjas -G sudo mohan && \
    useradd -m -u 1002 -g ninjas -G sudo uma && \
    useradd -m -u 1003 -g ninjas -G sudo shikha && \
    useradd -m -u 1004 -g ninjas -G sudo mayank && \
    mkdir -p \
        /Data/Ninjas/Mohan \
        /Data/Ninjas/Uma \
        /Data/Ninjas/Shikha \
        /Data/Ninjas/Mayank && \
    chown mohan:ninjas  /Data/Ninjas/Mohan && \
    chown uma:ninjas    /Data/Ninjas/Uma && \
    chown shikha:ninjas /Data/Ninjas/Shikha && \
    chown mayank:ninjas /Data/Ninjas/Mayank && \
    chmod 750 /Data/Ninjas/*

# Optional: Passwordless sudo
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

CMD ["/bin/bash"]
