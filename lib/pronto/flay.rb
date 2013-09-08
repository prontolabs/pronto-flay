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
        messages_for(ruby_patches)
      else
        []
      end
    end

    def messages_for(ruby_patches)
      nodes.map do |node|
        patch = patch_for_node(ruby_patches, node)

        line = patch.added_lines.select do |added_line|
          added_line.new_lineno == node.line
        end.first

        new_message(line, node) if line
      end.flatten.compact
    end

    def patch_for_node(ruby_patches, node)
      ruby_patches.select do |patch|
        patch.new_file_full_path.to_s == node.file.path
      end.first
    end

    def new_message(line, node)
      hash = node.structural_hash
      Message.new(line.patch.delta.new_file[:path], line, level(hash), message(hash))
    end

    def level(hash)
      same?(hash) ? :error : :warning
    end

    def same?(hash)
      @flay.identical[hash]
    end

    def message(hash)
      match = same?(hash) ? 'Identical' : 'Similar'
      location = nodes_for(hash).map do |node|
        "#{File.basename(node.file.path)}:#{node.line}"
      end

      "#{match} code found in #{location.join(', ')}"
    end

    def nodes_for(hash)
      @flay.hashes[hash]
    end

    def nodes
      result = []
      masses.each do |mass|
        nodes_for(mass.first).each { |node| result << node }
      end
      result
    end

    def masses
      Array(@flay.masses)
    end
  end
end
