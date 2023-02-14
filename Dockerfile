# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-pytorch
# FROM nvcr.io/nvidia/l4t-pytorch:r32.6.1-pth1.9-py3
FROM dustynv/ros:foxy-pytorch-l4t-r32.7.1

# ベース環境変数設定
ENV DEBIAN_FRONTEND=noninteractive
ENV LD_PRELOAD=/usr/lib/aarch64-linux-gnu/libgomp.so.1
# ENV LANG=en_US.UTF-8
ENV TZ=Asia/Tokyo


# ========== pytorch環境構築 ========== #
RUN sed -i.bak -e 's@archive.ubuntu.com@ftp.jaist.ac.jp/pub/Linux@g' /etc/apt/sources.list && \
    # GPGKeyエラーの回避
    apt-get -V install -y software-properties-common wget && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/nullsoftware-properties-common && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
    apt-get update -y && apt-get full-upgrade -y && \
    # ベースをインストール(opencv-pythonのバージョンは注意)
    apt-get install -y sudo tzdata ffmpeg libsm6 libxext6 v4l-utils graphviz xdg-utils git build-essential x11-apps python3-tk && \
    python3 -m pip install --upgrade pip setuptools wheel && \
    python3 -m pip install japanize-matplotlib matplotlib scipy seaborn tqdm fastapi Jetson.GPIO \
    aiofiles graphviz python-multipart autopep8 ipywidgets uvicorn websockets python-dotenv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# ========== pytorch環境構築 ========== #

# 一般ユーザに変更 & GPIOの設定
ENV USER_NAME=user
ENV USER_UID=1000
ARG uid=${UID}
ARG gid=${GID}
ARG gid_gpio=${GID_GPIO}

# RUN groupadd -f -r -g $gid_gpio gpio && \
# RUN groupadd -f -r -g ${USER_UID} ${USER_NAME} && \
RUN echo "root:root" | chpasswd \
    && useradd -m -u ${USER_UID} --groups sudo,video ${USER_NAME} \
    && echo "${USER_NAME}:${USER_NAME}" | chpasswd \
    && echo "%${USER_NAME}    ALL=(ALL)    NOPASSWD:    ALL" >> /etc/sudoers.d/${USER_NAME} \
    && echo 'Defaults exempt_group+=user' >> /etc/sudoers.d/${USER_NAME} \
    && chmod 0440 /etc/sudoers.d/${USER_NAME}

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/ros2_ws/src

CMD ["/bin/bash"]

# ========== docker runオプション ========== #
# xhost +
# docker run --privileged -it \ # privilegedは不要かも
# -e DISPLAY=$DISPLAY \ # X(X11)の宛先をホストと同一に
# -v /tmp/.X11-unix:/tmp/.X11-unix:rw \ # Xソケット(X11)を共有
# --device /dev/video0:/dev/video0:mwr \ # カメラ0(UVC)をマウント
# --device /dev/video1:/dev/video1:mwr \ # 複数指定も可能
# ========== docker runオプション ========== #
