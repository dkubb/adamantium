require 'spec_helper'

describe Adamantium, 'usage' do
  let(:klass) do
    Class.new do
      include Adamantium

      def result
        output.rewind
        output.read
      end
      idempotent :result

    private

      def initialize
        output.write('Foo')
      end

      def output
        StringIO.new
      end
      memoize :output
    end
  end

  subject { klass.new }

  its(:result) { should eql('Foo') }
  its(:result) { should be_frozen  }
end
