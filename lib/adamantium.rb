# encoding: utf-8

require 'ice_nine'
require 'memoizable'

# Allows objects to be made immutable
module Adamantium

  # Defaults to less strict defaults
  module Flat

    # Return flat freezer
    #
    # @return [Freezer::Flat]
    #
    # @api private
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
      descendant.instance_exec(self) do |mod|
        include Adamantium
        extend mod
      end
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
    super
    descendant.class_eval do
      include Memoizable
      extend ModuleMethods
      extend ClassMethods if kind_of?(Class)
    end
  end
  private_class_method :included

  # Alias to the original dup method
  #
  # @return [Object]
  #
  # @api private
  alias_method :__adamantium_dup__, :dup
  private :__adamantium_dup__

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

protected

  # Transform the object with the provided block
  #
  # @return [Object]
  #
  # @api public
  def transform(&block)
    copy = __adamantium_dup__
    copy.instance_eval(&block)
    self.class.freezer.freeze(copy)
  end

  # Transform the object with the provided block if the condition is false
  #
  # @param [Boolean] condition
  #
  # @return [Object]
  #
  # @api public
  def transform_unless(condition, &block)
    condition ? self : transform(&block)
  end

end # Adamantium

require 'adamantium/module_methods'
require 'adamantium/class_methods'
require 'adamantium/freezer'
require 'adamantium/mutable'
require 'adamantium/version'
