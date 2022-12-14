from database import Database

type User {
	username: string
	name: string
	email: string
	karma: int
}
type ListUsersRequest { minKarma?: int }
type ListUsersResponse { usernames*: string }
type GetUserRequest { username: string }

interface UsersInterface {
RequestResponse:
	listUsers( ListUsersRequest )( ListUsersResponse ),
	getUser( GetUserRequest )( User ) throws UserNotFound( string ),
	createUser( User )( void )
}

service Users {
	execution: concurrent
	
	inputPort Input {
		location: "socket://localhost:8080"
		protocol: http {
			format = "json"
			osc << {
				listUsers << {
					template = "/user"
					method = "get"
				}
				getUser << {
					template = "/user/{username}"
					method = "get"
					statusCodes.UserNotFound = 404
				}
				createUser << {
					template = "/user/{username}"
					method = "post"
				}
			}
		}
		interfaces: UsersInterface
	}

	embed Database as db

	init {
		connect@db( {
			driver = "hsqldb_embedded"
			database = "db/users;sql.lowercase_ident=true"
			username = "jolie"
			password = "hs"
			host = ""
		} )()
	}

	main {
		[ createUser( request )() {
			update@db( "INSERT INTO users(username, name, email, karma) VALUES(:username, :name, :email, :karma)" {
				username = request.username
				name = request.name
				email = request.email
				karma = request.karma
			} )()
		} ]

		[ getUser( request )( response ) {
			query@db( "SELECT username, name, email, karma FROM users WHERE username=:username" {
				username = request.username
			} )( result )
			if( #result.row == 0 ) {
				throw( UserNotFound, "Could not find username " + request.username )
			}
			response << result.row[0]
		} ]

		[ listUsers( request )( response ) {
			query@db( "SELECT username FROM users WHERE karma >= :minKarma" {
				minKarma = request.minKarma
			} )( result )
			i = 0
			for( row in result.row ) {
				response.usernames[i++] = row.username
			}
		} ]
	}
}