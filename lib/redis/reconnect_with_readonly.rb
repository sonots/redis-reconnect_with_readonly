require 'redis/reconnect_with_readonly/version'
require 'redis'
require 'redis/client'
require 'redis/errors'

class Redis
  class ReconnectWithReadonly
    @reconnect_attempts = 1
    @max_retry_interval = 3600 # sec

    class << self
      attr_accessor :reconnect_attempts, :max_retry_interval
    end
  end
end

class Redis
  class ReadonlyConnectionError < ConnectionError; end

  class Client
    def reconnect_with_readonly(&block)
      retries = 0
      begin
        yield block
      rescue CommandError => e
        if e.message =~ /READONLY/
          if retries < (max_retries = ReconnectWithReadonly.reconnect_attempts)
            interval = [2**retries, ReconnectWithReadonly.max_retry_interval].min
            logger.info {
              "Reconnect with readonly: #{e.message} " \
              "(retries: #{retries}/#{max_retries}) (wait: #{interval}sec)"
            } if logger
            sleep interval
            retries += 1
            retry
          else
            logger.info {
              "Reconnect with readonly: Give up " \
              "(retries: #{retries}/#{max_retries})"
            } if logger
          end
        else
          raise
        end
      end
    end

    def call_with_reconnect_with_readonly(command, &block)
      reconnect_with_readonly do
        call_without_reconnect_with_readonly(command, &block)
      end
    end

    def call_loop_with_reconnect_with_readonly(command, &block)
      reconnect_with_readonly do
        call_loop_without_reconnect_with_readonly(command, &block)
      end
    end

    def call_pipeline_with_reconnect_with_readonly(command, &block)
      reconnect_with_readonly do
        call_pipeline_without_reconnect_with_readonly(command, &block)
      end
    end

    alias :call_without_reconnect_with_readonly :call
    alias :call :call_with_reconnect_with_readonly
    alias :call_loop_without_reconnect_with_readonly :call_loop
    alias :call_loop :call_loop_with_reconnect_with_readonly
    alias :call_pipeline_without_reconnect_with_readonly :call_pipeline
    alias :call_pipeline :call_pipeline_with_reconnect_with_readonly
  end
end
