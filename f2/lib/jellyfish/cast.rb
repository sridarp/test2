module Jellyfish
  module Cast
    class FailedCastException < StandardError
    end

    class UnhandledCastException < StandardError
    end

    class Boolean
      private_class_method :new

      def initialize(value, type)
        @value = value
        @type = type
      end

      def self.from(value)
        new(value, nil).from
      end

      def from
        catch :cast do
          from_string
          from_fixnum
          from_nil
          from_boolean
          nil
        end
      end

      def from_string
        return unless @value.is_a? ::String
        throw :cast, true if @value =~ /\A(true|t|yes|y|on|1)\z/i
        throw :cast, false if @value.blank? || @value =~ /\A(false|f|no|n|off|0)\z/i
        throw :cast, nil
      end

      def from_fixnum
        return unless @value.is_a? ::Fixnum
        throw :cast, true if @value == 1
        throw :cast, false if @value == 0
      end

      def from_nil
        return unless @value.is_a? ::NilClass
        throw :cast, false
      end

      def from_boolean
        return unless @value.is_a?(::TrueClass) || @value.is_a?(::FalseClass)
        throw :cast, @value
      end
    end

    class String
      private_class_method :new

      def initialize(value, type)
        @value = value
        @type = type
      end

      def self.cast(value, type)
        new(value, type.nil? ? nil : type.to_sym).cast
      end

      def cast
        catch :cast do
          to_string
          to_integer
          to_boolean
          to_array
          to_date
          to_datetime
          raise UnhandledCastException, 'unknown cast type'
        end
      end

      private

      def to_string
        return unless [:string, :password, :text, :fingerprint, :certificate, :url, :email, nil].include? @type
        throw :cast, @value
      end

      def to_integer
        return unless :integer == @type
        throw :cast, @value.to_i if @value =~ /\A\d+\Z/
        cast_fail 'must be integer'
      end

      def to_boolean
        return unless :boolean == @type
        boolean = Jellyfish::Cast::Boolean.from(@value)
        throw :cast, boolean unless boolean.nil?
        cast_fail 'must be boolean'
      end

      def to_array
        return unless :array == @type
        cast_fail 'must be an array' unless @value =~ /\A\[.*\]\Z/
        begin
          throw :cast, YAML.load(@value.gsub(/(\,)(\S)/, '\\1 \\2'))
        rescue => e
          cast_fail e.to_s
        end
      end

      def to_date
        return unless :date == @type
        begin
          throw :cast, @value.to_date
        rescue => e
          cast_fail e.to_s
        end
      end

      def to_datetime
        return unless :datetime == @type
        begin
          throw :cast, @value.to_datetime
        rescue => e
          cast_fail e.to_s
        end
      end

      def cast_fail(msg)
        raise FailedCastException, msg
      end
    end
  end
end
