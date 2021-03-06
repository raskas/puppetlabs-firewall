require 'ipaddr'

# IPCidr object wrapper for IPAddr
module Puppet
  module Util
    class IPCidr < IPAddr

      def netmask
        _to_string(@mask_addr)
      end

      def prefixlen
        m = case @family
            when Socket::AF_INET
              IN4MASK
            when Socket::AF_INET6
              IN6MASK
            else
              raise "unsupported address family"
            end
        return $1.length if /\A(1*)(0*)\z/ =~ (@mask_addr & m).to_s(2)
        raise "bad addr_mask format"
      end

      def cidr
        cidr = sprintf("%s/%s", self.to_s, self.prefixlen)
        cidr = cidr.gsub(/\/32/, '')
        cidr
      end
    end
  end
end
