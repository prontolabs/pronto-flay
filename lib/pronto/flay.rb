require 'pronto'
require 'flay'

module Pronto
  class Flay < Runner
    def initialize
      @flay = ::Flay.new
    end

    def run(patches)
      return [] unless patches

      ruby_patches = patches.select { |patch| patch.additions > 0 }
                            .select { |patch| ruby_file?(patch.new_file_full_path) }

      files = ruby_patches.map { |patch| File.new(patch.new_file_full_path) }

      if files.any?
        @flay.process(*files)
        @flay.analyze
        masses = Array(@flay.masses)

        messages_from(masses, ruby_patches)
      else
        []
      end
    end

    def messages_from(masses, ruby_patches)
      masses.map do |mass|
        hash = mass.first
        nodes = @flay.hashes[hash]

        patch = patch_for_node(ruby_patches, nodes.first)

        line = patch.added_lines.select do |added_line|
          added_line.new_lineno == nodes.first.line
        end.first
        next unless line
        same = @flay.identical[hash]
        level = same ? :error : :warning
        message = 'temp'
        Pronto::Message.new(path, line, level, message)
      end
    end

    def patch_for_node(ruby_patches, node)
      ruby_patches.select do |patch|
        patch.new_file_full_path.to_s == node.file.path
      end.first
    end
  end
end
