require 'tty-prompt'
require 'pry'
class CommandLineInterface
 
  def initialize
  @prompt = TTY::Prompt.new
  @user = @prompt.ask('What is your name?', default: "Ash")
  @new_user = Trainer.create(name: @user)
  end
 
def run

puts "Hey #{@user}! Welcome to Pokemon Flatiron Edition"

end

def first_pokemon
@prompt = TTY::Prompt.new
first_pokemon = @prompt.select("Which Pokemon will you choose?") do |poke|
    poke.choice 'Bulbasaur' 
    poke.choice 'Squirtle' 
    poke.choice 'Charmander'
  end

  sleep(1)
  puts "Congratulations! #{first_pokemon} will now join you on your journey"

  case first_pokemon 
  when "Bulbasaur"
    bulbasaur = Pokemon.create(name: "Bulbasaur", type_id: 36, trainer_id: @new_user.id)
    puts <<-'EOF'
    /
_,.------....___,.' ',.-.
,-'          _,.--"        |
,'         _.-'              .
/   ,     ,'                   `
.   /     /                     ``.
|  |     .                       \.\
____      |___._.  |       __               \ `.
.'    `---""       ``"-.--"'`  \               .  \
.  ,            __               `              |   .
`,'         ,-"'  .               \             |    L
,'          '    _.'                -._          /    |
,`-.    ,".   `--'                      >.      ,'     |
. .'\'   `-'       __    ,  ,-.         /  `.__.-      ,'
||:, .           ,'  ;  /  / \ `        `.    .      .'/
j|:D  \          `--'  ' ,'_  . .         `.__, \   , /
/ L:_  |                 .  "' :_;                `.'.'
.    ""'                  """""'                    V
`.                                 .    `.   _,..  `
`,_   .    .                _,-'/    .. `,'   __  `
) \`._        ___....----"'  ,'   .'  \ |   '  \  .
/   `. "`-.--"'         _,' ,'     `---' |    `./  |
.   _  `""'--.._____..--"   ,             '         |
| ." `. `-.                /-.           /          ,
| `._.'    `,_            ;  /         ,'          .
.'          /| `-.        . ,'         ,           ,
'-.__ __ _,','    '`-..___;-...__   ,.'\ ____.___.'
`"^--'..'   '-`-^-'"--    `-^-'`.''"""""`.,^.`.--' mh
EOF
  when "Squirtle" 
    squirtle = Pokemon.create(name: "Squirtle", type_id: 33, trainer_id: @new_user.id)
    puts <<-'EOF'
    _,........__
    ,-'            "`-.
  ,'                   `-.
,'                        \
,'                           .
.'\               ,"".       `
._.'|             / |  `       \
|   |            `-.'  ||       `.
|   |            '-._,'||       | \
.`.,'             `..,'.'       , |`-.
l                       .'`.  _/  |   `.
`-.._'-   ,          _ _'   -" \  .     `
`."""""'-.`-...,---------','         `. `....__.
.'        `"-..___      __,'\          \  \     \
\_ .          |   `""""'    `.           . \     \
`.          |              `.          |  .     L
`.        |`--...________.'.        j   |     |
`._    .'      |          `.     .|   ,     |
 `--,\       .            `7""' |  ,      |
    ` `      `            /     |  |      |    _,-'"""`-.
     \ `.     .          /      |  '      |  ,'          `.
      \  v.__  .        '       .   \    /| /              \
       \/    `""\"""""""`.       \   \  /.''                |
        `        .        `._ ___,j.  `/ .-       ,---.     |
        ,`-.      \         ."     `.  |/        j     `    |
       /    `.     \       /         \ /         |     /    j
      |       `-.   7-.._ .          |"          '         /
      |          `./_    `|          |            .     _,'
      `.           / `----|          |-............`---'
        \          \      |          |
       ,'           )     `.         |
        7____,,..--'      /          |
                          `---.__,--.'mh

                          EOF

  when "Charmander"
    charmander = Pokemon.create(name: "Charmander", type_id: 34, trainer_id: @new_user.id)
    puts <<-"EOF"
    _.--""`-..
    ,'          `.
  ,'          __  `.
 /|          " __   \
, |           / |.   .
|,'          !_.'|   |
,'             '   |   |
/              |`--'|   |
|                `---'   |
.   ,                   |                       ,".
._     '           _'  |                    , ' \\ `
`.. `.`-...___,...---""    |       __,.        ,`"   L,|
|, `- .`._        _,-,.'   .  __.-'-. /        .   ,    \\
-:..     `. `-..--_.,.<       `"      / `.        `-/ |   .
`,         """"'     `.              ,'         |   |  ',,
`.      '            '            /          '    |'. |/
`.   |              \       _,-'           |       ''
`._'               \   '"\                .      |
   |                '     \                `._  ,'
   |                 '     \                 .'|
   |                 .      \                | |
   |                 |       L              ,' |
   `                 |       |             /   '
    \                |       |           ,'   /
  ,' \               |  _.._ ,-..___,..-'    ,'
 /     .             .      `!             ,j'
/       `.          /        .           .'//
.          `.       /         |        _.'.'
`.          7`'---'          |------"'_.'
_,.`,_     _'                ,''-----"'
_,-_    '       `.     .'      ,\\
-" /`.         _,'     | _  _  _.|
""--'---"""""'        `' '! |! /
EOF
          
  else 
    "No Pokemon chosen"
  end
  
end

def choose_path
  @prompt = TTY::Prompt.new

  while @prompt.yes?('Will you keep playing?')
  path = @prompt.select("What will you do next?") do |path|
    path.choice 'Catch a new Pokemon'
    path.choice 'Release a pokemon'
    path.choice 'View Current Pokemon'
    path.choice 'View Current Pokemon types'
    path.choice 'Fight'
    end
 
    case path
      when 'Catch a new Pokemon'
       puts "A wild #{temp = Pokemon.wild_pokemon} appeared."
       sleep(2)
       puts "#{@user} throws a pokeball at #{temp}"
       sleep(2)
       puts "#{temp} was caught!"
       sleep(2)
       if @new_user.view_pokemon.length < 6
        puts "#{temp} has been added to your squadron."
        Pokemon.create(name: temp, type_id: Type.all.sample.id, trainer_id: @new_user.id)
       else
        puts "You have 6 pokemon in your party"
        sleep(1)
        puts "#{temp} was transferred to your pc"
       end

      when 'Release a pokemon'
        if @new_user.view_pokemon.map{|poke| poke.name}.length > 0
        release_pokemon = @prompt.select("Which Pokemon will you release?", @new_user.view_pokemon.map{|poke| poke.name})
        storage = Pokemon.find_by(name: release_pokemon, trainer_id: @new_user.id)
        puts "#{release_pokemon} was released."   
        Pokemon.destroy(storage.id)
      else 
        sleep(2)
        puts "Stop tryna break my code"
      end

      when 'View Current Pokemon'
        if @new_user.view_pokemon.map{|poke| poke.name}.length > 0
        puts @new_user.view_pokemon.map{|poke| poke.name}
      else
        puts "You currently have no pokemon"
      end

      when 'View Current Pokemon types'
        if @new_user.view_pokemon.map{|poke| poke.name}.length > 0
        puts @new_user.view_types
      else
        puts "You currently have no pokemon"
      end

      when 'Fight'
        your_pokemon = @new_user.view_pokemon.map{|poke| poke.name}
        trainer = Trainer.random_trainer
        battle_array = trainer.view_pokemon.map{|poke| poke.name}
        puts "#{trainer.name} wants to fight..."
        sleep(2)
        puts "#{trainer.name} has #{team = battle_array.shift(6)}"
        sleep(2)
        puts "#{trainer.name} sends out #{fighter = team.sample}"
        sleep(2)
        if your_pokemon.length > 1
        puts "#{@user} sends out #{poke1 = your_pokemon.sample}"
        sleep(3)
        puts "#{poke1} is too afraid to fight. You run away"
        else 
          sleep(1)
          puts "#{@user} has no pokemon. #{fighter} beats him up"
        end
        end
    end
  end
  
end