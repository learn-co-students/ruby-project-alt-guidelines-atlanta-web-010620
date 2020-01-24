
Actor.destroy_all
User.destroy_all
Quote.destroy_all
Production.destroy_all
Game.destroy_all



steve_carell = Actor.create(name: "Steve Carell")
matthew_mcconaughey = Actor.create(name: "Matthew McConaughey")
will_ferrell = Actor.create(name: "Will Ferrell")
chris_pratt = Actor.create(name: "Chris Pratt")

the_office = Production.create(name: "The Office")
forty_year_old_virgin = Production.create(name: "40 Year Old Virgin")
anchorman = Production.create(name: "Anchorman")
dazed_and_confused = Production.create(name: "Dazed and Confused")
sing = Production.create(name: "Sing")
step_brothers = Production.create(name: "Step Brothers")
ricky_bobby = Production.create(name: "Talladega Nights: The Ballad of Ricky Bobby")
guardians_of_the_galaxy = Production.create(name: "Guardians of the Galaxy")
parks_and_rec = Production.create(name: "Parks and Rec")
get_smart = Production.create(name: "Get Smart")
evan_almighty = Production.create(name: "Evan Almighty")
avengers = Production.create(name: "Avengers: Infinity War")
super_bad = Production.create(name: "SuperBad")
community = Production.create(name: "Community")


quote1 = Quote.create(quote: "I'm Beyonce, Always.", actor_id:steve_carell.id, production_id:the_office.id)
quote2 = Quote.create(quote: "Robert better not get in my face, I'll drop that m*********.", actor_id:will_ferrell.id, production_id:step_brothers.id)
quote3 = Quote.create(quote: "Alright Alright Alright.", actor_id:matthew_mcconaughey.id, production_id:dazed_and_confused.id)
quote4 = Quote.create(quote: "Sometimes I'll start a sentence and I don't even know where its going. I just hope I find it along the way.", actor_id:steve_carell.id, production_id:the_office.id)
quote5 = Quote.create(quote: "It's fine. It's just that life is pointless and nothing matters and I'm always tired.", actor_id:chris_pratt.id, production_id:parks_and_rec.id)
quote6 = Quote.create(quote: "If you aint first, you're last. Shake and Bake!", actor_id:will_ferrell.id, production_id:ricky_bobby.id)
quote7 = Quote.create(quote: "AHHHHHHHH KELLY CLARKSON!", actor_id:steve_carell.id, production_id:forty_year_old_virgin.id)
quote8 = Quote.create(quote: "I'm in a glass case of EMOTION!", actor_id:will_ferrell.id, production_id:anchorman.id)
quote9 = Quote.create(quote: "Let's talk about this plan of yours. I think It's good. Except it sucks.", actor_id:chris_pratt.id, production_id:avengers.id)
quote10 = Quote.create(quote: "When they say 2% milk, I don't know what the other 98% is.", actor_id:chris_pratt.id, production_id:parks_and_rec.id)
quote11 = Quote.create(quote: "Don't let fear stop you from doing the thing you love.", actor_id:matthew_mcconaughey.id, production_id:sing.id)
quote12 = Quote.create(quote: "That's what I love about these high school girls man. As I get older, they all stay the same age.", actor_id:matthew_mcconaughey.id, production_id:dazed_and_confused.id)