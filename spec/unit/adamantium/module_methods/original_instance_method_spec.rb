require 'spec_helper'

describe Adamantium::ModuleMethods, '#original_instance_method' do
  let(:object) do
    Class.new do
      include Adamantium

      def foo; end

      const_set(:ORIGINAL, instance_method(:foo))

      memoize :foo
    end
  end

  subject { object.original_instance_method(name) }

  context 'if method with name was memoized' do
    let(:name) { :foo }
    it 'returns the original method' do
      should eql(object::ORIGINAL)
    end
  end

  context 'if method with name was NOT memoized' do
    let(:name) { :bar }
    it 'returns the original method' do
      expect { subject }.to raise_error(ArgumentError, 'No method :bar was memoized')
    end
  end
end
