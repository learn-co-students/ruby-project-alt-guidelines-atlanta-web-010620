day_array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
character_class_array = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"]
character_race_array = ["Dragonborn", "Dwarf", "Elf", "Gnome", "Half-elf", "Halfling", "Half-orc", "Human", "Tiefling"]
Character.delete_all
Player.delete_all
Campaign.delete_all
Dm.delete_all
Account.delete_all

def stat_roll #roll 4d6, drop the lowest roll
    rolls = []
    4.times do 
        rolls << rand(1..6)
    end
    rolls.sort.reverse.first(3).sum
end


20.times do
    Player.create(name: Faker::Name.name, availability: day_array.sample)
end

5.times do
    Dm.create(name: Faker::Name.name)
end

15.times do
    Account.create(user_name: Faker::Internet.unique.username, password: Faker::Internet.password, user: Player.all.sample)
end

5.times do
    Account.create(user_name: Faker::Internet.unique.username, password: Faker::Internet.password, user: Dm.all.sample)
end

5.times do
    Campaign.create(dm_id: Dm.all.sample.id, world: Faker::Game.title, day_of_play: day_array.sample, max_players: rand(3..8))
end

10.times do
    health = rand(18..200)
    Character.create(name: Faker::Name.name, character_class: character_class_array.sample, race: character_race_array.sample, level: rand(1..20), armor_class: rand(13..19), current_health: health, max_health: health, strength: stat_roll, dexterity: stat_roll, wisdom: stat_roll, intelligence: stat_roll, charisma: stat_roll, constitution: stat_roll, player_id: Player.all.sample.id, campaign_id: Campaign.all.sample.id)
end

dm_basic = Dm.create(name: "Patrick Uzzeta")
dm_account = Account.create(user_name: "dm", password: "dm123", user: dm_basic)
campaign_basic = Campaign.create(dm_id: dm_basic.id, world: "Flatiron Fantasy", day_of_play: "Thursday", max_players: 6)

3.times do
    health = rand(10..20)
    Character.create(name: Faker::Name.name, character_class: character_class_array.sample, race: character_race_array.sample, level: rand(1..20), armor_class: rand(13..19), current_health: health, max_health: health, strength: stat_roll, dexterity: stat_roll, wisdom: stat_roll, intelligence: stat_roll, charisma: stat_roll, constitution: stat_roll, player_id: Player.all.sample.id, campaign_id: campaign_basic.id)
end

mitch = Player.create(name: "Mitchell Goodwin", availability: "Friday")
mitch_account = Account.create(user_name: "mitch210", password: "password", user: mitch)

health = rand(10..20)
Character.create(name: "Goober Doober", character_class: character_class_array.sample, race: character_race_array.sample, level: rand(1..20), armor_class: rand(13..19), current_health: health, max_health: health, strength: stat_roll, dexterity: stat_roll, wisdom: stat_roll, intelligence: stat_roll, charisma: stat_roll, constitution: stat_roll, player_id: mitch.id, campaign_id: campaign_basic.id)
