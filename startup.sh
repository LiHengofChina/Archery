#!/bin/bash


mkdir -p mkdir /opt/logs
mkdir -p mkdir /opt/archery/logs



# 收集所有的静态文件到STATIC_ROOT
source /opt/venv4archery/bin/activate
cd /opt/archery
python3 manage.py collectstatic --verbosity 2 --noinput


# 使用 supervisord 来运行 gunicorn
supervisord -c /opt/archery/supervisord.conf

# 查看 supervisord的状态
supervisorctl status


