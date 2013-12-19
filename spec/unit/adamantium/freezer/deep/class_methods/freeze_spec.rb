# encoding: utf-8

require 'spec_helper'

describe Adamantium::Freezer::Deep, '.freeze' do
  subject { object.freeze(value) }

  let(:object) { described_class }
  let(:value)  { double('Value') }

  it 'should deep freeze value' do
    IceNine.should_receive(:deep_freeze!).with(value).and_return(value)
    should be(value)
  end
end
