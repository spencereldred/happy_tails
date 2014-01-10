# happy_tails.rb
# Spencer Eldred
# Sept 27, 2013

# Activity:
# You are the manager at HappiTails animal shelter. You need to manage your shelter by storing and manipulating information about clients and animals.
# Object Specs:

# Animal:
# An animal should have a name, an age, a gender, a species, and can have multiple toys.
class Animal

  attr_accessor :name, :age, :gender, :species, :toys

  @@new_animal_id = 0

  def initialize(name, age, gender, species, toys)
    @name = name
    @age = age
    @gender = gender
    @species = species
    @toys = toys
    @@new_animal_id += 1
  end

  def self.get_animal_id
    @@new_animal_id
  end

  def add_toy(toy)
    @toys << toy
  end

  def to_s
    "#{@name}: Age: #{@age}, Gender: #{@gender}, Species: #{@species}, Toys: #{@toys}"
  end

end

# Client:
# A client should have a name, a number of children, an age, and a number of pets.
class Client

  attr_accessor :name, :number_of_children, :age, :number_of_pets, :animals

  @@new_client_id = 0

  def initialize(name, number_of_children, age)
    @name = name
    @number_of_children = number_of_children
    @age = age
    @number_of_pets = 0
    @animals = []
    @@new_client_id += 1
  end

  def add_animal(animal)
    @animals << animal
    @number_of_pets += 1
  end

  def remove_animal(animal)
    @animals.delete(animal)
    @number_of_pets -= 1
  end

  def display_pets
    @animals.each { |animal| puts animal }
  end

  def self.get_client_id
    @@new_client_id
  end

  def to_s
    "#{@name}: Number of children: #{@number_of_children}, Age: #{@age}, Number of pets: #{@number_of_pets}"
  end

end

# Shelter:
# The shelter should display all the clients, and all the animals.
class Shelter

attr_accessor :animals, :clients

  def initialize(animals, clients)
    @animals = animals
    @clients = clients
  end

  def add_client(client)
    @clients << client
  end

  def remove_client(client)
    @client.delete(client)
  end

  def add_animal(animal)
    @animals << animal
  end

  def remove_animal(animal)
    @animals.delete(animal)
  end

  def display_clients
    @clients.each { |client|  display_user(client) unless client.name == "Visitor" }
  end

  def display_client(user)
    @clients.each { |client| display_user(client) if client.name == user}
  end

  def display_user(client)
    puts client
      if client.number_of_pets > 0
        puts "\t#{client.name}'s' list of adopted animals: \n\t#{client.animals.join("\n\t")}."
      else
        puts "\t#{client.name} has not adopted any animals yet."
      end
  end


  def display_animals
    @animals.each { |animal| puts animal }
  end

  def display_animal(pet)
    @animals.each { |animal| puts animal.name }
  end

  # A client should be able to put an animal up for adoption

def adopt_an_animal(user)
  puts "\tAdopt an animal"
  animal_list
  puts "\nLogged in user account information:\n"
  display_client(user)
  puts "\nHello #{user}, type in the name of the animal you would like to adopt:"
  pet = gets.chomp
  if animals.any?  { |animal| animal.name == pet }
    clients.each do |client|
      if client.name == user
        animals.each { |animal| client.add_animal(animal) if animal.name == pet }
      end
    end
    animals.each { |animal| remove_animal(animal) if animal.name == pet }
    puts "Congratulations #{user}, you have just adopted #{pet}!"
  else
    puts "#{pet} is not one of the animals on the list. Return to menu and try again."
  end
end

def put_animal_up_for_adoption(user)
  #shelter.display_client(user)
  puts "\tPut animal up for adoption:"
  puts "Is this animal a stray? [y/n]"
  stray = gets.chomp
  if stray == "n"
    puts "Hello #{user}, here is your current list of pets:"
    clients.each { |client| client.display_pets if client.name == user}
    puts "What pet would you like to put up for adoption:"
    pet = gets.chomp
    puts "youve requested animal: #{pet}"
    clients.each do |client|
      if client.name == user
        client.animals.each do |animal|
          add_animal(animal)
          client.remove_animal(animal)
        end # client.animals.each
      end # if client.name == user
    end # shelter.clients.each
  else
    create_animal
    put_animal_up_for_adoption(user)
  end # if not stray
  puts "#{pet} has been put up for adoption."
end

# class Animal(name, age, gender, species, toys)
def create_animal
  puts "\tCreate an animal"
  puts "Enter the following data for your animal:"
  print "Name: "
  name = gets.chomp
  print "Age: "
  age = gets.chomp.to_i
  print "Gender: "
  gender = gets.chomp
  print "Species: "
  species = gets.chomp
  print "Toys - (enter a comma separated list): "
  toys = []
  toys << gets.chomp
  add_animal(Animal.new(name, age, gender, species, toys.join.split(", ")))
end

# class Client(name, number_of_children, age, number_of_pets)
def create_client
  puts "\tCreate a client:"
  puts "Enter the following data for client:"
  print "Name: "
  name = gets.chomp
  print "Number of children: "
  number_of_children = gets.chomp.to_i
  print "Age: "
  age = gets.chomp.to_i
  add_client(Client.new(name, number_of_children, age))
end

def animal_list
  puts ""
  puts "There are #{@animals.length} animals available for adoption:"
  puts ""
  display_animals
end

def client_list
  puts ""
  puts "Shelter client list: (#{@clients.length} clients)"
  puts ""
  display_clients
end

end # Shelter

# Login with error handling and  custom error
class UserValidationError < StandardError

  def message
    display_banner
    "The name you entered is not on the client list. \n" +
    "Enter your name, or Visitor to log in:"
  end

end

def validate_client(shelter)
  puts ""
  puts "Enter your name, or Visitor to log in:"
  begin
    user = gets.chomp
    raise UserValidationError if !shelter.clients.any? { |client| client.name == user }
  rescue StandardError => e  # runs if there is an error
  puts e.message
  # puts "Retry [y/n]"
  # try_again = gets.chomp
  # if try_again == "n"  # want to exit block if user needs to create client account
  #   login(shelter)
  # end
  retry # runs program starting at the begin block

  ensure # always runs at the end of the block.  good for closing files or closing databases
    puts "Welcom #{user}, you are now logged in."
    return user
  end
end

# Relationships:
# A client should be able to adopt an animal.

# Helper methods
def return_to_continue
  puts ""
  puts "press return to continue"
  gets.chomp
end

def quit
  puts "Aloha, come back again!"
end # def quit

def display_banner
  puts `clear`
  puts "Animal Shelter - adopt a new pet today!"
  puts "****************************************"
end



# main menu
def main(shelter, user)
  valid_mode = false
  while !valid_mode
    display_banner
    puts "Enter number to execute request:"
    puts "  1) Display all animals"
    puts "  2) Display all clients"
    puts "  3) Create an animal"
    puts "  4) Create a client"
    puts "  5) Adopt an animal"
    puts "  6) Put an animal up for adoption"
    puts "  Q) Quit"
    mode = gets.chomp.upcase
    if mode == "1" || mode == "2" || mode == "3" || mode == "4" || mode == "5" || mode == "6" || mode == "Q"
      valid_mode = true
      display_banner
      case mode
      when "1"
        shelter.animal_list
      when "2"
        shelter.client_list
      when "3"
        shelter.create_animal
      when "4"
        shelter.create_client
      when "5"
        if user == "Visitor"
          puts "\n\tAs Visitor, you cannot adopt an animal, \n\tyou must create an account and log in."
        else
          shelter.adopt_an_animal(user)
        end
      when "6"
        if user == "Visitor"
          puts "\n\tAs Visitor, you cannot place an animal up for adoption, \n\tyou must create an account and log in."
        else
          shelter.put_animal_up_for_adoption(user)
        end
      when "Q"
        quit
      end # case mode
      unless mode == "Q"
        return_to_continue
        main(shelter, user) unless mode == "Q"
      end
    else
      puts "You didn't enter a valid selection, try again.\n\n"
    end # if
  end # while !valid_mode
end # def start_menu

# login menu
def login(shelter)
  valid_mode = false
  while !valid_mode
    display_banner
    puts "Select"
    puts "1) Login"
    puts "2) Create Client Account"
    puts "Q) Quit"
    mode = gets.chomp.upcase
    if mode == "1" || mode == "2" || mode == "Q"
      valid_mode = true
      display_banner
      case mode
      when "1"
        user = validate_client(shelter)
        main(shelter, user)
      when "2"
        shelter.create_client
        shelter.client_list
        return_to_continue
        login(shelter)
      when "Q"
        quit
      else
        login
      end # case mode
    else
      puts "You didn't enter a valid selection, try again.\n\n"
    end # if
  end # while !valid_mode
end # def login

# initialize method, calls main
def init
  # create the initial animals
  # class Animal(name, age, gender, species, toys)
  bootsie = Animal.new("Bootsie", 12, "female", "cat", ["roaches", "cane spiders", "geckos"])
  lani = Animal.new("Lani", 4, "female", "cat", ["fuzzy ball", "geckos"])
  thor = Animal.new("Thor", 8, "male", "dog", ["tennis ball", "apples"])
  lili = Animal.new("Lili", 4, "female", "cat", ["imaginary friend", "chair"])
  dexter = Animal.new("Dexter", 7, "male" ,"dog", ["chew toy", "stuffed animal"])

  # create the initial clients
  # class Client(name, number_of_children, age, number_of_pets)
  visitor = Client.new("Visitor", 0, 25)
  bob = Client.new("Bob", 4, 76)
  annie = Client.new("Annie", 0, 42)
  adara = Client.new("Adara", 0, 16)
  josh = Client.new("Josh", 0, 18)

  # create the shelter with the initial animals and clients
  animals = [bootsie, lani, thor, lili, dexter]
  clients = [bob, annie, adara, josh,visitor]
  shelter = Shelter.new(animals, clients)

  # call login
  login(shelter)
end

# Start the program with a call to "init"
init

# Instructions:

# Phase 1
# Can create animals and clients

# Phase 2
# New animals and clients can be added to the shelter

# Phase 3
# When creating an animal or client, the user is prompted for information like names, gender etc.

# Phase 4

# At start, the user is prompted with a menu of options:
# display all animals, display all clients, create an animal, create an client
# facilitate client adopts an animal,  facilitate client puts an animal up for adoption
# After selecting from the menu the task the user is prompted through the entire process