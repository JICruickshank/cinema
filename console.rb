require("pry-byebug")
require_relative("./models/customers.rb")
require_relative("./models/films.rb")
require_relative("./models/tickets.rb")

Customer.delete_all
Film.delete_all
Ticket.delete_all

customer1 = Customer.new({'name' => 'J', 'funds' => 20})
customer1.save
film1 = Film.new('title' => 'Die Hard', 'price' => 10)
film1.save
customer2 = Customer.new({'name' => 'Steven', 'funds' => 20})
customer2.save
film2 = Film.new({'title' => 'Leon', 'price' => 8})
film2.save
ticket1 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film1.id})
ticket2 = Ticket.new({'customer_id' => customer1.id, 'film_id' => film2.id})
ticket1.save
ticket2.save
ticket3 = Ticket.new({'customer_id' => customer2.id, 'film_id' => film1.id})
ticket3.save









binding.pry
nil
