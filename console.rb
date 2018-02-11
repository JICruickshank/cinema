require("pry-byebug")
require_relative("./models/customers.rb")
require_relative("./models/films.rb")
require_relative("./models/tickets.rb")
require_relative("./models/screenings.rb")

Customer.delete_all
Film.delete_all
Ticket.delete_all
Screening.delete_all


customer1 = Customer.new({'name' => 'J', 'funds' => 20})
customer1.save
film1 = Film.new('title' => 'Die Hard', 'price' => 10)
film1.save
customer2 = Customer.new({'name' => 'Steven', 'funds' => 20})
customer2.save
customer3 = Customer.new({'name' => 'Mo', 'funds' => 20})
customer3.save
film2 = Film.new({'title' => 'Leon', 'price' => 8})
film2.save
screening1 = Screening.new('film_id' => film1.id, 'start_time' => '20:00', 'max_tickets' => 2)
screening1.save
screening2 = Screening.new('film_id' => film1.id, 'start_time' => '22:30', 'max_tickets' => 2)
screening2.save

ticket1 = Ticket.new({'customer_id' => customer1.id, 'screening_id' => screening1.id})
ticket2 = Ticket.new({'customer_id' => customer2.id, 'screening_id' => screening1.id})

ticket1.save
ticket1.charge_customer_sql
ticket2.save
ticket2.charge_customer_sql
ticket3 = Ticket.new({'customer_id' => customer3.id, 'screening_id' => screening2.id})
ticket3.save
ticket3.charge_customer_sql
ticket4 = Ticket.new({'customer_id' => customer3.id, 'screening_id' => screening1.id})
binding.pry
nil
