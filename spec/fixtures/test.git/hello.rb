class Hello
  def initialize(name)
    @name = name
  end

  def say
    return if @name.nil?
    return if @name.empty?
    puts "Hello #{@name.capitalize}!"
  end

  def shout
    return if @name.nil?
    return if @name.empty?
    puts "Hello #{@name.capitalize}!"
  end
end

Hello.new('world').say
Hello.new('world').shout
