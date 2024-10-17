require 'pronto'
require 'flay'

module Pronto
  class Flay < Runner
    DEFAULT_SEVERITY_LEVELS = {
      identical: :error,
      similar: :warning,
    }.freeze

    def run
      if files.any?
        flay.analyze
        messages
      else
        []
      end
    end

    # The current Flay (2.8.0) takes care of filtering
    # files by looking at .flayignore.
    # Saving the returned Flay object at @flay so we
    # can inspect it and build the messages Array.
    def flay
      @flay ||= ::Flay.run(params)
    end

    def params
      [*files, '-m', mass_threshold]
    end

    def files
      @files ||= ruby_patches.map(&:new_file_full_path)
    end

    def messages
      nodes.map do |node|
        patch = patch_for_node(node)

        line = patch.added_lines.find do |added_line|
          added_line.new_lineno == node.line
        end

        new_message(line, node) if line
      end.flatten.compact
    end

    def patch_for_node(node)
      ruby_patches.find do |patch|
        patch.new_file_full_path.to_s == node.file.to_s
      end
    end

    def new_message(line, node)
      path = line.patch.delta.new_file[:path]
      hash = node.structural_hash
      Message.new(path, line, level(hash), message(hash), nil, self.class)
    end

    def level(hash)
      same?(hash) ? severity_levels_config[:identical] : severity_levels_config[:similar]
    end

    def same?(hash)
      flay.identical[hash]
    end

    def severity_levels_config
      @severity_levels_config ||= DEFAULT_SEVERITY_LEVELS.merge(custom_severity_levels_config)
        .map { |k, v| [k.to_sym, v.to_sym] }
        .to_h
    end

    def custom_severity_levels_config
      Pronto::ConfigFile.new.to_h.dig('flay', 'severity_levels') || {}
    end

    def message(hash)
      match = same?(hash) ? 'Identical' : 'Similar'
      location = nodes_for(hash).map do |node|
        "#{File.basename(node.file)}:#{node.line}"
      end

      "#{match} code found in #{location.join(', ')} (mass = #{masses[hash]})"
    end

    def nodes_for(hash)
      flay.hashes[hash]
    end

    def nodes
      result = []
      masses.keys.each do |hash|
        nodes_for(hash).each { |node| result << node }
      end
      result
    end

    def masses
      flay.masses
    end

    def mass_threshold
      @mass_threshold ||= ENV['PRONTO_FLAY_MASS_THRESHOLD'] || Pronto::ConfigFile.new.to_h.dig('flay', 'mass_threshold') || ::Flay.default_options[:mass].to_s
    end

  end
end
