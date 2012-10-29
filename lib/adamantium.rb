require 'ice_nine'

# Allows objects to be made immutable
module Adamantium

  # Storage for memoized methods
  Memory = Class.new(::Hash)

  # Hook called when module is included
  #
  # @param [Module] descendant
  #   the module or class including Adamantium
  #
  # @return [self]
  #
  # @api private
  def self.included(descendant)
    super
    descendant.extend ModuleMethods if descendant.kind_of?(Module)
    descendant.extend ClassMethods  if descendant.kind_of?(Class)
    self
  end

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
  def self.freeze_object(object)
    case object
    when Numeric, TrueClass, FalseClass, NilClass, Symbol
      object
    else
      freeze_value(object)
    end
  end

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
    value.frozen? ? value : IceNine.deep_freeze(value.dup)
  end

  private_class_method :freeze_value

  # Freeze the object
  #
  # @example
  #   object.freeze  # object is now frozen
  #
  # @return [Object]
  #
  # @api public
  def freeze
    memory  # initialize memory
    super
  end

  # Get the memoized value for a method
  #
  # @example
  #   hash = object.memoized(:hash)
  #
  # @param [Symbol] name
  #   the method name
  #
  # @return [Object]
  #
  # @api public
  def memoized(name)
    memory[name]
  end

  # Sets a memoized value for a method
  #
  # @example
  #   object.memoize(:hash, 12345)
  #
  # @param [Symbol] name
  #   the method name
  # @param [Object] value
  #   the value to memoize
  #
  # @return [self]
  #
  # @api public
  def memoize(name, value)
    store_memory(name, value) unless memory.key?(name)
    self
  end

  # A noop #dup for immutable objects
  #
  # @example
  #   object.dup  # => self
  #
  # @return [self]
  #
  # @api public
  def dup
    self
  end

private

  # The memoized method results
  #
  # @return [Hash]
  #
  # @api private
  def memory
    @__memory ||= Memory.new
  end

  # Store the value in memory
  #
  # @param [Symbol] name
  #   the method name
  # @param [Object] value
  #   the value to memoize
  #
  # @return [self]
  #
  # @return [value]
  #
  # @api private
  def store_memory(name, value)
    memory[name] = Adamantium.freeze_object(value)
  end
end # module Adamantium

require 'adamantium/module_methods'
require 'adamantium/class_methods'
