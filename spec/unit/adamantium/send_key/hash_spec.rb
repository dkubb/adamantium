# encoding: utf-8

require 'spec_helper'

describe Adamantium::SendKey, '#hash' do
  subject { object.hash }

  let(:object)      { Adamantium::SendKey.new(method_name, args) }
  let(:method_name) { :some_method }
  let(:args)        { %w[a b] }

  it 'computes a hash value' do
    expect(subject).to be_a(Fixnum)
  end

  it 'computes the same hash value only for the the same method name and arguments' do
    hash_value = object.hash
    other = Adamantium::SendKey.new(:other_method, args)
    expect(other.hash).not_to eql(hash_value)
    other = Adamantium::SendKey.new(method_name, [args[0], 'arg_3'])
    expect(other.hash).not_to eql(hash_value)
    other = Adamantium::SendKey.new(method_name, args)
    expect(other.hash).to eql(hash_value)
  end

  it 'doesnt change its hash value if args are mutated' do
    hash_value = object.hash
    args[1] << '!'
    expect(object.hash).to eql(hash_value)
  end
end
