ENV_FILE      := .env
LOG_DIR       := logs
LOG_TIMESTAMP := $(shell date +"%Y-%m-%d_%H-%M-%S")
LOAD_ENV      := set -a; [ -f $(ENV_FILE) ] && . ./$(ENV_FILE); set +a

TARGETS := server-22 server-25 win-11

.PHONY: clean init_logs $(TARGETS)

init_logs:
	@mkdir -p $(LOG_DIR)

$(TARGETS): init_logs
	@packer init builds/$@/main.pkr.hcl
	@$(LOAD_ENV) && \
	export PACKER_LOG_PATH="$(LOG_DIR)/$@_build_$(LOG_TIMESTAMP).log" PACKER_LOG=1 && \
	packer build \
		-var-file=commons.pkrvars.hcl builds/$@/

clean:
	@rm -rf artifacts $(LOG_DIR) packer_cache