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
  end
end
