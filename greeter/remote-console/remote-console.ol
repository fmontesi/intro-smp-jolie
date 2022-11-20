from console import Console

service RemoteConsole {
	embed Console as console

	inputPort Input {
		location: "socket://localhost:8001"
		protocol: sodep
		aggregates: console
	}

	main {
		linkIn( Exit )
	}
}