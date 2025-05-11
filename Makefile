# =============================================================================
# RWA Hub Sandbox - Makefile
# =============================================================================

SHELL := /bin/bash
.ONESHELL:

# Cores
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RESET := \033[0m

# Diretórios
PACKAGES_DIR := packages
INFRA_DIR := infrasctruture

# Repos
WEB_ADMIN_REPO := https://github.com/rwa-hub/web-pannel-admin.git
WEB_MARKETPLACE_REPO := https://github.com/rwa-hub/marketplace.git
BLOCKCHAIN_INDEXER_REPO := https://github.com/rwa-hub/blockchain-indexer.git
BLOCKCHAIN_CONTRACTS_REPO := https://github.com/rwa-hub/smart-contracts.git

# Targets
.PHONY: clean clean-lib-git submodules infra setup help

help:
	@echo "$(CYAN)RWA Hub Sandbox - Comandos:$(RESET)"
	@echo "  make clean          - Limpa tudo"
	@echo "  make clean-lib-git  - Limpa .git dos submódulos da pasta lib"
	@echo "  make submodules     - Configura submódulos"
	@echo "  make infra          - Configura infraestrutura"
	@echo "  make setup          - Configura tudo"

clean-lib-git:
	@echo "$(YELLOW)🧹 Limpando .git dos submódulos da pasta lib...$(RESET)"
	@rm -rf $(PACKAGES_DIR)/blockchain/smart-contracts/lib/*/.git || true
	@echo "$(GREEN)✨ Submódulos da lib limpos!$(RESET)"

clean: clean-lib-git
	@echo "$(YELLOW)🧹 Limpando tudo...$(RESET)"
	@cd $(INFRA_DIR) && make infra-clean || true
	@git submodule deinit -f --all || true
	@rm -rf .git/modules/* || true
	@rm -rf $(PACKAGES_DIR)
	@mkdir -p $(PACKAGES_DIR)/web $(PACKAGES_DIR)/blockchain
	@echo "$(GREEN)✨ Limpo!$(RESET)"

submodules:
	@echo "$(CYAN)📦 Configurando submódulos...$(RESET)"
	@git submodule init
	@echo "➜ Clonando web-pannel-admin"
	@git submodule add -f $(WEB_ADMIN_REPO) $(PACKAGES_DIR)/web/pannel-admin || true
	@echo "➜ Clonando marketplace"
	@git submodule add -f $(WEB_MARKETPLACE_REPO) $(PACKAGES_DIR)/web/marketplace || true
	@echo "➜ Clonando blockchain-indexer"
	@git submodule add -f $(BLOCKCHAIN_INDEXER_REPO) $(PACKAGES_DIR)/blockchain/indexer || true
	@echo "➜ Clonando smart-contracts"
	@git submodule add -f $(BLOCKCHAIN_CONTRACTS_REPO) $(PACKAGES_DIR)/blockchain/smart-contracts || true
	@git submodule update --init --recursive
	@echo "$(GREEN)✅ Submódulos configurados!$(RESET)"

infra:
	@echo "$(CYAN)🔧 Configurando infraestrutura...$(RESET)"
	@cd $(INFRA_DIR) && make setup-env
	@cd $(INFRA_DIR) && make network-create
	@cd $(INFRA_DIR) && make infra-up
	@echo "$(GREEN)✅ Infraestrutura pronta!$(RESET)"

setup: clean submodules infra
	@echo "$(GREEN)🚀 Ambiente pronto!$(RESET)"