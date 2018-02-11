require_relative("../db/sql_runner.rb")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)

    @id = options['id'].to_i
    @name = options['name']
    @funds = options['funds'].to_i

  end

  def self.delete_all

    sql = "DELETE FROM customers"
    SqlRunner.run(sql)

  end

  def self.all

    sql = "SELECT * FROM customers"
    result = SqlRunner.run(sql)
    customers = result.map { |customer| Customer.new(customer)  }
    return customers

  end

  def save()

    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i

  end

  def delete

    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)

  end

  def update

    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)

  end

  def screenings

    sql = "SELECT screenings.* FROM screenings INNER JOIN tickets ON screenings.id = tickets.screening_id WHERE tickets.customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    screenings = result.map { |screening| Screening.new(screening)}
    return screenings

  end

  def tickets

    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql,values)
    tickets = result.map { |ticket| Ticket.new(ticket)  }

  end

  def tickets_bought

    return tickets.length

  end

  def films         # what about duplicate films?

    tickets.each do |ticket|
      films.push(ticket.ticket_film)
    end
    return films

  end



  def update_funds

    tickets.each { |ticket| @funds -= ticket.ticket_price}
    update

  end

end
