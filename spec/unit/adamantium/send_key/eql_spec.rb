# encoding: utf-8

require 'spec_helper'

describe Adamantium::SendKey, '#hash' do
  let(:object)      { Adamantium::SendKey.new(method_name, args) }
  let(:method_name) { :some_method }
  let(:args)        { %w[a b] }

  it 'is eql to itself' do
    expect(object.eql?(object)).to be_true
  end

  it 'is not eql to another class' do
    expect(object.eql?(1)).to be_false
  end

  it 'is eql only to others with the same method name and arguments' do
    other = Adamantium::SendKey.new(:other_method, args)
    expect(object.eql?(other)).to be_false
    other = Adamantium::SendKey.new(method_name, [args[0], 'c'])
    expect(object.eql?(other)).to be_false
    other = Adamantium::SendKey.new(method_name, args)
    expect(object.eql?(other)).to be_true
  end
end
