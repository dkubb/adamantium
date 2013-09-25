# encoding: utf-8

require 'ice_nine'
require 'thread_safe'

# Allows objects to be made immutable
module Adamantium

  # Storage for memoized methods
  Memory = Class.new(ThreadSafe::Hash)

  # Defaults to less strict defaults
  module Flat

    # Return flat freezer
    #
    # @return [Freezer::Flat]
    #
    # @api private
    #
    def freezer
      Freezer::Flat
    end

    # Hook called when module is included
    #
    # @param [Class,Module] descendant
    #
    # @return [undefined]
    #
    # @api private
    def self.included(descendant)
      super
      descendant.send(:include, Adamantium)
      descendant.extend(self)
    end
    private_class_method :included

  end # Flat

  # Hook called when module is included
  #
  # @param [Module] descendant
  #   the module or class including Adamantium
  #
  # @return [self]
  #
  # @api private
  def self.included(descendant)
    descendant.extend ModuleMethods
    descendant.extend ClassMethods  if descendant.kind_of?(Class)
    self
  end

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
  #   value = object.memoized(:method_name, 'a', 1)
  #
  # @param [Symbol] name
  #   the method name
  # @param [Array] args
  #   the method arguments
  #
  # @return [Object]
  #
  # @api public
  def memoized(name, *args)
    memory[SendKey.new(name, args)]
  end

  # Sets a memoized value for a method
  #
  # @example
  #   object.memoize(:hash, [], 12345)
  #
  # @param [Symbol] name
  #   the method name
  # @param [Array] args
  #   the method arguments
  # @param [Object] value
  #   the value to memoize
  #
  # @return [self]
  #
  # @api public
  def memoize(name, args, value)
    send_key = SendKey.new(name, args)
    unless memory.key?(send_key)
      store_memory(send_key, freeze_object(value))
    end
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

  # Freeze object
  #
  # @param [Object] object
  #   an object to be frozen
  #
  # @return [Object]
  #
  # @api private
  def freeze_object(object)
    freezer.call(object)
  end

  # Return class level freezer
  #
  # @return [#call]
  #
  # @api private
  def freezer
    self.class.freezer
  end

  # Store the value in memory
  #
  # @param [SendKey] send_key
  #   the key of the method send to memoize
  # @param [Object] value
  #   the value to memoize
  #
  # @return [self]
  #
  # @return [value]
  #
  # @api private
  def store_memory(send_key, value)
    memory[send_key] = value
  end

end # module Adamantium

require 'adamantium/module_methods'
require 'adamantium/class_methods'
require 'adamantium/freezer'
require 'adamantium/mutable'
require 'adamantium/send_key'
