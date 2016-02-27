require "sinatra"
require "unicorn"
# require "sinatra/reloader"
require "redis"

class App < Sinatra::Base
  get "/json" do
    # parameters
    #  - date
    #  - station_code
  
    key = "#{params["date"]}-#{params["station_code"]}"
    result = get_data(key)
    if result == nil
      json = get_json(date: params["date"], code: params["station_code"])
      store_data(key, json)
      get_data(key)
    else
      get_data(key)
    end
  end
  
  get "/list" do
    # parameters
    #  - date
  
    key = "#{params["date"]}-list"
    result = get_data(key)
    if result == nil
      json = get_json(date: params["date"])
      store_data(key, json)
      get_data(key)
    else
      get_data(key)
    end
  end
  
  private
  
  def redis
    Redis.new host:ENV["REDIS_HOST"], port:"6379"
  end
  
  def get_json(args={})
    if args.size == 2
      url = "http://pm25.test.inokara.com/" + args[:date] + "/" + args[:date]+ "-" + args[:code] + "-PM2.5.json"
    elsif args.size == 1
      url = "http://pm25.test.inokara.com/" + args[:date] + "/list.json"
    end
  
    uri = URI.parse(url)
    result = Net::HTTP.get(uri)
    return result
  end
  
  def get_data(key)
    data = redis.get key
    return data
  end
  
  def store_data(key, record)
    redis.set key, record
  end
end
