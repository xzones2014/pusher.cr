require "json"
require "digest/md5"
require "openssl/hmac"
require "http/client"

module Pusher
  class Client
    property scheme : String, host : String, port : String, app_id : String, key : String, secret : String, encrypted : String

    def initialize(options : Hash)
      default_options = {
        :scheme    => "http",
        :host      => "api.pusherapp.com",
        :port      => "80",
        :app_id    => nil,
        :key       => nil,
        :secret    => nil,
        :encrypted => "false",
      }

      merged_options = default_options.merge(options)

      if options.has_key?(:cluster)
        merged_options[:host] = "api-#{options[:cluster]}.pusher.com"
      end

      if options.has_key?(:encrypted)
        if options[:encrypted] == "true"
          merged_options[:scheme] = "https"
          merged_options[:port] = "443"
        else
          merged_options[:scheme] = "http"
          merged_options[:port] = "80"
        end
      end

      @scheme = merged_options[:scheme].to_s
      @host = merged_options[:host].to_s
      @port = merged_options[:port].to_s
      @app_id = merged_options[:app_id].to_s
      @key = merged_options[:key].to_s
      @secret = merged_options[:secret].to_s
      @encrypted = merged_options[:encrypted].to_s
    end

    def trigger(channels, event_name : String, data)
      post("events", trigger_params_json(channels, event_name, data))
    end

    def trigger_params_json(channels, event_name : String, data)
      channels = channels.to_a
      raise "Too many channels (#{channels.size}), max 10" if channels.size > 10
      {"name": event_name, "channels": channels, "data": encode_data(data)}.to_json
    end

    def encode_data(data)
      return data if data.is_a? String
      data.to_json
    end

    def post(action, params)
      body = params
      body_md5 = Digest::MD5.hexdigest(body)
      auth_timestamp = Time.local.to_unix.to_s
      auth_version = "1.0"
      string_to_sign =
        "POST\n/apps/" + app_id +
          "/events\nauth_key=" + key +
          "&auth_timestamp=" + auth_timestamp +
          "&auth_version=" + auth_version +
          "&body_md5=" + body_md5
      auth_signature = OpenSSL::HMAC.hexdigest(:sha256, secret, string_to_sign)
      send_sync(generate_url(action, body_md5, auth_timestamp, auth_version, auth_signature), body)
    end

    def send_sync(url, body)
      begin
        client = HTTP::Client.new(host, 443, true)
        client.tls.verify_mode=OpenSSL::SSL::VerifyMode::NONE
        response = client.post(url, headers: HTTP::Headers{"User-agent" => "pusher", "Content-Type" => "application/json"}, body: body)
      rescue e
        raise e
      end
      body = response.body ? response.body.chomp : nil
      return handle_response(response.status_code.to_i, body)
    end

    def handle_response(status_code, body)
      case status_code
      when 200
        return body
      when 202
        return body
      when 400
        return "Bad request: #{body}"
      when 401
        return body
      when 404
        return "404 Not found (URL)"
      when 407
        return "Proxy Authentication Required"
      else
        return "Unknown error (status code #{status_code}): #{body}"
      end
    end

    def generate_url(action, body_md5, auth_timestamp, auth_version, auth_signature)
      url =
        scheme +
          "://" + host +
          "/apps" +
          "/" + app_id +
          "/" + action +
          "?auth_key=" + key +
          "&auth_timestamp=" + auth_timestamp +
          "&auth_version=" + auth_version +
          "&body_md5=" + body_md5 +
          "&auth_signature=" + auth_signature
      return url
    end
  end
end
