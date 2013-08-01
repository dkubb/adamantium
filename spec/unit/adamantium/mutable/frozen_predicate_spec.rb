# encoding: utf-8

require 'spec_helper'

describe Adamantium::Mutable, '#frozen?' do
  subject { object.frozen? }

  let(:object) { class_under_test.new }

  let(:class_under_test) do
    Class.new do
      include Adamantium::Mutable
    end
  end

  it { should be(true) }

  it_should_behave_like 'an idempotent method'
end
