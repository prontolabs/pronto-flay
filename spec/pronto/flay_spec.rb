require 'spec_helper'
require 'ostruct'

module Pronto
  describe Flay do
    let(:flay) { Flay.new }

    describe '#run' do
      subject { flay.run(patches) }

      context 'patches are nil' do
        let(:patches) { nil }
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end
    end

    describe '#level' do
      subject { flay.level(hash) }
      before { ::Flay.any_instance.should_receive(:identical)
                                  .and_return({hash => identical}) }
      let(:hash) { 'test' }

      context 'identical' do
        let(:identical) { true }
        it { should == :error }
      end

      context 'not identical' do
        let(:identical) { false }
        it { should == :warning }
      end
    end
  end
end
