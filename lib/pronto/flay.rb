require 'pronto'
require 'flay'

module Pronto
  class Flay < Runner
    def initialize
      @flay = ::Flay.new
    end

    def run(patches)
      return [] unless patches

      ruby_patches = patches.select do |patch|
        path = patch.delta.new_file_full_path
        patch.additions > 0 && ruby_file?(path)
      end

      files = ruby_patches.map do |patch|
        File.new(patch.delta.new_file_full_path)
      end

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
      repo = ruby_patches.first.delta.repo
      repo_path = Pathname.new(repo.path).parent
      path = Pathname.new(node.file.path).relative_path_from(repo_path)

      ruby_patches.select do |patch|
        patch.delta.new_file[:path] == path.to_s
      end.first
    end
  end
end
