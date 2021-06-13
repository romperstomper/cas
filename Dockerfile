FROM openshift/base-centos7
ENV PGDATA /tmp/pgdata
ENV HOME /tmp
ENV PATH=" /usr/local/rvm/rubies/ruby-2.6.3/bin:/usr/local/rvm/bin:/usr/local/rvm/rubies/ruby-2.6.3/bin:/usr/pgsql-9.3/bin:/usr/local/rvm/bin:${PATH}"
RUN yum install -y deltarpm
RUN curl -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum update -y && yum install -y nodejs
RUN curl --silent --location https://dl.yarnpkg.com/rpm/yarn.repo > /etc/yum.repos.d/yarn.repo
RUN rpm --import https://dl.yarnpkg.com/rpm/pubkey.gpg && yum install -y yarn

RUN yum install -y which

ADD pgdg-93.repo /etc/yum.repos.d/
RUN yum install -y postgresql93-server && \
    yum install -y postgresql93 

RUN gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN rvm install 2.6.3
RUN rvm use 2.6.3

RUN gem install --no-document pg -v '1.2.3'
RUN gem install --no-document rails
RUN chown -R postgres /usr/pgsql-9.3 && \
    mkdir /tmp/pgdata \
    chown -R postgres /tmp/pgdata 
WORKDIR /tmp
USER postgres
RUN pg_ctl initdb
RUN echo "listen_address='*'" >> /tmp/pgdata/postgres.conf
CMD ["sleep", "infinity"]
