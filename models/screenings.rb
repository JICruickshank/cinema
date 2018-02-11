require_relative("../db/sql_runner.rb")

class Screening

  attr_reader :id
  attr_accessor :film_id, :start_time

  def initialize(options)

    @id = options['id'].to_i
    @film_id = options['film_id'].to_i
    @start_time = options['start_time']
    @max_tickets = options['max_tickets']

  end

  def self.delete_all

    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)

  end

  def self.all

    sql = "SELECT * FROM screenings"
    result = SqlRunner.run(sql)
    screenings = result.map { |screening| Screening.new(screening)  }

  end

  def save()

    sql = "INSERT INTO screenings (film_id, start_time) VALUES ($1, $2) RETURNING id"
    values = [@film_id, @start_time]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i

  end

  def delete

    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)

  end

  def update

    sql = "UPDATE screenings SET (film_id, start_time) = ($1, $2) WHERE id = $3"
    values = [@film_id, @start_time, @id]
    SqlRunner.run(sql, values)

  end

  def film

    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    result = SqlRunner.run(sql, values)[0]
    film = Film.new(result)

  end

  def tickets

    sql = "SELECT * FROM tickets WHERE screening_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    tickets = result.map { |ticket| Ticket.new(ticket) }

  end

  def customers

    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE tickets.screening_id= $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    customers = result.map { |customer| Customer.new(customer) }

  end

  def count_tickets_sold

    return tickets.length

  end

end
