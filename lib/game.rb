
class Game < ActiveRecord::Base
    belongs_to :user
    belongs_to :actor


    def start_game
        prompt = TTY::Prompt.new
        count = 3
        if count > 0
            puts "Where is this quote from?!"    
        q = self.actor.quotes.sample
        puts q.quote
        choices = Production.all.map {|prod| prod.name}.filter {|prod| prod != q.production.name}.sample(3)
        choices << q.production.name
      answer = prompt.select("which one is correct?", choices.shuffle, cycle: true)
        if answer == q.production.name
            puts "Did you guess? Ha, don't tell me! But thats correct!"
            self.score += 1
            puts "New score: #{self.score}"
        else
           puts "WRONG!... WRONG WRONG WRONG!"
        end
        count -= 1
        puts "Here's quote 2!"
        sleep(1)
        q_two = self.actor.quotes.filter {|phrase| phrase != q}.sample
        puts q_two.quote
        choices_2 = Production.all.map {|prod| prod.name}.filter {|prod| prod != q_two.production.name}.sample(3)
        choices_2 << q_two.production.name
       answer_2 = prompt.select("Which one is correct?", choices_2.shuffle, cycle: true)
        if answer_2 == q_two.production.name
            sleep(1)
            puts "Right! NOICE!"
            self.score += 1
            sleep(1)
            puts "New Score: #{self.score}"
        else
            puts "NOOOOO!!!!"
        end
        count -= 1
        sleep(1)
        puts "It's the final quote(down)!"
        sleep(2)
        puts "da na na naaa da na na na naaaaa"
        sleep(2)
        q_three = self.actor.quotes.filter {|phrase| phrase != q && phrase != q_two}.sample
        puts q_three.quote
        choices_3 = Production.all.map {|prod| prod.name}.filter {|prod| prod != q_two.production.name && prod != q.production.name}.sample(3)
        choices_3 << q_three.production.name
       answer_3 = prompt.select("Which one is correct?", choices_3.shuffle, cycle: true)
        if answer_3 == q_three.production.name
            sleep(1)
            puts "Bingo!"
            self.score += 1
            sleep(1)
            puts "New Score: #{self.score}"
        else
            puts "sorry that I'm not sorry, but you're wrong."
        end
        count -= 1
        if count == 0 && self.score == 3
        puts "3 for 3! You're a #{self.actor.name} wizard!"
        else
            sleep(1)
            puts "no participation trophies over here"
        end
    end
    
    end

end
