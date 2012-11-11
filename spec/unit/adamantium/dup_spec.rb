# encoding: utf-8

require 'spec_helper'
require File.expand_path('../fixtures/classes', __FILE__)

describe Adamantium, '#dup' do
  subject { object.dup }

  let(:described_class) { AdamantiumSpecs::Object }
  let(:object)          { described_class.new     }

  it { should equal(object) }
end
