require 'pronto'
require 'flay'

module Pronto
  class Flay < Runner
    def initialize
      @flay = ::Flay.new
    end

    def run(patches)
      return [] unless patches

      files = diffs.select { |diff| diff.added.any? }
                   .select { |diff| File.extname(diff.b_path) == '.rb' }
                   .map { |diff| diff.b_blob.create_tempfile }

      @flay.process(*files)
      @flay.report
    end
  end
end
