# encoding: utf-8

require 'spec_helper'
require File.expand_path('../../fixtures/classes', __FILE__)

describe Adamantium::ModuleMethods, '#memoize' do
  subject { object.memoize(method) }

  let(:object) { Class.new(AdamantiumSpecs::Object) }

  context 'method with nonzero arity' do
    let(:method) { :single_argument } 

    it 'should raise error' do
      expect { subject }.to(raise_error(Adamantium::ArityError) do |exception|
        exception.message.should == '#single_argument has nonzero arity so cannot be memoized'
      end)
    end
  end

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
