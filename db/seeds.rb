day_array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
character_class_array = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard"]
character_race_array = ["Dragonborn", "Dwarf", "Elf", "Gnome", "Half-elf", "Halfling", "Half-orc", "Human", "Tiefling"]
Character.delete_all
Player.delete_all
Campaign.delete_all

def stat_roll #roll 4d6, drop the lowest roll
    rolls = []
    4.times do 
        rolls << rand(1..6)
    end
    rolls.sort.reverse.first(3).sum
end


15.times do
    Player.create(name: Faker::Name.name, availability: day_array.sample)
end

5.times do
    Campaign.create(dungeon_master: Faker::Name.name, world: Faker::Game.title, bbg: Faker::Name.name, day_of_play: day_array.sample, max_players: rand(3..8))
end

10.times do
    health = rand(18..200)
    Character.create(name: Faker::Name.name, character_class: character_class_array.sample, race: character_race_array.sample, level: rand(1..20), armor_class: rand(13..19), current_health: health, max_health: health, strength: stat_roll, dexterity: stat_roll, wisdom: stat_roll, intelligence: stat_roll, charisma: stat_roll, constitution: stat_roll, player_id: Player.all.sample.id, campaign_id: Campaign.all.sample.id)
end

