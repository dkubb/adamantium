# encoding: utf-8

require 'spec_helper'

describe Adamantium::Freezer, '.get' do
  subject { object.get(name) }

  let(:object) { described_class }

  context 'with :deep' do
    let(:name) { :deep }

    it { should be(Adamantium::Freezer::Deep) }
  end

  context 'with :noop' do
    let(:name) { :noop }

    it { should be(Adamantium::Freezer::Noop) }
  end

  context 'with :flat' do
    let(:name) { :flat }

    it { should be(Adamantium::Freezer::Flat) }
  end

  context 'with unknown name' do
    let(:name) { :other }

    it 'should raise error' do
      expect { subject }.to raise_error(described_class::UnknownFreezerError, 'Freezer with name :other is unknown')
    end
  end
end
