# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#transform' do
  let(:object)          { described_class.new     }
  let(:described_class) { AdamantiumSpecs::Object }

  it 'returns a copy of the object' do
    transformed = object.transform {}
    expect(transformed).to_not be(object)
    expect(transformed).to eql(object)
  end

  it 'freezes the copy' do
    expect(object.transform {}).to be_frozen
  end

  it 'yields the copy to the block' do
    expect { |block| object.transform(&block) }
      .to yield_with_args(described_class)
  end

  it 'evaluates the block within the context of the copy' do
    copy = nil
    expect(object.transform { copy = self }).to be(copy)
  end

  it 'evaluates the block with an unfrozen copy' do
    frozen_in_block = nil
    expect { object.transform { frozen_in_block = frozen? } }
      .to change { frozen_in_block }.from(nil).to(false)
  end
end
