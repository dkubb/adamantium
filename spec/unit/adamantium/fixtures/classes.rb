# encoding: utf-8

module AdamantiumSpecs
  class Object
    include Adamantium

    def argumented(foo)
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
