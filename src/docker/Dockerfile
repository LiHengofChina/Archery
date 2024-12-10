ARG BASE_IMAGE="hhyo/archery-base:sha-d8159f4"
FROM ${BASE_IMAGE}
SHELL ["/bin/bash", "-c"]

# 复制依赖文件
COPY ./requirements.txt /opt/archery/
COPY ./src/docker/nginx.conf /opt/archery/src/docker/
COPY ./src/docker/supervisord.conf /opt/archery/src/docker/

# 创建插件目录
RUN mkdir -p /opt/archery/src/plugins/

# 替换 apt 源为清华镜像（仅替换 debian 官方源）
RUN sed -i 's|http://deb.debian.org/debian|https://mirrors.tuna.tsinghua.edu.cn/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://deb.debian.org/debian-security|https://mirrors.tuna.tsinghua.edu.cn/debian-security|g' /etc/apt/sources.list && \
    apt-get update -y

# 安装系统依赖、Nginx、Python 和清理缓存
RUN apt-get install -yq --no-install-recommends \
    nginx \
    dos2unix \
    && useradd nginx \
    && apt-get clean \
    && rm -rf /var/cache/apt/* /root/.cache

# 创建虚拟环境并激活，安装依赖
RUN python -m venv /opt/archery/venv4archery && \
    /opt/archery/venv4archery/bin/pip install --upgrade pip && \
    /opt/archery/venv4archery/bin/pip install -r /opt/archery/requirements.txt --index-url=https://pypi.tuna.tsinghua.edu.cn/simple && \
    /opt/archery/venv4archery/bin/pip install "redis>=4.1.0"

# 复制配置文件和插件
RUN cp -f /opt/archery/src/docker/nginx.conf /etc/nginx/ && \
    cp -f /opt/archery/src/docker/supervisord.conf /etc/ && \
    mv /opt/sqladvisor /opt/archery/src/plugins/ && \
    mv /opt/soar /opt/archery/src/plugins/ && \
    mv /opt/my2sql /opt/archery/src/plugins/

# 转换换行符格式
COPY . /opt/archery/
RUN dos2unix /opt/archery/src/docker/startup.sh

# 暴露端口
EXPOSE 9123

# 启动服务
ENTRYPOINT ["bash", "/opt/archery/src/docker/startup.sh"]
