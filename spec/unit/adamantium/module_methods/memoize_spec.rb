# encoding: utf-8

require 'spec_helper'
require File.expand_path('../../fixtures/classes', __FILE__)

shared_examples_for 'memoizes method' do
  it 'memoizes the instance method' do
    subject
    instance = object.new
    instance.send(method).should equal(instance.send(method))
  end

  it 'creates a method that returns a frozen value' do
    subject
    object.new.send(method).should be_frozen
  end

  specification = proc do
    subject
    file, line = object.new.send(method).first.split(':')[0, 2]
    File.expand_path(file).should eql(File.expand_path('../../../../../lib/adamantium/module_methods.rb', __FILE__))
    line.to_i.should eql(80)
  end

  it 'sets the file and line number properly' do
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
  subject { object.memoize(method) }

  let(:object) { Class.new(AdamantiumSpecs::Object) }

  context 'public method' do
    let(:method) { :public_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a public method' do
      should be_public_method_defined(method)
    end
  end

  context 'protected method' do
    let(:method) { :protected_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a protected method' do
      should be_protected_method_defined(method)
    end
  end

  context 'private method' do
    let(:method) { :private_method }

    it_should_behave_like 'a command method'
    it_should_behave_like 'memoizes method'

    it 'is still a private method' do
      should be_private_method_defined(method)
    end
  end
end
