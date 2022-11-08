class Dog
    attr_accessor :id, :name, :breed

    def initialize(id: nil, name:, breed:)
        @id = id
        @name = name
        @breed = breed
    end

    def self.create_table

        self.drop_table

        sql = <<-SQL
        CREATE TABLE IF NOT EXISTS dogs (
            id INTEGER PRIMARY KEY,
            name TEXT,
            breed TEXT
        );
        SQL

        DB[:conn].execute(sql)
    end

    def self.drop_table
        sql = <<-SQL
        DROP TABLE IF EXISTS dogs;
        SQL

        DB[:conn].execute(sql)
    end

    def save
        sql = <<-SQL
        INSERT INTO dogs (name, breed) VALUES (?, ?);
        SQL

        DB[:conn].execute(sql, self.name, self.breed)
        @id = DB[:conn].last_insert_row_id

        self
    end

    def self.create(name:, breed:)
        dog = Dog.new(name: name, breed: breed)

        dog.save
    end

    def self.new_from_db(row)
        self.new(id: row[0], name: row[1], breed: row[2])
    end


    def self.all
        sql = <<-SQL
        SELECT * FROM dogs;
        SQL

        records = DB[:conn].execute(sql)

        records.map do |record|
            self.new_from_db(record)
        end
    end

    def self.find_by_name(name)
        sql = <<-SQL
        SELECT * FROM dogs WHERE dogs.name = ? LIMIT 1;
        SQL

        results = DB[:conn].execute(sql, name)

        results.map do |result|
            self.new_from_db(result)
        end.first
    end

    def self.find(id)
        sql = <<-SQL
        SELECT * FROM dogs WHERE dogs.id = ? LIMIT 1;
        SQL

        results = DB[:conn].execute(sql, id)

        # return a single Dog instance
        results.map do |result|
            self.new_from_db(result)
        end.first

    end
end
