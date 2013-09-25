# encoding: utf-8

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

    # Test if an instance method is memoized
    #
    # @example
    #   class Foo
    #     include Adamantium
    #
    #     def bar
    #     end
    #     memoize :bar
    #
    #   end
    #
    #   Foo.memoized?(:bar) # true
    #   Foo.memoized?(:baz) # false, does not care if method acutally exists
    #
    # @param [Symbol] name
    #
    # @return [true]
    #   if method is memoized
    #
    # @return [false]
    #   otherwise
    #
    # @api private
    #
    def memoized?(name)
      memoized_methods.key?(name)
    end

    # Return original instance method
    #
    # @example
    #
    #   class Foo
    #     include Adamantium
    #
    #     def bar
    #     end
    #     memoize :bar
    #
    #   end
    #
    #   Foo.original_instance_method(:bar) #=> UnboundMethod, where source_location still points to original!
    #
    # @param [Symbol] name
    #
    # @return [UnboundMethod]
    #   if method was memoized before
    #
    # @raise [ArgumentError]
    #   otherwise
    #
    # @api public
    #
    def original_instance_method(name)
      memoized_methods[name]
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
      memoized_methods[method_name] = method
      visibility = method_visibility(method_name)
      define_memoize_method(method, freezer)
      send(visibility, method_name)
    end

    # Return original method registry
    #
    # @return [Hash<Symbol, UnboundMethod>]
    #
    # @api private
    #
    def memoized_methods
      @memoized_methods ||= ThreadSafe::Hash.new do |_, name|
        raise ArgumentError, "No method #{name.inspect} was memoized"
      end
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
      method_name = method.name.to_sym
      undef_method(method_name)
      define_method(method_name) do |*args|
        send_key = SendKey.new(method_name, args)
        memory.fetch(send_key) do
          value  = method.bind(self).call(*args)
          frozen = freezer.call(value)
          store_memory(send_key, frozen)
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
