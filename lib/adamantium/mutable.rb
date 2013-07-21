module Adamantium
  module Mutable

    # Noop freezer
    #
    # @example
    #   class DoesNotGetFrozen
    #     include Adamantium::Mutable
    #   end
    #
    #   instance = DoesNotGetFrozen
    #   instance.freeze # => instance
    #
    # @return [self]
    #
    # @api public
    #
    def freeze
      self
    end

    # Test if object is frozen
    #
    # @example
    #   class DoesNotGetFrozen
    #     include Adamantium::Mutable
    #   end
    #
    #   instance = DoesNotGetFrozen
    #   instance.frozen? # => true
    #
    # @return [true]
    #
    # @api public
    #
    def frozen?
      true
    end

  end # Mutable
end # Adamantium
