module ActionDispatch
  module Routing
    class Mapper
      def mount_extensions
        Jellyfish::Extension.all.each do |ex|
          next unless ex.mount
          mount ex.mount[:engine], ex.mount[:options].dup
        end
      end
    end
  end
end
