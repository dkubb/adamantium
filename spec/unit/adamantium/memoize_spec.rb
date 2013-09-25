# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#memoize' do
  subject { object.memoize(method, [], value) }

  let(:described_class) { Class.new(AdamantiumSpecs::Object) }
  let(:object)          { described_class.new                }
  let(:method)          { :test                              }

  before do
    described_class.memoize(method)
  end

  context 'when the value is frozen' do
    let(:value) { String.new.freeze }

    it 'sets the memoized value for the method to the value' do
      subject
      expect(object.send(method)).to be(value)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.send(method)).to be_frozen
    end

    it_should_behave_like 'a command method'
  end

  context 'when the value is not frozen' do
    let(:value) { String.new }

    it 'sets the memoized value for the method to the value' do
      subject
      expect(object.send(method)).to eql(value)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.send(method)).to be_frozen
    end

    it_should_behave_like 'a command method'
  end

  context 'when the method is already memoized' do
    let(:value)    { double }
    let(:original) { nil    }

    before do
      object.memoize(method, [], original)
    end

    it 'does not change the value' do
      expect { subject }.to_not change { object.send(method) }
    end

    it_should_behave_like 'a command method'
  end
end
