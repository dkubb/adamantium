# encoding: utf-8

require 'spec_helper'

describe Adamantium::ModuleMethods, '#original_instance_method' do
  subject { object.original_instance_method(name).source_location }

  let(:object) do
    Class.new do
      include Adamantium

      def foo; end

      const_set(:ORIGINAL, instance_method(:foo).source_location)

      memoize :foo
    end
  end

  context 'when the method was memoized' do
    let(:name) { :foo }

    it 'returns the original method' do
      should eql(object::ORIGINAL)
    end
  end

  context 'when the method was not memoized' do
    let(:name) { :bar }

    it 'raises an exception' do
      expect { subject }
        .to raise_error(ArgumentError, 'No method :bar was memoized')
    end
  end
end
