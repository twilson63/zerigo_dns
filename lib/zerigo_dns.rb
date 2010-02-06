# Copyright 2009 Zerigo, Inc.  See MIT-LICENSE for license information.
# Visit http://www.zerigo.com/docs/managed-dns for updates and documentation.

require 'activeresource-ext'

module Zerigo
  module DNS
  
    class Base < ActiveResource::Base
      self.site='http://ns.zerigo.com/api/1.1/'
      self.user = 'test@example.com'
      self.password = 'ca01ffae311a7854ea366b05cd02bd50'
      self.timeout = 5 # timeout after 5 seconds
      
      
      # fix load() so that it no longer clobbers @prefix_options
      # also fix bug exposed by reload() where attributes is effectively parsed twice, causing the first line to raise an exception the 2nd time
      def load(attributes)
        raise ArgumentError, "expected an attributes Hash, got #{attributes.inspect}" unless attributes.is_a?(Hash)
        new_prefix_options, attributes = split_options(attributes)
        @prefix_options.merge!(new_prefix_options)
        attributes.each do |key, value|
          @attributes[key.to_s] =
            case value
              when Array
                if value.all?{|v2| v2.kind_of?(ActiveResource::Base)}
                  value.dup rescue value
                else
                  resource = find_or_create_resource_for_collection(key)
                  value.map { |attrs| attrs.is_a?(String) ? attrs.dup : resource.new(attrs) }
                end
              when Hash
                resource = find_or_create_resource_for(key)
                resource.new(value)
              else
                value.dup rescue value
            end
        end
        self
      end
      
    end

  
    class Zone < Base
      # Find by domain
      def self.find_by_domain(domain)
        zones = find(:all) 
        zone = nil
        zones.each do |z|
          if z.domain == domain
            zone = z
            break;
          end
        end
        zone
      end
      
      
      # Find or Create Zone
      def self.find_or_create(domain)
        zone = find_by_domain(domain)
        unless zone
          zone = create(:domain=> domain, :ns_type=>'pri_sec')
        end  
        zone
      end
      
    end
  
    class Host < Base
      
      # Find by host name
      def self.find_by_hostname(zone, hostname)
        hosts = find(:all, :params=> { :zone_id => zone }) 
        host = nil
        hosts.each do |h|
          if h.hostname == hostname
            host = h
            break;
          end
        end      
        host
      end
      
      # Update or Create Host for a zone
      def self.update_or_create(zone, hostname, type, ttl, data)
        host = find_by_hostname(zone, hostname)
        if host
          # update
          host.host_type  = type
          host.data       = data
          host.ttl        = ttl
          host.save
        else
          # creatae
          host = create(
            :zone_id    => zone, 
            :hostname   => hostname,
            :host_type  => type,
            :data       => data,
            :ttl        => ttl
          )
        end  
        host
      end
      
    end

  end
end
