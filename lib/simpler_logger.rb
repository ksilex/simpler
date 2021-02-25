require 'logger'
class SimplerLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    status, headers, body = @app.call(env)
    logger = Logger.new('log/app.log')
    if status == 404
      logger.error("\n#{log_error(@request, status, headers)}")
    else
      logger.info("\n#{log_info(@request, status, headers)}")
    end
    [status, headers, body]
  end

  private

  def log_info(request, status, headers)
    "Request: #{request.request_method} #{request.fullpath}\n" \
    "Handler: #{request.env['simpler.controller'].class}##{request.env['simpler.action']}\n" \
    "Parameters: #{request.env['simpler.params'].merge!(request.params)}\n" \
    "Response: #{status} #{headers['Content-Type']} #{request.env['simpler.template_path']}\n" \
  end

  def log_error(request, status, headers)
    "Request: #{request.request_method} #{request.fullpath}\n" \
    "Response: #{status} #{headers['Content-Type']}\n" \
  end
end
