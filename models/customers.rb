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

  def films

    sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE tickets.customer_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    films = result.map { |film| Film.new(film)  }
    return films

  end

  def tickets_bought

    return films.length

  end

  def update_funds

    films.each { |film| @funds -= film.price}
    update

  end

end
