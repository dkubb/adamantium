module Adamantium
  # Abstract base class for freezers
  #
  # TODO: Use dkubb/abstract_class?
  #
  # Better pattern for singleton inheritance/shared code
  #
  class Freezer

    private_class_method :new

    # Attempt to freeze an object
    #
    # @example using a value object
    #   Adamantium.freeze_object(12345)  # => noop
    #
    # @example using a normal object
    #   Adamantium.freeze_object({})  # => duplicate & freeze object
    #
    # @param [Object] object
    #   the object to freeze
    #
    # @return [Object]
    #   if supported, the frozen object, otherwise the object directly
    #
    # @api public
    def self.call(object)
      case object
      when Numeric, TrueClass, FalseClass, NilClass, Symbol
        object
      else
        freeze_value(object)
      end
    end
    private_class_method :call

    # Returns a frozen value
    #
    # @param [Object] value
    #   a value to freeze
    #
    # @return [Object]
    #   if frozen, the value directly, otherwise a frozen copy of the value
    #
    # @api private
    def self.freeze_value(value)
      value.frozen? ? value : freeze(value.dup)
    end
    private_class_method :freeze_value

    # Freezer that does not deep freeze
    class Flat < self
      # Freeze value
      #
      # @param [Object] value
      #
      # @return [undefined]
      #
      # @api private
      def self.freeze(value)
        value.freeze
      end
      public_class_method :call
    end

    # Freezer that does deep freeze
    class Deep < self
      # Deep freeze value
      #
      # @param [Object] value
      #
      # @return [undefined]
      #
      # @api private
      def self.freeze(value)
        IceNine.deep_freeze(value)
      end
      public_class_method :call
    end

    Noop = lambda { |object| object }.freeze

    # Error raised when freezer cannot be found
    class UnknownError < RuntimeError; end
    # Error raised when memoizer options contain unknown keys
    class OptionError < RuntimeError; end

    # Return freezer for name
    #
    # @param [Symbol] name
    #   a freezer name
    #
    # @return [#call]
    #
    # @api private
    def self.get(name)
      case name 
      when :noop
        Noop
      when :deep
        Deep
      when :flat
        Flat
      else
        raise UnknownError, "Freezer with name #{name.inspect} is unknown"
      end
    end

    # Parse freezer options
    #
    # @param [Hash] options
    #   an options hash
    #
    # @return [#call]
    #
    # @api private
    #
    def self.parse(options)
      keys = options.keys - [:freezer]

      unless keys.empty?
        raise OptionError, "Unknown option key(s) for memoizer #{keys.inspect}"
      end

      name = options.fetch(:freezer) do
        return yield
      end

      get(name)
    end
  end
end
