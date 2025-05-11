# =============================================================================
# RWA Hub - Makefile Principal
# =============================================================================
# Autor: RWA Hub Team
# Data: 2024
# Descrição: Makefile para gerenciamento do ambiente RWA Hub
# =============================================================================

# =============================================================================
# 1. CONFIGURAÇÕES BÁSICAS
# =============================================================================
SHELL := /bin/bash
.ONESHELL:

# =============================================================================
# 2. CONFIGURAÇÕES DE CORES E FORMATAÇÃO
# =============================================================================
# Cores base
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m
RESET := \033[0m

# Cores compostas para títulos e bordas
TITLE_COLOR := $(BOLD)$(BLUE)
BORDER_COLOR := $(BOLD)$(CYAN)
SECTION_COLOR := $(BOLD)$(YELLOW)

# =============================================================================
# 3. DIRETÓRIOS E CAMINHOS
# =============================================================================
PACKAGES_DIR := packages
INFRA_DIR := infrasctruture

# =============================================================================
# 4. REPOSITÓRIOS
# =============================================================================
WEB_ADMIN_REPO := https://github.com/rwa-hub/web-pannel-admin.git
WEB_MARKETPLACE_REPO := https://github.com/rwa-hub/marketplace.git
BLOCKCHAIN_INDEXER_REPO := https://github.com/rwa-hub/blockchain-indexer.git
BLOCKCHAIN_CONTRACTS_REPO := https://github.com/rwa-hub/smart-contracts.git

# =============================================================================
# 5. DEFINIÇÃO DE TARGETS
# =============================================================================
.PHONY: help clean clean-lib-git submodules infra setup

# Target padrão mostra a ajuda
.DEFAULT_GOAL := help

# =============================================================================
# 6. COMANDOS PRINCIPAIS
# =============================================================================
help:
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(TITLE_COLOR)                    RWA Hub - Comandos                      $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════════════════════════╝$(RESET)"
	@echo
	@echo -e "$(SECTION_COLOR)▶ COMANDOS PRINCIPAIS$(RESET)"
	@echo -e "  $(CYAN)make setup$(RESET)          → Configura ambiente completo"
	@echo -e "  $(CYAN)make infra$(RESET)          → Configura infraestrutura"
	@echo
	@echo -e "$(SECTION_COLOR)▶ GERENCIAMENTO DE SUBMÓDULOS$(RESET)"
	@echo -e "  $(MAGENTA)make submodules$(RESET)    → Configura submódulos"
	@echo -e "  $(MAGENTA)make clean-lib-git$(RESET) → Limpa .git dos submódulos"
	@echo
	@echo -e "$(SECTION_COLOR)▶ LIMPEZA$(RESET)"
	@echo -e "  $(RED)make clean$(RESET)          → Limpa todo o ambiente"
	@echo
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(TITLE_COLOR)                 Documentação Completa                       $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════════════════════════╝$(RESET)"

# =============================================================================
# 7. COMANDOS DE LIMPEZA
# =============================================================================
clean-lib-git:
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(YELLOW)      Limpando .git dos Submódulos      $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"
	@rm -rf $(PACKAGES_DIR)/blockchain/smart-contracts/lib/*/.git || true
	@echo -e "$(GREEN)✓ Submódulos da lib limpos!$(RESET)"

clean: clean-lib-git
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(YELLOW)         Limpando Ambiente...           $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"
	@cd $(INFRA_DIR) && make infra-clean || true
	@git submodule deinit -f --all || true
	@rm -rf .git/modules/* || true
	@rm -rf $(PACKAGES_DIR)
	@mkdir -p $(PACKAGES_DIR)/web $(PACKAGES_DIR)/blockchain
	@echo -e "$(GREEN)✓ Ambiente limpo com sucesso!$(RESET)"

# =============================================================================
# 8. COMANDOS DE SUBMÓDULOS
# =============================================================================
submodules:
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(CYAN)      Configurando Submódulos...        $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"
	@git submodule init
	@echo -e "$(BLUE)➜ Clonando web-pannel-admin$(RESET)"
	@git submodule add -f $(WEB_ADMIN_REPO) $(PACKAGES_DIR)/web/pannel-admin || true
	@echo -e "$(BLUE)➜ Clonando marketplace$(RESET)"
	@git submodule add -f $(WEB_MARKETPLACE_REPO) $(PACKAGES_DIR)/web/marketplace || true
	@echo -e "$(BLUE)➜ Clonando blockchain-indexer$(RESET)"
	@git submodule add -f $(BLOCKCHAIN_INDEXER_REPO) $(PACKAGES_DIR)/blockchain/indexer || true
	@echo -e "$(BLUE)➜ Clonando smart-contracts$(RESET)"
	@git submodule add -f $(BLOCKCHAIN_CONTRACTS_REPO) $(PACKAGES_DIR)/blockchain/smart-contracts || true
	@git submodule update --init --recursive
	@echo -e "$(GREEN)✓ Submódulos configurados com sucesso!$(RESET)"

# =============================================================================
# 9. COMANDOS DE INFRAESTRUTURA
# =============================================================================
infra:
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(CYAN)     Configurando Infraestrutura...     $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"
	@cd $(INFRA_DIR) && make setup-env
	@cd $(INFRA_DIR) && make network-create
	@cd $(INFRA_DIR) && make infra-up
	@echo -e "$(GREEN)✓ Infraestrutura configurada com sucesso!$(RESET)"

# =============================================================================
# 10. SETUP COMPLETO
# =============================================================================
setup: clean submodules infra
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(GREEN)         Ambiente RWA Hub Pronto        $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"