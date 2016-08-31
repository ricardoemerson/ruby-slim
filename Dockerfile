# TAG VERSION 1.0
FROM ruby:2.3.1-slim

MAINTAINER Ricardo Emerson <ricardo_emerson@yahoo.com.br>

# Update Linux libraries.
RUN apt-get update && apt-get -y upgrade

# Install base util libraries.
RUN apt-get update && apt-get install -y --no-install-recommends git-core zsh vim mc openssl

# Remove temporary files.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TAG VERSION 1.1
# Install Ruby on Rails dependencies.
RUN apt-get update && apt-get install -y --no-install-recommends nodejs zlib1g-dev build-essential libxslt1-dev libcurl4-openssl-dev sqlite3 libsqlite3-dev libmysqlclient-dev libpq-dev python-software-properties

# Remove temporary files.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TAG VERSION 1.2
ENV DEBIAN_FRONTEND noninteractive

# Create the admin-user.
RUN adduser --disabled-password admin && adduser admin sudo

# Install Oh-My-ZSH complements on root user.
ENV SHELL=/bin/zsh
RUN git clone --depth 1 git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN chsh -s /bin/zsh

# Include aliases to the zshrc.
COPY .aliases /tmp
RUN cat /tmp/.aliases >> ~/.zshrc
RUN rm /tmp/.aliases

# Copy package oh-my-zsh to the user admin.
RUN cp -R ~/.oh-my-zsh /home/admin
RUN cp ~/.zshrc /home/admin/.zshrc

# Change the onwner of files.
RUN chown -R admin:admin /home/admin/.oh-my-zsh
RUN chown -R admin:admin /home/admin/.zshrc

RUN mkdir -p /project/web-app
RUN chown -R admin:admin /project

USER admin

# Sets the Oh-My-ZSH as default shell.
ENV SHELL=/bin/zsh

# Specify the work directory and volume.
WORKDIR /project/web-app

VOLUME /project/web-app

# TAG VERSION 1.3
# install Rails.
ENV RAILS_VERSION '5.0.0.1'

RUN gem install rails -v "$RAILS_VERSION"

# TAG VERSION 1.4
# Install the Pry and Awesome Print.
RUN gem install pry
RUN gem install pry-rails
RUN gem install awesome_print

COPY .irbrc /home/admin/.irbrc
COPY .pryrc /home/admin/.pryrc

EXPOSE 3000

CMD zsh
