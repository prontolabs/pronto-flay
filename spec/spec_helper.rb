require 'fileutils'
require 'rspec'
require 'rspec/its'
require 'pronto/flay'

RSpec.shared_context 'test repo' do
  let(:git) { 'spec/fixtures/test.git/git' }
  let(:dot_git) { 'spec/fixtures/test.git/.git' }

  before { FileUtils.mv(git, dot_git) }
  let(:repo) { Pronto::Git::Repository.new('spec/fixtures/test.git') }
  after { FileUtils.mv(dot_git, git) }
end

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = %i[expect should] }
  config.mock_with(:rspec) { |c| c.syntax = %i[expect should] }
end
