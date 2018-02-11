require_relative("../db/sql_runner.rb")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :screening_id

  def initialize(options)

    @id = options['id'].to_i
    @customer_id = options['customer_id'].to_i
    @screening_id = options['screening_id'].to_i

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

      if screening.tickets_available
        sql = "INSERT INTO tickets (customer_id, screening_id) VALUES ($1, $2) RETURNING id"
        values = [@customer_id, @screening_id]
        @id = SqlRunner.run(sql, values)[0]['id'].to_i
      else
        return "No more tickets!"
      end

  end

  def delete

    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)

  end

  def update

    sql = "UPDATE tickets SET (customer_id, screening_id) = ($1,$2) where id = $3"
    values = [@customer_id, @screening_id, @id]
    SqlRunner.run(sql, values)

  end

  def screening

    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@screening_id]
    result = SqlRunner.run(sql, values)[0]
    screening = Screening.new(result)
    return screening

  end

  def customer

    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    result = SqlRunner.run(sql, values)[0]
    customer = Customer.new(result)
    return customer

  end

  def ticket_film

    ticket_film = screening.film
    return ticket_film

  end

  def ticket_price

    ticket_price = ticket_film.price
    return ticket_price

  end

  def charge_customer_sql

    sql = "UPDATE customers SET funds = funds - $1 WHERE id = $2"
    values = [ticket_price, @customer_id]
    SqlRunner.run(sql, values)

  end

  # def charge_customer_ruby
  #
  #   # why doesn't this work? different instance of Customer but id number is the same so should update sql but doesn't
  #   viewer = customer
  #   viewer.funds -= ticket_price
  #   # return viewer
  #   viewer.update

  # end



end
