# encoding: utf-8

require 'spec_helper'

describe Adamantium::ModuleMethods, '#freezer' do
  let(:object) do
    Class.new do
      include Adamantium
    end
  end

  subject { object.freezer }

  it { should be(Adamantium::Freezer::Deep) }

  it_should_behave_like 'an idempotent method'
end
