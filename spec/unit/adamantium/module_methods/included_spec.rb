# encoding: utf-8

require 'spec_helper'
require File.expand_path('../../fixtures/classes', __FILE__)

describe Adamantium::ModuleMethods, '#included' do
  subject { object.included(object) }

  let(:object) { AdamantiumSpecs::Object }

  before do
    Adamantium.should_receive(:infect).with(object).and_return(Adamantium)
  end

  it_should_behave_like 'a command method'
end
