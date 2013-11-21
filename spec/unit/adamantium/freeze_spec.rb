# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#freeze' do
  subject { object.freeze }

  let(:described_class) { Class.new(AdamantiumSpecs::Object) }

  before do
    described_class.memoize(:test)
  end

  context 'with an unfrozen object' do
    let(:object) { described_class.allocate }

    it_should_behave_like 'a command method'

    it 'freezes the object' do
      expect { subject }.to change(object, :frozen?)
        .from(false)
        .to(true)
    end
  end

  context 'with a frozen object' do
    let(:object) { described_class.new }

    it_should_behave_like 'a command method'

    it 'does not change the frozen state of the object' do
      expect { subject }.to_not change(object, :frozen?)
    end
  end
end
