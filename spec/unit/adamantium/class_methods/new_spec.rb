# encoding: utf-8

require 'spec_helper'
require File.expand_path('../../fixtures/classes', __FILE__)

describe Adamantium::ClassMethods, '#new' do
  subject { object.new }

  let(:object) { AdamantiumSpecs::Object }

  it { should be_instance_of(object) }

  it { should be_frozen }

  it 'does not freeze the object graph' do
    subject.random_attribute.should_not be_frozen
  end
end
