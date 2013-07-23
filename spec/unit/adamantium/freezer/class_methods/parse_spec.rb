# encoding: utf-8

require 'spec_helper'

describe Adamantium::Freezer, '.parse' do
  subject { object.parse(options) }

  let(:object)  { described_class   }
  let(:freezer) { double('Freezer') }

  context 'with empty options' do
    let(:options) { {} }

    it { should be(nil) }
  end

  context 'with :freezer key' do
    let(:options) { { freezer: name } }
    let(:name)    { double('Name')    }

    it 'should get freezer' do
      described_class.should_receive(:get).with(name).and_return(freezer)
      should be(freezer)
    end
  end

  context 'with any other key' do
    let(:options) { { other: :key } }

    it 'should raise error' do
      expect { subject }.to raise_error(described_class::OptionError, 'Unknown option key(s) for memoizer [:other]')
    end
  end
end
