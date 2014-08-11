# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#hash' do
  subject { object.hash }

  let(:object) { described_class.new }

  let(:described_class) do
    Class.new(AdamantiumSpecs::Object) do
      FIXNUM_MAX = 2**(0.size * 8 - 2) - 1
      FIXNUM_MIN = -2**(0.size * 8 - 2)

      def hash
        Random.rand(FIXNUM_MIN..FIXNUM_MAX)
      end
    end
  end

  it_behaves_like 'a hash method'
end
