# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#transform_unless' do
  let(:object)          { described_class.new     }
  let(:described_class) { AdamantiumSpecs::Object }

  context 'when the condition is true' do
    let(:condition) { true }

    it 'does not evaluate the block' do
      expect { |block| object.transform_unless(condition, &block) }
        .not_to yield_control
    end

    it 'returns the object' do
      expect(object.transform_unless(condition) {}).to be(object)
    end
  end

  context 'when the condition is false' do
    let(:condition) { false }

    it 'evaluates the block' do
      expect { |block| object.transform_unless(condition, &block) }
        .to yield_control
    end

    it 'returns a copy of the object' do
      transformed = object.transform_unless(condition) {}
      expect(transformed).to_not be(object)
      expect(transformed).to eql(object)
    end
  end
end
