module Adamantium

  # Methods mixed in to adamantium modules
  module ModuleMethods

    # Hook called when module is included
    #
    # @param [Module] mod
    #   the module including ModuleMethods
    #
    # @return [self]
    #
    # @api private
    def included(mod)
      Adamantium.included(mod)
      self
    end

    # Return default deep freezer
    #
    # @return [Freezer::Deep]
    #
    # @api private
    #
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
      method_freezer = Freezer.parse(options) { freezer }
      methods.each { |method| memoize_method(method, method_freezer) }
      self
    end

  private

    # Memoize the named method
    #
    # @param [#to_s] method
    #   a method to memoize
    # @param [#call] freezer
    #   a freezer for memoized values
    #
    # @return [undefined]
    #
    # @api private
    def memoize_method(method, freezer)
      visibility = method_visibility(method)
      define_memoize_method(method, freezer)
      send(visibility, method)
    end

    # Define a memoized method that delegates to the original method
    #
    # @param [Symbol] method
    #   the name of the method
    # @param [#call] freezer
    #   a freezer for memoized values
    #
    # @return [undefined]
    #
    # @api private
    def define_memoize_method(method, freezer)
      original = instance_method(method)
      undef_method(method)
      define_method(method) do |*args|
        memory.fetch(method) do
          value  = original.bind(self).call(*args)
          frozen = freezer.call(value)
          store_memory(method, frozen)
        end
      end
    end

    # Return the method visibility of a method
    #
    # @param [String, Symbol] method
    #   the name of the method
    #
    # @return [String]
    #
    # @api private
    def method_visibility(method)
      if    private_method_defined?(method)   then 'private'
      elsif protected_method_defined?(method) then 'protected'
      else                                         'public'
      end
    end

  end # module ModuleMethods
end # module Adamantium
