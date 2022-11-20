from .greeter import GreeterInterface
from console import ConsoleIface

service Main {
	outputPort greeter {
		location: "socket://localhost:8000"
		protocol: sodep
		interfaces: GreeterInterface
	}

	outputPort console {
		location: "socket://localhost:8001"
		protocol: sodep
		interfaces: ConsoleIface
	}

	main {
		greet@greeter( { name = args[0] } )( response )
		println@console( response.greeting )()
	}
}