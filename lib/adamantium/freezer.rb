# encoding: utf-8

module Adamantium

  # Abstract base class for freezers
  #
  # TODO: Use dkubb/abstract_class?
  #
  # Better pattern for singleton inheritance/shared code
  class Freezer

    # A list of types that should not be frozen
    NOT_FREEZABLE = [
      Class,
      Module,
    ].freeze

    # A list of types that should not be copied
    NOT_COPYABLE = [
      Numeric,
      TrueClass,
      FalseClass,
      NilClass,
      Symbol,
      Class,
      Module,
      UnboundMethod,
      Method,
    ].freeze

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
      when *NOT_FREEZABLE
        object
      else
        object.frozen? ? object : freeze(copy_object(object))
      end
    end

    private_class_method :call

    # Return a copy of an object if possible
    #
    # @param [Object] object
    #   an object to copy
    #
    # @return [Object]
    #   if it can be copied return a copy, otherwise return the object as-is
    #
    # @api private
    def self.copy_object(object)
      case object
      when *NOT_COPYABLE
        object
      else
        object.dup
      end
    end

    private_class_method :copy_object

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
    class UnknownFreezerError < RuntimeError; end

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
      when :noop then Noop
      when :deep then Deep
      when :flat then Flat
      else
        raise UnknownFreezerError, "Freezer with name #{name.inspect} is unknown"
      end
    end

    # Parse freezer options
    #
    # @param [Hash] options
    #   an options hash
    #
    # @return [#call]
    #   if freezer option was present
    #
    # @return [nil]
    #   otherwise
    #
    # @api private
    #
    def self.parse(options)
      keys = options.keys - [:freezer]
      unless keys.empty?
        raise OptionError, "Unknown option key(s) for memoizer #{keys.inspect}"
      end
      get(options.fetch(:freezer)) if options.key?(:freezer)
    end
  end
end
