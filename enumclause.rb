class Enumclause
  RULEZ = YAML.load(File.read('rulez.yml'))
  attr_reader :fortune

  def initialize
    @fortune = `fortune`.strip
  end

  def the_rule
    RULEZ[rand(sum_up_fortune % (RULEZ.size))]
  end

  def sum_up_fortune
    @fortune.chars.inject(0) { |m, i| m + i[0] }
  end
end
