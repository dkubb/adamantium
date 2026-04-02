# encoding: utf-8

require 'spec_helper'

describe Adamantium, 'memoizing methods that initialize objects with dynamically defined methods' do
  let(:component_class) {
    Class.new do
      def initialize(attributes)
        attributes.each do |key, value|
          instance_variable_set("@#{key}".to_sym, value)
          define_singleton_method(key) { instance_variable_get("@#{key}") }
        end
      end
    end
  }

  context 'a component instance' do
    subject { component_class.new(test: true) }

    it      { is_expected.to respond_to(:test) }
    specify { expect(subject.test).to eq true }
  end

  context 'a composed instance' do
    before do
      stub_const('Component', component_class)
    end

    let(:composed_class) {
      Class.new do
        include Adamantium

        def component
          Component.new(test: true)
        end

        memoize :component
      end
    }

    let(:composed) { composed_class.new }

    context 'its composed' do
      subject { composed.component }

      it      { is_expected.to be_a component_class }
      it      { is_expected.to respond_to(:test) }
      specify { expect(subject.test).to eq true }
    end
  end
end
