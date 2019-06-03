FROM centos:centos7

ENV LANG en_US.UTF-8
ENV RUBY_MAJOR 2.6
ENV RUBY_VERSION 2.6.3
ENV RUBYGEMS_VERSION 2.7.6
ENV BUNDLER_VERSION 1.17.1
ENV RUBY_DOWNLOAD_MIRROR https://cache.ruby-lang.org/pub/ruby
ENV RUBY_DOWNLOAD_SHA256 577fd3795f22b8d91c1d4e6733637b0394d4082db659fccf224c774a2b1c82fb
##
### yum initial settings
##
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 && \
    yum clean all && \
    yum update -y && \
    yum install -y autoconf gcc gcc-c++ make automake patch && \
    yum install -y openssl-devel libyaml-devel gdbm-devel ncurses-devel && \
    yum install -y epel-release yum-utils && \
    yum-config-manager --enable epel && \
    # tools
    yum install -y git && \
    yum install -y sudo crontabs which wget openssh curl tar gzip bzip2 unzip zip && \
    yum install -y nodejs && \
    curl -o /etc/yum.repos.d/yarn.repo https://dl.yarnpkg.com/rpm/yarn.repo && \
    yum install -y yarn && \
    # for rspec
    yum -y install GConf2 && \
    yum -y install http://mirror.centos.org/centos/7/os/x86_64/Packages/libXcomposite-0.4.4-4.1.el7.x86_64.rpm && \
    curl -s https://intoli.com/install-google-chrome.sh | bash && \
    yum -y install chromedriver && \
    yum -y install sqlite-devel && \
    yum -y install mysql-devel && \
    yum clean all
##
### ruby from src
##
RUN set -ex && \
    mkdir -p /usr/local/etc && \
    echo -e "install: --no-document\nupdate: --no-document" > /usr/local/etc/gemrc && \
    mkdir /build && cd /build && \
    curl -o ruby.tar.gz "$RUBY_DOWNLOAD_MIRROR/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" && \
    echo "$RUBY_DOWNLOAD_SHA256 ruby.tar.gz" | sha256sum -c - && \
    mkdir ruby && tar -xzf ruby.tar.gz -C ruby --strip-components=1 && \
    cd ruby && \
    ./configure --disable-install-doc --enable-shared && \
    make -j"$(nproc)" && \
    make install && \
    cd / && rm -rf /build
##
### gem and bundler
##
ENV GEM_HOME /bundle
ENV BUNDLE_PATH="$GEM_HOME" \
    BUNDLE_BIN="$GEM_HOME/bin" \
    BUNDLE_SILENCE_ROOT_WARNING=1 \
    BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN"
RUN gem update --system "$RUBYGEMS_VERSION" && \
		gem install bundler --version "$BUNDLER_VERSION" --force && \
    rm -r /root/.gem/
RUN chmod -R 777 "$GEM_HOME" "$BUNDLE_BIN"
##
### set directory and Gemfile
##
RUN mkdir /app-space
WORKDIR /app-space
ADD Gemfile /app-space/Gemfile
ADD Gemfile.lock /app-space/Gemfile.lock
RUN bundle update && bundle install
ADD . /app-space
