FROM jenkins:latest
MAINTAINER Kayla Altepeter <kayla.altepeter@merrillcorp.com>
USER root
RUN apt-get clean && apt-get -y update && DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y nginx openssh-server git-core openssh-client curl sudo
RUN apt-get install -y nano
RUN apt-get install -y patch bzip2 gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev
RUN apt-get install git

RUN echo 'root:root' | chpasswd
ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
  && touch /root/.Xauthority \
  && true

RUN echo "jenkins:jenkins" | chpasswd

RUN rm /etc/ssh/ssh_host_*
RUN dpkg-reconfigure openssh-server
RUN ssh-keygen -A

RUN useradd docker \
	  && passwd -d docker \
	  && mkdir /home/docker \
	  && chown docker:docker /home/docker \
	  && addgroup docker staff \
	  && addgroup docker sudo \
	  && true

RUN adduser --system git
RUN mkdir -p /home/git/.ssh && chmod 700 /home/git/.ssh \
	&& touch /home/git/.ssh/authorized_keys && chmod 600 /home/git/.ssh/authorized_keys

RUN mkdir /opt/git \
	&& cd /opt/git \
	&& mkdir test-automation.git \
	&& cd test-automation.git \
	&& git init --bare \
	&& chown -Rf docker:docker .

# drop back to the regular jenkins user - good practice
USER jenkins

# install RVM, Ruby, and Bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
	\curl -L https://get.rvm.io | /bin/bash -s stable && \
	/bin/bash -l -c "rvm requirements;" && \
	/bin/bash -l -c 'source /var/jenkins_home/.rvm/scripts/rvm' && \
	/bin/bash -l -c 'rvm install 2.2.4' && \
	/bin/bash -l -c 'rvm use --default 2.2.4' && \
	/bin/bash -l -c 'echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile' && \
	/bin/bash -l -c '. ~/.bash_profile' && \
	/bin/bash -l -c 'gem install bundler'

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

EXPOSE 22
EXPOSE 8080
CMD ["/bin/bash", "-c", "sh /run.sh"]