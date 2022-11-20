from ...users.with-db-sodep import UsersInterface

type GreetRequest { username: string }
type GreetResponse { greeting: string }

interface GreeterInterface {
RequestResponse:
	greet( GreetRequest )( GreetResponse ) throws UserNotFound( string )
}

service Greeter {
	execution: concurrent

	inputPort Input {
		location: "socket://localhost:8000"
		protocol: sodep
		interfaces: GreeterInterface
	}

	outputPort users {
		location: "socket://localhost:8001"
		protocol: sodep
		interfaces: UsersInterface
	}

	main {
		greet( request )( response ) {
			getUser@users( request )( user )
			response.greeting =
				(if( user.karma > 3 ) "😀" else "🤨") +
				" Hello, " + user.name
		}
	}
}
