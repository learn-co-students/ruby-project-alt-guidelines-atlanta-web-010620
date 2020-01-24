Trainer.delete_all
Type.delete_all
Pokemon.delete_all

Type.create(name: "Ghost")
Type.create(name: "Normal")
Type.create(name: "Water")
Type.create(name: "Fire")
Type.create(name: "Electric")
Type.create(name: "Grass")
Type.create(name: "Ground")
Type.create(name: "Fighting")
Type.create(name: "Bug")
Type.create(name: "Psychic")
Type.create(name: "Rock")
Type.create(name: "Poison")
Type.create(name: "Flying")
Type.create(name: "Dark")
Type.create(name: "Steel")

Trainer.create(name: "Ash")
Trainer.create(name: "Brock")
Trainer.create(name: "Misty")
Trainer.create(name: "Gary")
Trainer.create(name: "Bradley")
Trainer.create(name: "Ash")
Trainer.create(name: "Goku")
Trainer.create(name: "L")
Trainer.create(name: "Luffy")
Trainer.create(name: "Killua")
Trainer.create(name: "Gon")
Trainer.create(name: "Lelouch")
Trainer.create(name: "Sasuke")
Trainer.create(name: "Vulcan")
Trainer.create(name: "Iris")
Trainer.create(name: "Shinra")
Trainer.create(name: "Midoriya")
Trainer.create(name: "Katsuki")


150.times do 
Pokemon.create(name: Faker::Games::Pokemon.name, trainer_id: Trainer.all.sample.id, type_id: Type.all.sample.id)
end

