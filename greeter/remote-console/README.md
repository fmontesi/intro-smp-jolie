```mermaid
graph LR
	client{{client}}
	remote-console{{remote console}}
	
	greeter{{greeter}}

	client--sodep-->greeter
	client--sodep-->remote-console
```