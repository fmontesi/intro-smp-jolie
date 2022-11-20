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
		close@db()()
	}
}