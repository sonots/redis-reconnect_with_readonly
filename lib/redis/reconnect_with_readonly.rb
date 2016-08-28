require 'redis/reconnect_with_readonly/version'
require 'redis'
require 'redis/client'
require 'redis/errors'

class Redis
  class ReconnectWithReadonly
    @reconnect_attempts  = 3
    @initial_retry_wait = 0.5
    @max_retry_wait  = nil
    @logger = nil

    class << self
      attr_accessor :reconnect_attempts, :initial_retry_wait, :max_retry_wait, :logger

      def reconnect_with_readonly(redis, &block)
        retries = 0
        begin
          yield block
        rescue CommandError => e
          if e.message =~ /READONLY/
            if retries < reconnect_attempts
              wait = initial_retry_wait * retries
              wait = [wait, max_retry_wait].min if max_retry_wait
              logger.info {
                "Reconnect with readonly: #{e.message} " \
                "(retries: #{retries}/#{reconnect_attempts}) (wait: #{wait}sec)"
              } if logger
              sleep wait
              retries += 1
              redis.disconnect
              logger.debug { "Reconnect with readonly: disconnected and retry" } if logger
              retry
            else
              logger.info {
                "Reconnect with readonly: Give up " \
                "(retries: #{retries}/#{reconnect_attempts})"
              } if logger
            end
          else
            raise
          end
        end
      end
    end
  end
end

class Redis
  class Client
    def call_with_reconnect_with_readonly(command, &block)
      ReconnectWithReadonly.reconnect_with_readonly(self) do
        call_without_reconnect_with_readonly(command, &block)
      end
    end

    def call_loop_with_reconnect_with_readonly(command, &block)
      ReconnectWithReadonly.reconnect_with_readonly(self) do
        call_loop_without_reconnect_with_readonly(command, &block)
      end
    end

    def call_pipeline_with_reconnect_with_readonly(command, &block)
      ReconnectWithReadonly.reconnect_with_readonly(self) do
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
