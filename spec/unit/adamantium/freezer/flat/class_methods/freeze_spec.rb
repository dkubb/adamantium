# encoding: utf-8

require 'spec_helper'

describe Adamantium::Freezer::Flat, '.freeze' do
  subject { object.freeze(value) }

  let(:object) { described_class }

  let(:value) { double('Value') }

  it 'should freeze value' do
    value.should_receive(:freeze).and_return(value)
    should be(value)
  end
end
