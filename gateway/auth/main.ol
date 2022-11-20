from ...greeter.by-username import GreeterInterface
from ...users.with-db-sodep import UsersInterface

type Authorization {
	apiKey: string
}

interface extender AuthorizationExtender {
RequestResponse:
	createUser( Authorization )( void ) throws Unauthorized( void )
}

service Gateway {
	outputPort greeter {
		location: "socket://localhost:8000"
		protocol: sodep
		interfaces: GreeterInterface
	}

	outputPort users {
		location: "socket://localhost:8001"
		protocol: sodep
		interfaces: UsersInterface
	}

	inputPort WebInput {
		location: "socket://localhost:8080"
		protocol: http {
			format = "json"
			osc << {
				greet << {
					template = "/greeting/{username}"
					method = "get"
				}
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
					inHeaders.Authorization = "apiKey"
					statusCodes.Unauthorized = 401
				}
			}
		}
		aggregates:
			greeter,
			users with AuthorizationExtender
	}

	courier WebInput {
		[ createUser( request )( response ) {
			if( request.apiKey != "Bearer 123" ) {
				throw( Unauthorized )
			}
			forward( request )( response )
		} ]
	}

	main {
		linkIn( Exit )
	}
}