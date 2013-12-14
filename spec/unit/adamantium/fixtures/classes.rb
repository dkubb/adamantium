# encoding: utf-8

module AdamantiumSpecs
  class Object
    include Adamantium

    public :transform, :transform_unless

    def argumented(foo)
    end

    def test
      'test'
    end

    def public_method
      caller
    end

    def eql?(other)
      kind_of?(other.class)
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
