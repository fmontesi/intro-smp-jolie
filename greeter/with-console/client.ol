from .greeter import GreeterInterface
from console import Console

service Main {
	outputPort greeter {
		location: "socket://localhost:8000"
		protocol: sodep
		interfaces: GreeterInterface
	}

	embed Console as console

	main {
		greet@greeter( { name = "Alice" } )( response )
		println@console( response.greeting )()
	}
}