# encoding: utf-8

require 'spec_helper'

describe Adamantium, '.included' do
  subject { descendant.instance_exec(object) { |mod| include mod } }

  let(:object)     { described_class }
  let(:superclass) { Module          }

  around do |example|
    # Restore included method after each example
    superclass.class_eval do
      alias_method :original_included, :included
      example.call
      undef_method :included
      alias_method :included, :original_included
    end
  end

  shared_examples_for 'all descendant types' do
    it 'delegates to the superclass #included method' do
      # This is the most succinct approach I could think of to test whether the
      # superclass#included method is called. All of the built-in rspec helpers
      # did not seem to work for this.
      included = 0
      superclass.class_eval { define_method(:included) { |_| included += 1 } }
      expect(included).to be(0)
      subject
      expect(included).to be(1)
    end

    it 'includes Memoizable into the descendant' do
      subject
      expect(descendant.included_modules).to include(Memoizable)
    end

    it 'extends the descendant with Adamantium::ModuleMethods' do
      subject
      expect(descendant.singleton_class.included_modules)
        .to include(Adamantium::ModuleMethods)
    end
  end

  context 'with a class descendant' do
    let(:descendant) { Class.new }

    it_behaves_like 'all descendant types'

    it 'extends a class descendant with Adamantium::ClassMethods' do
      subject
      expect(descendant.singleton_class.included_modules)
        .to include(Adamantium::ClassMethods)
    end
  end

  context 'with a module descendant' do
    let(:descendant) { Module.new }

    it_behaves_like 'all descendant types'

    it 'does not extends a module descendant with Adamantium::ClassMethods' do
      subject
      expect(descendant.singleton_class.included_modules)
        .to_not include(Adamantium::ClassMethods)
    end
  end
end
