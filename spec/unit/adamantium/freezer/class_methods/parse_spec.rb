require 'spec_helper'

describe Adamantium::Freezer, '.parse' do
  subject { object.parse(options, &block) }
  let(:object)  { described_class         }
  let(:block)   { lambda { :default }     }
  let(:freezer) { mock('Freezer')         }

  context 'with empty options' do
    let(:options) { {}                  }
    it            { should be(:default) }
  end

  context 'with :freezer key' do
    let(:options) { { :freezer => name } }
    let(:name)    { mock('Name')     }

    it 'should get freezer' do
      described_class.should_receive(:get).with(name).and_return(freezer)
      should be(freezer)
    end
  end
  
  context 'with any other key' do
    let(:options) { { :other => :key } }

    it 'should raise error' do
      expect { subject }.to raise_error(described_class::OptionError, 'Unknown option key(s) for memoizer [:other]')
    end
  end
end
