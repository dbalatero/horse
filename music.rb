require 'bloops'

module Horse
  class ThemeSong < Bloops
    TUNE = %w{ g4 c5 e5 g5 g5 g5 g5 e5 e5 e5 c5 e5 c5 g4
               g4 c5 e5 g5 g5 g5 g5 e5 e5 e5 g4 g4 g4 c5 }
    RESTS = [4, 8, 16, 32, 64, 128]
    NOTES = [2, 4, 8, 16, 32, 64]
    BOTTOM = %w{c# d# f# a# g#}

    @thread, @theme_song = nil
    def self.play(restart = false)
      return if @theme_song

      Thread.new do
        @theme_song = new
      end
    end

    def initialize
      super
      @tune = TUNE.dup

      self.tempo = 400

      s = sound(Bloops::SQUARE)
      s.punch = 0.5
      s.sustain = 0.5
      s.decay = 0.2

      s2 = sound(Bloops::SAWTOOTH)
      s2.sustain = 0.7
      s2.decay = 0.7

      loop do
        if stopped?
          note = @tune.shift
          @tune << note
          note = note.dup
          clear
          note = "#{NOTES[rand(NOTES.size)]}:#{note}" if rand > 0.7
          note = "#{RESTS[rand(RESTS.size)]} #{note}" if rand > 0.95

          #           tits
          note.gsub!(/(.)(.)/, '\1#\2') if rand > 0.85
          tune(s, note)
          tune(s2, "#{NOTES[rand(NOTES.size)]}:#{BOTTOM[rand(BOTTOM.size)]}3") if rand > 0.7
          play
        end
      end
    end
  end
end
