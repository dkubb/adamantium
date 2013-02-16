# encoding: utf-8

require 'spec_helper'

describe Adamantium::ClassMethods, '#freezer' do
  let(:object) do
    Class.new do
      include Adamantium::Flat
    end
  end

  subject { object.freezer }

  it { should be(Adamantium::Freezer::Flat) }

  it_should_behave_like 'an idempotent method'
end
