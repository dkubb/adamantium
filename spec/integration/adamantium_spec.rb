require 'spec_helper'

describe Adamantium do
  let(:class_under_test) do
    mixin = self.mixin

    Class.new do
      include mixin
      
      def initialize
        @attribute = Object.new
      end
      attr_reader :attribute

      def memoized
        [Object.new]
      end
      memoize :memoized
    end
  end

  context 'default' do
    let(:mixin) { described_class }

    subject { class_under_test.new }

    it 'should deep freeze instance and attributes' do
      should be_frozen
      subject.attribute.should be_frozen
    end

    it 'should deep freeze memoized values' do
      subject.memoized.should be_frozen
      subject.memoized[0].should be_frozen
    end
  end

  context 'flat' do
    let(:mixin) { described_class::Flat }

    subject { class_under_test.new }

    it 'should freeze only instance' do
      should be_frozen
      subject.attribute.should_not be_frozen
    end

    it 'should flat freeze memoized values' do
      subject.memoized.should be_frozen
      subject.memoized[0].should_not be_frozen
    end
  end
end
