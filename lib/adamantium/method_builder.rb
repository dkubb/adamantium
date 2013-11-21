# encoding: utf-8

module Adamantium

  # Build the memoized method using a freezer
  class MethodBuilder < Memoizable::MethodBuilder

    # Initialize an object to build a memoized method using a freezer
    #
    # @param [Module] descendant
    # @param [Symbol] method_name
    # @param [#call] freezer
    #
    # @return [undefined]
    #
    # @api private
    def initialize(descendant, method_name, freezer)
      super(descendant, method_name)
      @freezer = freezer
    end

  private

    # Create a new memoized method
    #
    # @return [undefined]
    #
    # @api private
    def create_memoized_method
      descendant_exec(@method_name, @original_method, @freezer) do |name, method, freezer|
        define_method(name) do ||
          memoized_method_cache.fetch(name) do
            freezer.call(method.bind(self).call)
          end
        end
      end
    end

  end # MethodBuilder
end # Adamantium
