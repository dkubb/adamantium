# encoding: utf-8

require 'spec_helper'

describe Adamantium::Mutable, '#freeze' do
  subject { object.freeze }

  let(:object) { class_under_test.new }

  let(:class_under_test) do
    Class.new do
      include Adamantium::Mutable
    end
  end

  it_should_behave_like 'a command method'

  it 'keeps object mutable' do
    subject
    object.instance_variable_set(:@foo, :bar)
  end
end
