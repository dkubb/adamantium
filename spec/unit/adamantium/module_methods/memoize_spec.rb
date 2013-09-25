# encoding: utf-8

require 'spec_helper'
require File.expand_path('../../fixtures/classes', __FILE__)

shared_examples_for 'memoizes method' do
  it 'memoizes the instance method' do
    subject
    instance = object.new
    expect(instance.send(*method_and_args)).to be(instance.send(*method_and_args))
  end

  it 'creates a method that returns a same value' do
    subject
    instance = object.new
    expect(instance.send(*method_and_args)).to be(instance.send(*method_and_args))
  end

  it 'creates a method with an arity of -1' do
    subject
    expect(object.new.method(method).arity).to eql(-1)
  end

  context 'when the initializer calls the memoized method' do
    before do
      method_and_args = self.method_and_args
      object.send(:define_method, :initialize) { send(*method_and_args) }
    end

    it 'allows the memoized method to be called within the initializer' do
      subject
      expect { object.new }.to_not raise_error
    end

    it 'memoizes the method inside the initializer' do
      subject
      expect(object.new.memoized(*method_and_args)).to_not be_nil
    end
  end
end

describe Adamantium::ModuleMethods, '#memoize' do
  subject { object.memoize(method, options) }

  let(:method_and_args) { [method] }
  let(:options) { {} }

  let(:object) do
    Class.new(AdamantiumSpecs::Object) do
      def some_state
        Object.new
      end
    end
  end

  context 'on a method with arguments' do
    let(:method) { :argumented }
    let(:method_and_args) { [method, 1, 2] }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'should return different values only for different arguments' do
      subject
      instance = object.new
      ret_1 = instance.send(method, 1, 2)
      ret_2 = instance.send(method, 'a', 'b')
      expect(ret_1).not_to eql(ret_2)
      expect(instance.send(method, 1, 2)).to eql(ret_1)
    end

    it 'should return the same value even after arguments passed in are mutated' do
      subject
      instance = object.new
      arg_1 = 'arg_1'
      arg_1_original = arg_1.dup
      ret_1 = instance.send(method, arg_1, 2)
      arg_1 << '!'
      expect(instance.send(method, arg_1_original, 2)).to eql(ret_1)
    end
  end

  context 'with :noop freezer option' do
    let(:method)  { :some_state        }
    let(:options) { { freezer: :noop } }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a public method' do
      should be_public_method_defined(method)
    end

    it 'creates a method that returns a non frozen value' do
      subject
      expect(object.new.send(method)).to_not be_frozen
    end
  end

  context 'memoized method that returns generated values' do
    let(:method) { :some_state }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end

  context 'public method' do
    let(:method) { :public_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a public method' do
      should be_public_method_defined(method)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end

  context 'protected method' do
    let(:method) { :protected_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a protected method' do
      should be_protected_method_defined(method)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end

  context 'private method' do
    let(:method) { :private_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a private method' do
      should be_private_method_defined(method)
    end

    it 'creates a method that returns a frozen value' do
      subject
      expect(object.new.send(method)).to be_frozen
    end
  end
end
