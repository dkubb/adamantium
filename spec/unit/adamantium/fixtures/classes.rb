# encoding: utf-8

module AdamantiumSpecs
  class Object
    include Adamantium

    attr_reader :random_attribute

    def initialize
      @random_attribute = ::Object.new
    end

    def single_argument(foo)
    end

    def test
      'test'
    end

    def public_method
      caller
    end

  protected

    def protected_method
      caller
    end

  private

    def private_method
      caller
    end

  end # class Object
end # module AdamantiumSpecs
