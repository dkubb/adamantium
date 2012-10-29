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
      methods.each { |method| memoize_method(method) }
      self
    end

  private

    # Memoize the named method
    #
    # @param [#to_s] method
    #   a method to memoize
    #
    # @return [undefined]
    #
    # @api private
    def memoize_method(method)
      visibility = method_visibility(method)
      define_memoize_method(method)
      send(visibility, method)
    end

    # Define a memoized method that delegates to the original method
    #
    # @param [Symbol] method
    #   the name of the method
    #
    # @return [undefined]
    #
    # @api private
    def define_memoize_method(method)
      original = instance_method(method)
      undef_method(method)
      define_method(method) do |*args|
        if memory.key?(method)
          memoized(method)
        else
          store_memory(method, original.bind(self).call(*args))
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
