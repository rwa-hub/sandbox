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
INFRA_DIR := infrastructure
INDEXER_DIR := $(PACKAGES_DIR)/blockchain/indexer
DB_DIR := $(INFRA_DIR)/db
RABBITMQ_DIR := $(INFRA_DIR)/rabbitMQ

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
.PHONY: help clean clean-lib-git submodules infra setup create-indexer create-db-env create-rabbitmq-env

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
	@rm -f $(DB_DIR)/.env || true
	@rm -f $(RABBITMQ_DIR)/.env || true
	@rm -f $(INDEXER_DIR)/.env || true
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
create-indexer:
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(CYAN)     Configurando Indexer...            $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"
	@mkdir -p $(INDEXER_DIR)
	@if [ ! -f "$(INDEXER_DIR)/.env" ]; then \
		echo -e "$(BLUE)➜ Criando arquivo .env do indexer$(RESET)"; \
		echo "RPC_URL=ws://host.docker.internal:8546" > $(INDEXER_DIR)/.env; \
		echo "" >> $(INDEXER_DIR)/.env; \
		echo "# App Configuration" >> $(INDEXER_DIR)/.env; \
		echo "APP_ENV=development" >> $(INDEXER_DIR)/.env; \
		echo "APP_PORT=8082" >> $(INDEXER_DIR)/.env; \
		echo "" >> $(INDEXER_DIR)/.env; \
		echo "# MongoDB Connection" >> $(INDEXER_DIR)/.env; \
		echo "MONGO_URI=mongodb://admin:password123@rwa-mongodb:27017/rwa_hub?authSource=admin" >> $(INDEXER_DIR)/.env; \
		echo "" >> $(INDEXER_DIR)/.env; \
		echo "# RabbitMQ Connection" >> $(INDEXER_DIR)/.env; \
		echo "RABBITMQ_URI=amqp://guest:guest@rwa-rabbitmq:5672/" >> $(INDEXER_DIR)/.env; \
		echo "RABBITMQ_HOST=rwa-rabbitmq" >> $(INDEXER_DIR)/.env; \
		echo "RABBITMQ_PORT=5672" >> $(INDEXER_DIR)/.env; \
		echo "RABBITMQ_USER=guest" >> $(INDEXER_DIR)/.env; \
		echo "RABBITMQ_PASSWORD=guest" >> $(INDEXER_DIR)/.env; \
		echo "RABBITMQ_QUEUE_NAME=monitor-events" >> $(INDEXER_DIR)/.env; \
		echo "" >> $(INDEXER_DIR)/.env; \
		echo "# Smart Contracts" >> $(INDEXER_DIR)/.env; \
		echo "CONTRACT_COMPLIANCE=0x9F035Be9853eb3Fc10155361fda197C159eFDD09" >> $(INDEXER_DIR)/.env; \
		echo "CONTRACT_MODULAR_COMPLIANCE=0xf935973e9f884c66e6E3ce681344064e565e0250" >> $(INDEXER_DIR)/.env; \
		echo "CONTRACT_IDENT_REGISTRY_STORAGE=0xE777fAf8240196bA99c6e2a89E8F24B75C52Eb2a" >> $(INDEXER_DIR)/.env; \
		echo "CONTRACT_REGISTRY_MD=0x9e699d6c7ccf183F0B09675A9E867d1486EEF85b" >> $(INDEXER_DIR)/.env; \
		echo "CONTRACT_IDENTITY_REGISTRY=0x9e699d6c7ccf183F0B09675A9E867d1486EEF85b" >> $(INDEXER_DIR)/.env; \
		echo "CONTRACT_TOKEN_RWA=0x66D5dD63fC9655a36B0bAe3BA619B7Cc2eCd6507" >> $(INDEXER_DIR)/.env; \
		echo -e "$(GREEN)✓ Arquivo .env do indexer criado com sucesso!$(RESET)"; \
	fi

create-db-env:
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(CYAN)     Configurando MongoDB...            $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"
	@mkdir -p $(DB_DIR)
	@if [ ! -f "$(DB_DIR)/.env" ]; then \
		echo -e "$(BLUE)➜ Criando arquivo .env do MongoDB$(RESET)"; \
		echo "# MongoDB Configuration" > $(DB_DIR)/.env; \
		echo "MONGO_USER=admin" >> $(DB_DIR)/.env; \
		echo "MONGO_PASSWORD=password123" >> $(DB_DIR)/.env; \
		echo "MONGO_DATABASE=rwa_hub" >> $(DB_DIR)/.env; \
		echo "MONGO_PORT=27017" >> $(DB_DIR)/.env; \
		echo "" >> $(DB_DIR)/.env; \
		echo "# MongoDB Memory Limits" >> $(DB_DIR)/.env; \
		echo "MONGO_MEMORY_LIMIT=2G" >> $(DB_DIR)/.env; \
		echo "MONGO_MEMORY_REQUEST=1G" >> $(DB_DIR)/.env; \
		echo -e "$(GREEN)✓ Arquivo .env do MongoDB criado com sucesso!$(RESET)"; \
	fi

create-rabbitmq-env:
	@echo -e "$(BORDER_COLOR)╔════════════════════════════════════════╗$(RESET)"
	@echo -e "$(BORDER_COLOR)║$(RESET)$(CYAN)     Configurando RabbitMQ...           $(RESET)$(BORDER_COLOR)║$(RESET)"
	@echo -e "$(BORDER_COLOR)╚════════════════════════════════════════╝$(RESET)"
	@mkdir -p $(RABBITMQ_DIR)
	@if [ ! -f "$(RABBITMQ_DIR)/.env" ]; then \
		echo -e "$(BLUE)➜ Criando arquivo .env do RabbitMQ$(RESET)"; \
		echo "# RabbitMQ Configuration" > $(RABBITMQ_DIR)/.env; \
		echo "RABBITMQ_USER=guest" >> $(RABBITMQ_DIR)/.env; \
		echo "RABBITMQ_PASSWORD=guest" >> $(RABBITMQ_DIR)/.env; \
		echo "RABBITMQ_DEFAULT_VHOST=/" >> $(RABBITMQ_DIR)/.env; \
		echo "RABBITMQ_PORT=5672" >> $(RABBITMQ_DIR)/.env; \
		echo "RABBITMQ_MANAGEMENT_PORT=15672" >> $(RABBITMQ_DIR)/.env; \
		echo -e "$(GREEN)✓ Arquivo .env do RabbitMQ criado com sucesso!$(RESET)"; \
	fi

infra: create-indexer create-db-env create-rabbitmq-env
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