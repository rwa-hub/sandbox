# =============================================================================
# RWA Hub Sandbox - Makefile
# =============================================================================
# Autor: RWA Hub Team
# Descrição: Makefile para gerenciamento do ambiente de desenvolvimento sandbox
# =============================================================================

# Cores e formatação
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m
RESET := \033[0m

# =============================================================================
# Variáveis de Configuração
# =============================================================================
INFRA_DIR := infrasctruture
PACKAGES_DIR := packages
CURRENT_DIR := $(shell pwd)

# Submódulos
SUBMODULES := web/pannel-admin web/marketplace blockchain/indexer blockchain/smart-contracts

# =============================================================================
# Mensagens
# =============================================================================
SETUP_MSG := "🚀 Configurando ambiente RWA Hub Sandbox..."
SUBMODULE_MSG := "📦 Gerenciando submódulos..."
SUCCESS_MSG := "✅ Operação concluída com sucesso!"
ERROR_MSG := "❌ Erro na operação!"

# =============================================================================
# Targets Principais
# =============================================================================
.PHONY: help setup clean status update install-all test-all

# Target padrão
.DEFAULT_GOAL := help

## Exibe ajuda sobre os comandos disponíveis
help:
	@echo "$(BOLD)RWA Hub Sandbox - Sistema de Desenvolvimento$(RESET)"
	@echo ""
	@echo "$(BOLD)Comandos Principais:$(RESET)"
	@echo "  $(CYAN)make setup$(RESET)        - Configura todo o ambiente (submódulos + infraestrutura)"
	@echo "  $(CYAN)make clean$(RESET)        - Limpa todo o ambiente"
	@echo "  $(CYAN)make status$(RESET)       - Mostra status de todos os componentes"
	@echo "  $(CYAN)make update$(RESET)       - Atualiza todos os submódulos"
	@echo ""
	@echo "$(BOLD)Gerenciamento de Submódulos:$(RESET)"
	@echo "  $(YELLOW)make submodule-init$(RESET)    - Inicializa submódulos"
	@echo "  $(YELLOW)make submodule-update$(RESET)  - Atualiza submódulos"
	@echo "  $(YELLOW)make submodule-clean$(RESET)   - Remove submódulos"
	@echo ""
	@echo "$(BOLD)Desenvolvimento:$(RESET)"
	@echo "  $(MAGENTA)make dev$(RESET)             - Inicia ambiente de desenvolvimento"
	@echo "  $(MAGENTA)make install-all$(RESET)     - Instala dependências em todos os projetos"
	@echo "  $(MAGENTA)make test-all$(RESET)        - Executa testes em todos os projetos"
	@echo ""
	@echo "$(BOLD)Infraestrutura:$(RESET)"
	@echo "  $(BLUE)make infra-up$(RESET)        - Inicia infraestrutura"
	@echo "  $(BLUE)make infra-down$(RESET)      - Para infraestrutura"
	@echo "  $(BLUE)make infra-status$(RESET)    - Status da infraestrutura"
	@echo ""
	@echo "$(BOLD)Commits e Push:$(RESET)"
	@echo "  $(GREEN)make commit-all$(RESET)     - Commit em todos os submódulos"
	@echo "  $(GREEN)make push-all$(RESET)       - Push em todos os submódulos"
	@echo ""

# =============================================================================
# Setup Inicial
# =============================================================================
## Configura todo o ambiente de desenvolvimento
setup: submodule-init install-all infra-setup
	@echo "$(GREEN)$(SETUP_MSG)$(RESET)"
	@echo "$(GREEN)$(SUCCESS_MSG)$(RESET)"

## Configura a infraestrutura
infra-setup:
	@echo "$(CYAN)🔧 Configurando infraestrutura...$(RESET)"
	@cd $(INFRA_DIR) && make setup-env
	@cd $(INFRA_DIR) && make network-create

# =============================================================================
# Gerenciamento de Submódulos
# =============================================================================
## Inicializa os submódulos
submodule-init:
	@echo "$(CYAN)📦 Inicializando submódulos...$(RESET)"
	@git submodule init
	@git submodule update --recursive --remote
	@for submodule in $(SUBMODULES); do \
		echo "$(CYAN)➜ Configurando $$submodule$(RESET)"; \
		git submodule add -f https://github.com/rwa-hub/$$submodule packages/$$submodule 2>/dev/null || true; \
	done

## Atualiza os submódulos
submodule-update:
	@echo "$(CYAN)📦 Atualizando submódulos...$(RESET)"
	@git submodule foreach git pull origin main

## Remove os submódulos
submodule-clean:
	@echo "$(YELLOW)🧹 Removendo submódulos...$(RESET)"
	@git submodule deinit -f --all
	@rm -rf .git/modules/*
	@for submodule in $(SUBMODULES); do \
		git rm -f packages/$$submodule 2>/dev/null || true; \
	done

# =============================================================================
# Desenvolvimento
# =============================================================================
## Inicia ambiente de desenvolvimento
dev: setup
	@echo "$(CYAN)🚀 Iniciando ambiente de desenvolvimento...$(RESET)"
	@cd $(INFRA_DIR) && make dev

## Instala dependências em todos os projetos
install-all:
	@echo "$(CYAN)📦 Instalando dependências...$(RESET)"
	@for submodule in $(SUBMODULES); do \
		if [ -f "packages/$$submodule/package.json" ]; then \
			echo "$(CYAN)➜ Instalando dependências em $$submodule$(RESET)"; \
			cd packages/$$submodule && npm install && cd $(CURRENT_DIR); \
		fi \
	done

## Executa testes em todos os projetos
test-all:
	@echo "$(CYAN)🧪 Executando testes...$(RESET)"
	@for submodule in $(SUBMODULES); do \
		if [ -f "packages/$$submodule/package.json" ]; then \
			echo "$(CYAN)➜ Testando $$submodule$(RESET)"; \
			cd packages/$$submodule && npm test && cd $(CURRENT_DIR); \
		fi \
	done

# =============================================================================
# Infraestrutura
# =============================================================================
## Inicia a infraestrutura
infra-up:
	@cd $(INFRA_DIR) && make infra-up

## Para a infraestrutura
infra-down:
	@cd $(INFRA_DIR) && make infra-down

## Mostra status da infraestrutura
infra-status:
	@cd $(INFRA_DIR) && make infra-status

# =============================================================================
# Git Operations
# =============================================================================
## Commit em todos os submódulos
commit-all:
	@echo "$(CYAN)💾 Realizando commit em todos os submódulos...$(RESET)"
	@echo "Digite a mensagem do commit:"
	@read msg; \
	for submodule in $(SUBMODULES); do \
		if [ -d "packages/$$submodule/.git" ]; then \
			echo "$(CYAN)➜ Commit em $$submodule$(RESET)"; \
			cd packages/$$submodule && \
			git add . && \
			git commit -m "$$msg" && \
			cd $(CURRENT_DIR); \
		fi \
	done; \
	git add . && git commit -m "$$msg"

## Push em todos os submódulos
push-all:
	@echo "$(CYAN)📤 Realizando push em todos os submódulos...$(RESET)"
	@for submodule in $(SUBMODULES); do \
		if [ -d "packages/$$submodule/.git" ]; then \
			echo "$(CYAN)➜ Push em $$submodule$(RESET)"; \
			cd packages/$$submodule && \
			git push origin main && \
			cd $(CURRENT_DIR); \
		fi \
	done
	@git push origin main

# =============================================================================
# Utilitários
# =============================================================================
## Limpa todo o ambiente
clean: submodule-clean infra-down
	@echo "$(YELLOW)🧹 Limpando ambiente...$(RESET)"
	@cd $(INFRA_DIR) && make infra-clean
	@echo "$(GREEN)✨ Ambiente limpo com sucesso!$(RESET)"

## Mostra status de todos os componentes
status:
	@echo "$(CYAN)📊 Status dos Submódulos:$(RESET)"
	@git submodule status
	@echo "\n$(CYAN)📊 Status da Infraestrutura:$(RESET)"
	@cd $(INFRA_DIR) && make infra-status 