# encoding: utf-8

require 'spec_helper'

describe Adamantium::Freezer::Flat, '.call' do
  subject { object.call(value) }

  let(:object) { described_class }

  context 'with a numeric value' do
    let(:value) { 1 }

    it { should equal(value) }
  end

  context 'with a true value' do
    let(:value) { true }

    it { should equal(value) }
  end

  context 'with a false value' do
    let(:value) { false }

    it { should equal(value) }
  end

  context 'with a nil value' do
    let(:value) { nil }

    it { should equal(value) }
  end

  context 'with a symbol value' do
    let(:value) { :symbol }

    it { should equal(value) }
  end

  context 'with a frozen value' do
    let(:value) { String.new.freeze }

    it { should equal(value) }
  end

  context 'with an unfrozen value' do
    let(:value) { String.new }

    it { should_not equal(value) }

    it { should be_instance_of(String) }

    it { should eql(value) }

    it { should be_frozen }
  end

  context 'with a composed value' do
    let(:value) { [String.new] }

    it 'does NOT freeze inner values' do
      expect(subject.first).to_not be_frozen
    end
  end
end
