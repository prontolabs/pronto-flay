require 'spec_helper'
require 'ostruct'

module Pronto
  describe Flay do
    let(:flay) { Flay.new(patches) }
    let(:patches) { nil }
    let(:pronto_config) do
      instance_double Pronto::ConfigFile, to_h: config_hash
    end
    let(:config_hash) { {} }

    before do
      allow(Pronto::ConfigFile).to receive(:new).and_return(pronto_config)
    end

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
          should == 'Similar code found in hello.rb:6, hello.rb:12 (mass = 32)'
        end

        context 'with ignored files' do
          before do
            ::Flay.send(:remove_const, :DEFAULT_IGNORE)
            ::Flay::DEFAULT_IGNORE = 'spec/fixtures/test.git/.flayignore'.freeze
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

      context 'when custom configuration provided' do
        let(:config_hash) { { 'flay' => { 'severity_levels' => levels_configuration } } }

        context 'identical' do
          let(:identical) { true }
          let(:levels_configuration) { { 'identical' => 'warning' } }
          it { should == :warning }
        end

        context 'not identical' do
          let(:identical) { true }
          let(:levels_configuration) { { 'similar' => 'error' } }
          it { should == :error }
        end
      end
    end
  end
end
