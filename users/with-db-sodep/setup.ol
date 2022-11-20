from database import Database

service Main {
	embed Database as db
	main {
		connect@db( {
			driver = "hsqldb_embedded"
			database = "file:db/users;sql.lowercase_ident=true"
			username = "jolie"
			password = "hs"
			host = ""
		} )()

		update@db( "CREATE TEXT TABLE users(username VARCHAR(50) PRIMARY KEY, name VARCHAR(100) NOT NULL, email VARCHAR(200) NOT NULL, karma INTEGER NOT NULL);" )()
		update@db( "SET TABLE users SOURCE \"users.csv;fs=|\";")()

		initData << {
			users[0] << { username = "alice", name = "Alice Apple", email = "alice@jolie-lang.org", karma = 4 }
			users[1] << { username = "bob", name = "Bob Banana", email = "bob@jolie-lang.org", karma = 6 }
			users[2] << { username = "carol", name = "Carol Cantaloupe", email = "carol@jolie-lang.org", karma = 3 }
		}

		for( user in initData.users ) {
			update@db( "INSERT INTO users(username, name, email, karma) VALUES(:username, :name, :email, :karma)" {
				username = user.username
				name = user.name
				email = user.email
				karma = user.karma
			} )()
		}
		close@db()()
	}
}