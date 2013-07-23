# encoding: utf-8

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

  context 'inherited' do
    let(:mixin) { Adamantium::Flat }

    subject { Class.new(class_under_test).new }

    it 'should return memoized value' do
      subject.memoized
    end
  end

  context 'default' do
    let(:mixin) { Adamantium }

    subject { class_under_test.new }

    it 'should deep freeze instance and attributes' do
      should be_frozen
      expect(subject.attribute).to be_frozen
    end

    it 'should deep freeze memoized values' do
      expect(subject.memoized).to be_frozen
      expect(subject.memoized[0]).to be_frozen
    end
  end

  context 'flat' do
    let(:mixin) { Adamantium::Flat }

    subject { class_under_test.new }

    it 'should freeze only instance' do
      should be_frozen
      expect(subject.attribute).to_not be_frozen
    end

    it 'should flat freeze memoized values' do
      expect(subject.memoized).to be_frozen
      expect(subject.memoized[0]).to_not be_frozen
    end
  end
end
