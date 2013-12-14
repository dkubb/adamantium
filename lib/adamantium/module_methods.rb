# encoding: utf-8

module Adamantium

  # Methods mixed in to adamantium modules
  module ModuleMethods

    # Return default deep freezer
    #
    # @return [Freezer::Deep]
    #
    # @api private
    def freezer
      Freezer::Deep
    end

    # Memoize a list of methods
    #
    # @example
    #   memoize :hash
    #
    # @param [Array<#to_s>] methods
    #   a list of methods to memoize
    #
    # @return [self]
    #
    # @api public
    def memoize(*methods)
      options        = methods.last.kind_of?(Hash) ? methods.pop : {}
      method_freezer = Freezer.parse(options) || freezer
      methods.each { |method| memoize_method(method, method_freezer) }
      self
    end

  private

    # Hook called when module is included
    #
    # @param [Module] descendant
    #   the module including ModuleMethods
    #
    # @return [self]
    #
    # @api private
    def included(descendant)
      super
      descendant.module_eval { include Adamantium }
    end

    # Memoize the named method
    #
    # @param [Symbol] method_name
    #   a method name to memoize
    # @param [#call] freezer
    #   a callable object to freeze the value
    #
    # @return [undefined]
    #
    # @api private
    def memoize_method(method_name, freezer)
      memoized_methods[method_name] = Memoizable::MethodBuilder
        .new(self, method_name, freezer).call
    end

  end # ModuleMethods
end # Adamantium
