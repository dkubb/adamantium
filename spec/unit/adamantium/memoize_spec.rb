# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#memoize' do
  subject { object.memoize(method, value) }

  let(:described_class) { Class.new(AdamantiumSpecs::Object) }
  let(:object)          { described_class.new               }
  let(:method)          { :test                             }

  before do
    described_class.memoize(method)
  end

  context 'when the value is not memoized' do
    let(:value) { String.new }

    it 'sets the memoized value for the method to the value' do
      subject
      object.send(method).should be(value)
    end

    it 'doesn ot freeze memoized value' do
      subject
      object.send(method).should_not be_frozen
    end
  end

  context 'when the method is already memoized' do
    let(:value)    { stub }
    let(:original) { nil  }

    before do
      object.memoize(method, original)
    end

    it 'does not change the value' do
      expect { subject }.to_not change { object.send(method) }
    end
  end
end
