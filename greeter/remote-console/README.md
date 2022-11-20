```mermaid
flowchart LR
	client{{client}}
	subgraph remote-console-net
		remote-console{{remote console}}
		console{{console}}
		remote-console--local-->console
	end
	
	greeter{{greeter}}

	client--sodep-->greeter
	client--sodep-->remote-console
```