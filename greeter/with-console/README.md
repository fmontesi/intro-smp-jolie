```mermaid
graph LR
	subgraph client-net
		direction TB
		client{{client}}
		console{{console}}
		client--local-->console
	end

	greeter{{greeter}}

	client--sodep-->greeter
```