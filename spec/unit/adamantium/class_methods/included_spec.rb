require 'spec_helper'

describe Adamantium, '.included' do
  let(:object) { described_class }

  subject { object.included(target) }

  let(:included_modules) do
    target.singleton_class.included_modules
  end

  before { subject }

  context 'when target is a module' do
    let(:target) { Module.new }

    it_should_behave_like 'a command method'

    it 'includes Adamantium::ModuleMethods' do
      expect(included_modules).to include(Adamantium::ModuleMethods)
    end

    it 'does not include Adamantium::ClassMethods' do
      expect(included_modules).to_not include(Adamantium::ClassMethods)
    end
  end

  context 'when target is a class' do
    let(:target) { Class.new }

    it 'includes Adamantium::{Class,Module}Methods' do
      expect(included_modules).to include(Adamantium::ModuleMethods)
      expect(included_modules).to include(Adamantium::ClassMethods)
    end

    it_should_behave_like 'a command method'
  end
end
