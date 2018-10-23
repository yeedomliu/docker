# 只有nginx的镜像（centos系统），其它镜像虽然小，装起软件和扩展很蛋疼...
FROM centos:centos7

MAINTAINER yeedomliu "36749952@qq.com"

# 初始化文件目录
RUN mkdir -p /data/logs /data/code/website

# 安装软件
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y update
RUN yum install -y nginx which supervisor wget telnet git vim make gcc-c++ pcre pcre-devel zlib libssl-dev zlib-devel net-tools psmisc kill mlocate

# 配置守护进程
RUN echo_supervisord_conf > /etc/supervisor.conf
ADD config/supervisor/nginx.ini /etc/supervisord.d
ADD config/supervisor/crontab.ini /etc/supervisord.d

# 常用命令
ADD config/bashrc /root/.bashrc

# 运行脚本
ADD shell/run.sh /run.sh
RUN chmod -R 755 /run.sh

EXPOSE 443 80

CMD ["/run.sh"]