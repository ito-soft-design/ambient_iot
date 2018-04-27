# The MIT License (MIT)
#
# Copyright (c) 2018 ITO SOFT DESIGN Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'net/http'
require 'json'
require 'active_support'
require 'active_support/core_ext'

module AmbientIot
  class Client

    def initialize channel_id, options={}
      @channel_id = channel_id
      @write_key = options[:write_key]
      @read_key = options[:read_key]
      @user_key = options[:user_key]

      @post_data = []
      @append_timestamp = true
    end

    def << data
      data = [data] unless data.is_a? Array
      if append_timestamp?
        now = time_to_s Time.now
        data.each{|d| d["created"] = now}
      end
      @post_data += data
    end

    def append_timestamp?
      @append_timestamp
    end

    def append_timestamp= flag
      @append_timestamp = flag
    end

    def write
      post
    end
    alias :sync :write
    alias :synchronize :write

    def read options={}
      get options
    end

    def info
      get_property
    end
    alias :prop :info
    alias :property :info

    private

      def post
        raise "'write_key' is required." unless @write_key

        url = URI("http://ambidata.io/api/v2/channels/#{@channel_id}/dataarray")
        req = Net::HTTP::Post.new(url.path, 'Content-Type' => 'application/json')
        payload = {writeKey:@write_key, data:@post_data}
        req.body = payload.to_json
        res = Net::HTTP.new(url.host, url.port).start {|http|
          http.request(req)
        }
        case res
        when Net::HTTPSuccess#, Net::HTTPRedirection
          @post_data = []
        else
          res.value
        end
      end

      def get_with_url url
        req = Net::HTTP::Get.new(url)
        res = Net::HTTP.new(url.host, url.port).start {|http|
          http.request(req)
        }
        case res
        when Net::HTTPSuccess#, Net::HTTPRedirection
          obj_to_symbolize JSON.parse(res.body)
        else
          res.value
        end
      end

      def get options={}
        raise "'read_key' is required." unless @read_key

        url = URI("http://ambidata.io/api/v2/channels/#{@channel_id}/data")
        query = { readKey:@read_key }
        if options[:date]
          query[:date] = time_to_s options[:date]
        elsif options[:start] and options[:end]
          query[:start] = time_to_s options[:start]
          query[:end] = time_to_s options[:end]
        elsif options[:n]
          query[:n] = options[:n]
          query[:skip] = options[:skip] if options[:skip]
        end
        url.query = query.to_param
        get_with_url url
      end

      def get_property
        raise "'read_key' is required." unless @read_key

        url = URI("http://ambidata.io/api/v2/channels/#{@channel_id}")
        url.query = { readKey:@read_key }.to_param
        get_with_url url
      end

      def time_to_s time
        time.strftime("%Y-%m-%d %H:%M:%S.%L")
      end

      def date_to_s date
        date.strftime("%Y-%m-%d")
      end

      def obj_to_symbolize obj
        begin
          case obj
          when Hash
            obj = obj.deep_symbolize_keys!
            obj.each do |k, v|
              case v
              when String
                if /\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z/ =~ v
                  obj[k] = Time.parse(v).localtime
                end
              when Array, Hash
                obj[k] = obj_to_symbolize v
              end
            end
          when Array
            obj.map{|h|
              case h
              when Hash, Array
                h = obj_to_symbolize h
              end
              h
            }
          end
        rescue
          obj
        end
      end

  end
end
