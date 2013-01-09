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
      method_freezer = Freezer.parse(options) || freezer
      methods.each { |method| memoize_method(method, method_freezer) }
      self
    end

  private

    # Memoize the named method
    #
    # @param [#to_s] method_name
    #   a method name to memoize
    # @param [#call] freezer
    #   a freezer for memoized values
    #
    # @return [undefined]
    #
    # @api private
    def memoize_method(method_name, freezer)
      method = instance_method(method_name)
      unless method.arity.zero?
        raise ArgumentError, 'Cannot memoize method with nonzero arity'
      end
      visibility = method_visibility(method_name)
      define_memoize_method(method, freezer)
      send(visibility, method_name)
    end

    # Define a memoized method that delegates to the original method
    #
    # @param [UnboundMethod] method
    #   the method to memoize
    # @param [#call] freezer
    #   a freezer for memoized values
    #
    # @return [undefined]
    #
    # @api private
    def define_memoize_method(method, freezer)
      method_name = method.name
      undef_method(method_name)
      define_method(method_name) do |*args|
        memory.fetch(method_name) do
          value  = method.bind(self).call(*args)
          frozen = freezer.call(value)
          store_memory(method_name, frozen)
        end
      end
    end

    # Return the method visibility of a method
    #
    # @param [String, Symbol] method
    #   the name of the method
    #
    # @return [Symbol]
    #
    # @api private
    def method_visibility(method)
      if    private_method_defined?(method)   then :private
      elsif protected_method_defined?(method) then :protected
      else                                         :public
      end
    end

  end # module ModuleMethods
end # module Adamantium
