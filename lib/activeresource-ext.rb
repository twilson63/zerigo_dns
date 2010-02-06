require 'active_resource'

module ActiveResource
  module CaptureHeaders
    module InstanceMethods
      private
      def request_with_headers(method, path, *arguments)
        request_without_headers(method, path, *arguments).tap do |resp|
          @headers = resp.to_hash
        end
      end

    end

    def self.included(receiver)
      receiver.class_eval do
        include InstanceMethods
        alias_method_chain :request, :headers
        attr :headers
      end
    end
  end
  
  module RetrieveHeaders
    module InstanceMethods
      def last_count
        @last_count ||= (c = connection.headers['x-query-count']) ? c[0].to_i : nil
      end
      
    end
    
    def self.included(receiver)
      receiver.class_eval do
        include InstanceMethods
      end
    end
  end
  
end

ActiveResource::Connection.send :include, ActiveResource::CaptureHeaders
ActiveResource::Base.send :include, ActiveResource::RetrieveHeaders
