FROM ruby:2.3.0
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev && \
    apt-get install -y nginx && \
    mkdir -p /myapp/tmp/pids /myapp/logs
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD app.conf /etc/nginx/sites-available/app.conf
RUN ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf
ADD . /myapp
RUN chmod 755 run.sh
#
CMD ["sh", "run.sh"]
