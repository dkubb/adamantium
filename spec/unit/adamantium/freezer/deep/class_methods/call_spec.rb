# encoding: utf-8

require 'spec_helper'

describe Adamantium::Freezer::Deep, '.call' do
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

  context 'with a method value' do
    let(:value) { Object.method(:to_s) }

    it { should equal(value) }

    it { should_not be_frozen }
  end

  context 'with a unbound method value' do
    let(:value) { Object.instance_method(:to_s) }

    it { should equal(value) }

    it { should_not be_frozen }
  end

  context 'with a module value' do
    let(:value) { Module.new }

    it { should equal(value) }

    it { should_not be_frozen }
  end

  context 'with a class value' do
    let(:value) { Class.new }

    it { should equal(value) }

    it { should_not be_frozen }
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

    it 'does freeze inner values' do
      expect(subject.first).to be_frozen
    end
  end
end
