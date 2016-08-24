require 'redis/reconnect_with_readonly/version'
require 'redis'
require 'redis/client'
require 'redis/errors'

class Redis
  class ReadonlyConnectionError < ConnectionError; end

  class Client
    def read_with_reconnect_with_readonly
      reply = read_without_reconnect_with_readonly
      if reply.is_a?(CommandError)
        logger.info { "Reconnect: #{reply.message}" } if logger
        raise Redis::ReadonlyConnectionError.new(reply.message)
      end
    end

    alias :read_without_reconnect_with_readonly :read
    alias :read :read_with_reconnect_with_readonly
  end
end
