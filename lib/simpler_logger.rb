require 'logger'
class SimplerLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    @request = Rack::Request.new(env)
    status, headers, body = @app.call(env)
    log = log_format(@request, status, headers)
    logger = Logger.new('log/app.log')
    logger.info("\n#{log}")
    [status, headers, body]
  end

  private

  def log_format(request, status, headers)
    "Request: #{request.request_method} #{request.fullpath}\n" \
    "Handler: #{request.env['simpler.controller'].class}##{request.env['simpler.action']}\n" \
    "Parameters: #{request.env['simpler.params'].merge!(request.params)}\n" \
    "Response: #{status} #{headers['Content-Type']} #{request.env['simpler.render_view']}\n" \
  end
end
