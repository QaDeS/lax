module Lax
  EXT_LAX_ONLY = [ '.rbl' ].freeze
  EXT_ALL = (EXT_LAX_ONLY + [ '.rb', '.rbw' ]).freeze
  extensions = EXT_LAX_ONLY

  def self.extensions= value
    @extensions = value
  end

  def self.extensions
    @extensions
  end

  def self.find_file(path, extensions = [''])
    $:.each do |search_path|
      search_path = File.join(search_path, path)
      for ext in extensions do
        p = path + ext
        return p if FileTest.exist?(p)
      end
    end
  end

  def self.load(file)
    return false if not (file and extensiond.member? File.extname(file))

    txt = Lax.convert(file)
    Object.module_eval txt, file, 1
    true
  end

  def self.convert(file)
    txt = ""
    stack = []
    lines = File.open(file).readlines

    indents = lines.collect do |l|
      if l.match(/^\s+$/) # empty line
        -1
      else
        m = l.match(/^(\s+)/)
        last_indent = m ? m[1].gsub(/\t/, '  ').length : 0
      end
    end
    indents << 0 # just append one "empty line" for the readahead

    wait_for = nil
    lines.each_with_index do |l, index|
      if wait_for
        txt << l
        wait_for = nil if l.match(wait_for)
        next
      end

      # lookahead to find needed ends early
      indent = indents[index..-1].detect{|i| i > -1}
      actual_line = lines[index..-1].detect{|line| not line.match /^\s*$/ }
      next_indent = indents[(index+1)..-1].detect{|i| i > -1}

      # detect needed ends
      stack.reverse.each do |pindent|
        if indent <= pindent
          m = actual_line.match(/^(\s*)(else|end|rescue)/)
          if (not m) or indent != pindent
            txt << (" " * pindent) + "end\n"
          end
          stack.pop
        end
      end

      if (indent < next_indent) and (indent != stack.last)
        block_match = l.match(/<<(\w+)\s*$/)
        if block_match
          wait_for = /^#{block_match.captures[0]}\s*$/
        else
          # possibly we need to insert a "do"
          m = l.match /^\s*(module|class|def|begin|for|while|if|unless|else|rescue)/
          l.sub!(/( do)?(\s*\|.*\|)?(\s*)$/, ' do\2\3') unless m
          stack.push indent
        end
      end
      txt << l
    end

    while not stack.empty?
      txt << (" " * stack.pop) + "end\n"
    end

    txt
  end

  def self.main
    infile = ARGV[0]
    unless infile
      puts "Usage: lax <file.rbl>"
      return
    end

    puts convert(infile)
  end
end

module Kernel
  req = respond_to?(:gem_original_require) ? 'gem_original_require' : 'require'
  module_eval <<END
    alias lax_original_require #{req}
    def #{req}(path)
      lax_require path
    end
END

  alias lax_original_load load
  def load(path)
    file = Lax.find_file(path)
    Lax.load(file) || lax_original_load(path)
  end

  private
  def lax_require(path)
    return false if $".include? path

    file = Lax.find_file(path, Lax.extensions)
    if Lax.load(file)
      $" << path
      return true
    else
      lax_original_require path
    end
  end

end

