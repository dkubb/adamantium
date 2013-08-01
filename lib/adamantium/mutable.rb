# encoding: utf-8

module Adamantium

  # Module fake frozen object
  #
  # This behavior sometimes is needed when a mutable
  # object needs to be referenced in an inmutable object tree.
  #
  # If you have to use `memoize :foo, freezer: :noop` to often you might
  # want to include this module into your class.
  #
  # Use wisely! A rule of thumb only a tiny fraction of your objects
  # typically deserves this.
  #
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
