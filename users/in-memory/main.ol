type User {
	username: string
	name: string
	email: string
	karma: int
}
type ListUsersRequest { minKarma?: int }
type ListUsersResponse { usernames*: string }
type ViewUserRequest { username: string }

interface UsersInterface {
RequestResponse:
	listUsers( ListUsersRequest )( ListUsersResponse ),
	viewUser( ViewUserRequest )( User ) throws UserNotFound( string )
}

service App {
	execution: concurrent
    
	inputPort Web {
		location: "socket://localhost:8080"
		protocol: http {
			format = "json"
			osc << {
				listUsers << {
					template = "/api/user"
					method = "get"
				}
				viewUser << {
					template = "/api/user/{username}"
					method = "get"
					statusCodes.UserNotFound = 404
				}
			}
		}
		interfaces: UsersInterface
	}

	init {
		users << {
			alice << {
				name = "Alice Apple"
				email = "alice@jolie-lang.org"
				karma = 4
			}
			bob << {
				name = "Bob Banana"
				email = "bob@jolie-lang.org"
				karma = 6
			}
			carol << {
				name = "Carol Cantaloupe"
				email = "carol@jolie-lang.org"
				karma = 3
			}
		}
	}
    
	main {
		[ viewUser( request )( user ) {
			username = request.username
			if( is_defined( users.(username) ) ) {
				user << users.(username)
				user.username = username
			} else {
				throw( UserNotFound, username )
			}
		} ]

		[ listUsers( request )( response ) {
			i = 0
			foreach( username : users ) {
				user << users.(username)
				if( !( is_defined( request.minKarma ) && user.karma < request.minKarma ) ) {
					response.usernames[i++] = username
				}
			}
		} ]
	}
}
