require_relative("../db/sql_runner.rb")

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)

    @id = options['id'].to_i
    @title = options['title']
    @price = options['price'].to_i

  end

  def self.delete_all

    sql = "DELETE FROM films"
    SqlRunner.run(sql)

  end

  def self.all

    sql = "SELECT * FROM films"
    result = SqlRunner.run(sql)
    films = result.map { |film| Film.new(film)  }

  end

  def save()

    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]['id'].to_i

  end

  def delete

    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql,values)

  end

  def update

    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)

  end

  def screenings

    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)
    screenings = result.map { |screening| Screening.new(screening) }

  end

  def most_popular_screening

    tickets_per_screening = []
    screenings.each { |screening| tickets_per_screening.push(screening.tickets)}
    result = tickets_per_screening.max { |a, b| a.length <=> b.length }
    most_popular_screening = result[0].screening
    return  most_popular_screening

  end

  def customers

    film_customers = []
    screenings.each do |screening|
       screening_customers = screening.customers
        screening_customers.each { |customer| film_customers.push(customer)}
    end
    return film_customers

  end

  def customers_viewing_film

    return customers.length

  end

end
