require_relative("../db/sql_runner.rb")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :film_id

  def initialize(options)

    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @film_id = options['film_id'].to_i

  end

  def self.all

    sql = "SELECT * FROM tickets"
    result = SqlRunner.run(sql)
    tickets = result.map { |ticket| Ticket.new(ticket) }

  end

  def self.delete_all

    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)

  end

  def save

    sql = "INSERT INTO tickets (customer_id, film_id) VALUES ($1, $2) RETURNING id"
    values = [@customer_id, @film_id]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i

  end

  def delete

    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)

  end

  def update

    sql = "UPDATE tickets SET (customer_id, film_id) = ($1,$2) where id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)

  end

  def film

    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    result = SqlRunner.run(sql, values)[0]
    film = Film.new(result)
    return film

  end

  def customer

    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    result = SqlRunner.run(sql, values)[0]
    customer = Customer.new(result)
    return customer

  end

  # def charge_customer
  #
  #   customer.funds = customer.funds - film.price
  #   return customer.funds
  #
  # end


  # def charge_customer
  #
  #   Customer.all.each do |customer|
  #     if customer.id == @customer_id
  #       return customer
  #     end
  #   end
  #   Film.all.each do |film|
  #     if film.id == @film_id
  #       return film
  #     end
  #   end
  #   customer.funds -= film.price
  # end

end
