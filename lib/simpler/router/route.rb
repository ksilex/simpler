module Simpler
  class Router
    class Route
      attr_reader :controller, :action, :params

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
          if part.include?(':') && request[id].to_i.positive?
            params[sym!(part)] = request[id].to_i
          elsif part != request[id]
            return
          end
        end
      end

      private

      def sym!(part)
        part.delete(':').to_sym
      end
    end
  end
end
