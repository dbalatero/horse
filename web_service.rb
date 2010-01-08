require 'httparty'

module Horse
  class WebService
    include HTTParty
    base_uri 'horse.heroku.com'

    def self.add_stat(amount)
      user = `echo $USER`.strip + "@" + `hostname`.strip

      post("/stats",
           :query => {
             :user => { :name => user },
             :stat => { :amount => amount }
           })
    end
  end
end
