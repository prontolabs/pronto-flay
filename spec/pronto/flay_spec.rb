require 'spec_helper'
require 'ostruct'

module Pronto
  describe Flay do
    let(:flay) { Flay.new(patches) }
    let(:patches) { nil }

    describe '#run' do
      subject { flay.run }

      context 'patches are nil' do
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end

      context 'patches with one code similarity' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        its(:count) { should == 1 }
        its(:'first.msg') do
          should == 'Similar code found in hello.rb:6, hello.rb:12'
        end

        context 'with ignored files' do
          before do
            ::Flay.should_receive(:filter_files) do |files|
              files.reject { |file| file.to_s.end_with?('/hello.rb') }
            end
          end

          its(:count) { should == 0 }
        end
      end
    end

    describe '#level' do
      subject { flay.level(hash) }
      before do
        ::Flay.any_instance.should_receive(:identical)
          .and_return(hash => identical)
      end
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
