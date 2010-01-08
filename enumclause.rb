module Horse
  class Enumclause
    RULEZ = YAML.load(File.read('rulez.yml'))
    attr_reader :fortune

    def initialize
      @fortune = `fortune`.strip
    end

    def spit_rule
      @rule = RULEZ.keys[rand(sum_up_fortune % (RULEZ.size))]
    end

    def rule_violation
      eval(RULEZ[@rule]).rule_violation
    end

    def take_valiant_action!(horse_game)
      eval(RULEZ[@rule]).take_valiant_action!(horse_game)
    end

    def sum_up_fortune
      @fortune.chars.inject(0) { |m, i| m + i[0] }
    end
  end
end
