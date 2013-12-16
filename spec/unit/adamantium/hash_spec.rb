# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#hash' do
  subject { object.hash }

  let(:object)          { described_class.new     }
  let(:described_class) { AdamantiumSpecs::Object }

  it_behaves_like 'a hash method'
end
