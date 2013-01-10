# encoding: utf-8

require 'spec_helper'
require File.expand_path('../../fixtures/classes', __FILE__)

shared_examples_for 'memoizes method' do
  it 'memoizes the instance method' do
    subject
    instance = object.new
    instance.send(method).should equal(instance.send(method))
  end

  it 'creates a method that returns a same value' do
    subject
    instance = object.new
    first =  instance.send(method)
    second = instance.send(method)
    first.should be(second)
  end

  specification = proc do
    subject
    if method != :some_state
      file, line = object.new.send(method).first.split(':')[0, 2]
      File.expand_path(file).should eql(File.expand_path('../../../../../lib/adamantium/module_methods.rb', __FILE__))
      line.to_i.should eql(84)
    end
  end

  it 'sets the file and line number properly' do
    # Exclude example for methot that does not return caller
    if method == :some_method
      return
    end

    if RUBY_PLATFORM.include?('java')
      pending('Kernel#caller returns the incorrect line number in JRuby', &specification)
    else
      instance_eval(&specification)
    end
  end

  context 'when the initializer calls the memoized method' do
    before do
      method = self.method
      object.send(:define_method, :initialize) { send(method) }
    end

    it 'allows the memoized method to be called within the initializer' do
      subject
      expect { object.new }.to_not raise_error(NoMethodError)
    end

    it 'memoizes the methdod inside the initializer' do
      subject
      object.new.memoized(method).should_not be_nil
    end
  end
end

describe Adamantium::ModuleMethods, '#memoize' do
  subject { object.memoize(method, options) }
  let(:options) { {} }

  let(:object) do
    Class.new(AdamantiumSpecs::Object) do
      def some_state
        Object.new
      end
    end
  end
  
  context 'on method with arguments' do
    let(:method) { :argumented }

    it 'should raise error' do
      expect { subject }.to raise_error(ArgumentError, 'Cannot memoize method with nonzero arity')
    end
  end

  context 'with :noop freezer option' do
    let(:method)  { :some_state       }
    let(:options) { { :freezer => :noop } }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a public method' do
      should be_public_method_defined(method)
    end

    it 'creates a method that returns a non frozen value' do
      subject
      object.new.send(method).should_not be_frozen
    end
  end

  context 'memoized method that returns generated values' do
    let(:method) { :some_state }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'creates a method that returns a frozen value' do
      subject
      object.new.send(method).should be_frozen
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
      object.new.send(method).should be_frozen
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
      object.new.send(method).should be_frozen
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
      object.new.send(method).should be_frozen
    end
  end
end
