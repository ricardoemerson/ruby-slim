FROM ruby:2.3.1-slim

MAINTAINER Ricardo Emerson <ricardo_emerson@yahoo.com.br>

# Update Linux libraries.
RUN apt-get update && apt-get -y upgrade

# Install base util libraries.
RUN apt-get update && apt-get install -y git-core zsh vim mc make gcc automake openssl

# Install Ruby dependencies.
RUN apt-get update && apt-get install -y curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev ca-certificates nodejs

# Install Rails app dependencies.
RUN apt-get update && apt-get install -y imagemagick qt5-default libqt5webkit5-dev libmysqlclient-dev && rm -rf /var/lib/apt/lists/*

# Create the dev-user.
RUN adduser ricardo && adduser ricardo sudo
# RUN echo "ricardo ALL=(ALL) ALL" >> /etc/sudoers
# RUN sed -i 's/1000/0/g' /etc/passwd

# Install Oh-My-ZSH complements on root user.
ENV SHELL=/bin/zsh
RUN git clone --depth 1 git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
RUN chsh -s /bin/zsh

# Include aliases to the zshrc.
RUN echo "alias ll='ls -laGh'" >> ~/.zshrc
RUN echo "alias cls='clear'" >> ~/.zshrc

# Copy package oh-my-zsh to the user ricardo.
RUN cp -R ~/.oh-my-zsh /home/ricardo
RUN cp ~/.zshrc /home/ricardo/.zshrc

# Change the onwner of files.
RUN chown -R ricardo:ricardo /home/ricardo/.oh-my-zsh
RUN chown -R ricardo:ricardo /home/ricardo/.zshrc
RUN chown -R ricardo:ricardo /usr/local/bundle/

RUN mkdir -p /project/web-app
RUN chown -R ricardo:ricardo /project

USER ricardo

# Install Oh-My-ZSH complements on ricardo user.
ENV SHELL=/bin/zsh

# Specify the work directory and volume.
WORKDIR /project/web-app

VOLUME /project/web-app

# install Rails.
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Update the RubyGems.
RUN gem update --system

ENV RAILS_VERSION '5.0.0.1'

RUN gem install rails -v "$RAILS_VERSION"

EXPOSE 3000

CMD /bin/zsh

# # # ENTRYPOINT ["zsh"]
