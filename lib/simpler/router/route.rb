module Simpler
  class Router
    class Route

      attr_reader :controller, :action
      attr_accessor :params

      def initialize(method, path, controller, action)
        @method = method
        @path = path
        @controller = controller
        @action = action
        @params = {}
      end

      def match?(method, path)
        @method == method && path_handler(path)
      end

      def path_handler(path)
        router_path = @path.split('/')
        request = path.split('/')
        return if request.size != router_path.size

        router_path.each_with_index do |part, id|
          params[sym!(part)] = request[id] if part.include? ':'
        end
      end

      def sym!(part)
        part.delete(':').to_sym
      end
    end
  end
end
