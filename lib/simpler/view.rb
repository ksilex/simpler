require 'erb'
require 'json'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env, response)
      @env = env
      @response = response
    end

    def render(binding)
      return send template.keys.first, template.values.first if template&.keys

      template = File.read(template_path)
      ERB.new(template).result(binding)
    end

    private

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = [controller.name, action].join('/')
      @env['simpler.template_path'] = "#{path}.html.erb"
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    def plain(content)
      @response.headers['Content-Type'] = 'text/plain'
      content
    end

    def json(content)
      @response.headers['Content-Type'] = 'json'
      content.to_json
    end

  end
end
