ARG BASE_IMAGE="hhyo/archery-base:sha-d8159f4"
FROM ${BASE_IMAGE}
SHELL ["/bin/bash", "-c"]
COPY . /opt/archery/




WORKDIR /opt/




# 替换 /etc/apt/sources.list 中的源为清华大学镜像源
RUN sed -i 's|http://deb.debian.org/debian|https://mirrors.tuna.tsinghua.edu.cn/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://deb.debian.org/debian-security|https://mirrors.tuna.tsinghua.edu.cn/debian-security|g' /etc/apt/sources.list

# 替换 /etc/apt/sources.list.d/ 目录中的源为清华大学镜像源
RUN find /etc/apt/sources.list.d/ -type f -exec sed -i 's|http://repo.percona.com|https://mirrors.tuna.tsinghua.edu.cn/percona|g' {} \; && \
    find /etc/apt/sources.list.d/ -type f -exec sed -i 's|https://packages.microsoft.com|https://mirrors.tuna.tsinghua.edu.cn/microsoft|g' {} \;




# 更新包列表
RUN apt-get update || true



RUN useradd nginx

# 安装 nginx 和
RUN apt-get install -yq --no-install-recommends nginx 
#mariadb-client 暂时不安装


# 激活 Python 虚拟环境
RUN source venv4archery/bin/activate


# 更新 pip 到最新版本
RUN python -m pip install --upgrade pip


# 安装 Python 依赖
RUN pip install -r /opt/archery/requirements.txt --index-url=https://pypi.tuna.tsinghua.edu.cn/simple


# 安装 Redis
RUN pip install "redis>=4.1.0"


# 复制 nginx 配置文件
RUN cp -f /opt/archery/src/docker/nginx.conf /etc/nginx/


# 复制 supervisord 配置文件
RUN cp -f /opt/archery/src/docker/supervisord.conf /etc/


# 移动插件到指定目录
RUN mv /opt/sqladvisor /opt/archery/src/plugins/
RUN mv /opt/soar /opt/archery/src/plugins/
RUN mv /opt/my2sql /opt/archery/src/plugins/


# 移除不需要的包
RUN apt-get -yq remove gcc curl


# 清理缓存
RUN apt-get clean
RUN rm -rf /var/cache/apt/* /root/.cache


RUN apt-get install -y dos2unix
# 转换换行符格式
RUN dos2unix /opt/archery/src/docker/startup.sh

#port
EXPOSE 9123

#start service
ENTRYPOINT ["bash", "/opt/archery/src/docker/startup.sh"]