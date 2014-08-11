# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#inspect' do
  subject { object.inspect }

  let(:object) { described_class.new }

  let(:described_class) do
    Class.new(AdamantiumSpecs::Object) do
      def inspect
        rand.to_s
      end
    end
  end

  it_behaves_like 'an idempotent method'
end
