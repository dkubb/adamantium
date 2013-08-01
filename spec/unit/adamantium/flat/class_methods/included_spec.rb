# encoding: utf-8

require 'spec_helper'

describe Adamantium::Flat, '.included' do
  subject do
    Class.new do
      include Adamantium::Flat
    end
  end

  its(:ancestors) { should include(Adamantium) }

  it 'extends class with Adamantium::Flat' do
    expect(subject.singleton_class.included_modules).to include(described_class)
  end
end
