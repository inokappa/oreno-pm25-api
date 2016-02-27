#
# Sinatra 起動
#
bundle exec unicorn -E production -c unicorn.rb -D
#
# Nginx 起動
#
rm -f /etc/nginx/sites-enabled/default
/usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
