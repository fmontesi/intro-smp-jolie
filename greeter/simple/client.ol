from .greeter import GreeterInterface

service Main {
	outputPort greeter {
		location: "socket://localhost:8000"
		protocol: sodep
		interfaces: GreeterInterface
	}

	main {
		greet@greeter( { name = "Alice" } )( response )
	}
}