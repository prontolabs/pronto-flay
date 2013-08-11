require 'spec_helper'
require 'grit-ext'

module Pronto
  describe Flay do
    let(:flay) { Flay.new }

    describe '#run' do
      subject { flay.run(diffs) }

      context 'diffs are nil' do
        let(:diffs) { nil }
        it { should == [] }
      end

      context 'no diffs' do
        let(:diffs) { [] }
        it { should == [] }
      end

    end
  end
end
