# =============================================================================
# RWA Hub infrastructure Makefile
# =============================================================================
# Autor: RWA Hub Team
# Data: 2024
# Descrição: Makefile para gerenciamento da infraestrutura do projeto RWA Hub
# =============================================================================

# =============================================================================
# 1. CONFIGURAÇÕES DE CORES E FORMATAÇÃO
# =============================================================================
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m
RESET := \033[0m

# =============================================================================
# 2. VARIÁVEIS DE AMBIENTE E CAMINHOS
# =============================================================================
# --- 2.1 Caminhos dos pacotes Node.js ---
TREX_PATH := ../packages/blockchain/smart-contracts/lib/T-REX
MARKETPLACE_PATH := ../packages/web/marketplace
PANEL_ADMIN_PATH := ../packages/web/pannel-admin
PACKAGES := $(TREX_PATH) $(MARKETPLACE_PATH) $(PANEL_ADMIN_PATH)

# --- 2.2 Configurações Docker ---
DOCKER_COMPOSE := docker-compose -f docker-compose.yml
DOCKER_COMPOSE_INFRA := $(DOCKER_COMPOSE) -f db/docker-compose.yml -f rabbitMQ/docker-compose.yml

# --- 2.3 Ferramentas ---
NPM := npm

# =============================================================================
# 3. MENSAGENS DO SISTEMA
# =============================================================================
# --- 3.1 Mensagens de Infraestrutura ---
INFRA_UP_MSG := "🚀 Iniciando infraestrutura completa..."
INFRA_DOWN_MSG := "🔽 Parando toda infraestrutura..."
INFRA_BUILD_MSG := "🏗️  Construindo imagens Docker..."
INFRA_LOGS_MSG := "📋 Exibindo logs dos containers..."
INFRA_STATUS_MSG := "📊 Status dos serviços..."
INFRA_CLEAN_MSG := "🧹 Limpando volumes e containers..."
INFRA_PRUNE_MSG := "🗑️  Removendo recursos não utilizados..."

# --- 3.2 Mensagens de Rede ---
NETWORK_CREATE_MSG := "🌐 Criando rede rwa-hub-network..."
NETWORK_REMOVE_MSG := "🌐 Removendo rede rwa-hub-network..."

# --- 3.3 Mensagens de Setup ---
SETUP_ENV_MSG := "🔧 Configurando arquivos .env..."
SETUP_DEPS_MSG := "📦 Instalando dependências Node.js..."

# =============================================================================
# 4. DEFINIÇÃO DE TARGETS
# =============================================================================
.PHONY: help infra-up infra-down infra-build infra-logs infra-status infra-clean \
        infra-prune network-create network-remove dev ps logs-monitor \
        logs-mongodb logs-rabbitmq setup-env setup-deps install-deps clean-deps

.DEFAULT_GOAL := help

# =============================================================================
# 5. COMANDOS DE AJUDA
# =============================================================================
help:
	@echo "$(BOLD)╔════════════════════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOLD)║                   RWA Hub infrastructure                   ║$(RESET)"
	@echo "$(BOLD)╚════════════════════════════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "$(BOLD)▶ COMANDOS PRINCIPAIS$(RESET)"
	@echo "  $(CYAN)make setup-env$(RESET)       → Configura arquivos .env iniciais"
	@echo "  $(CYAN)make setup-deps$(RESET)      → Configura todas as dependências Node.js"
	@echo "  $(CYAN)make dev$(RESET)             → Inicia ambiente de desenvolvimento completo"
	@echo "  $(CYAN)make infra-up$(RESET)        → Inicia todos os serviços"
	@echo "  $(CYAN)make infra-down$(RESET)      → Para todos os serviços"
	@echo ""
	@echo "$(BOLD)▶ GERENCIAMENTO DE DEPENDÊNCIAS$(RESET)"
	@echo "  $(MAGENTA)make install-deps$(RESET)   → Instala dependências de todos os pacotes"
	@echo "  $(MAGENTA)make clean-deps$(RESET)     → Remove node_modules de todos os pacotes"
	@echo ""
	@echo "$(BOLD)▶ MONITORAMENTO$(RESET)"
	@echo "  $(YELLOW)make infra-logs$(RESET)      → Exibe logs de todos os serviços"
	@echo "  $(YELLOW)make logs-monitor$(RESET)    → Logs do serviço monitor"
	@echo "  $(YELLOW)make logs-mongodb$(RESET)    → Logs do MongoDB"
	@echo "  $(YELLOW)make logs-rabbitmq$(RESET)   → Logs do RabbitMQ"
	@echo ""
	@echo "$(BOLD)▶ MANUTENÇÃO$(RESET)"
	@echo "  $(RED)make infra-clean$(RESET)     → Remove containers e volumes"
	@echo "  $(RED)make infra-prune$(RESET)     → Limpa recursos não utilizados"
	@echo "  $(RED)make infra-restart$(RESET)   → Reinicia todos os serviços"
	@echo ""
	@echo "$(BOLD)▶ REDE$(RESET)"
	@echo "  $(BLUE)make network-create$(RESET)  → Cria rede Docker"
	@echo "  $(BLUE)make network-remove$(RESET)  → Remove rede Docker"
	@echo ""
	@echo "$(BOLD)╔════════════════════════════════════════════════════════════╗$(RESET)"
	@echo "$(BOLD)║                    Documentação Completa                    ║$(RESET)"
	@echo "$(BOLD)╚════════════════════════════════════════════════════════════╝$(RESET)"

# =============================================================================
# 6. COMANDOS DE DEPENDÊNCIAS
# =============================================================================
setup-deps: install-deps
	@echo "$(GREEN)✓ Todas as dependências foram instaladas com sucesso!$(RESET)"

install-deps:
	@echo "$(CYAN)╔════════════════════════════════════════╗$(RESET)"
	@echo "$(CYAN)║      Instalando Dependências...        ║$(RESET)"
	@echo "$(CYAN)╚════════════════════════════════════════╝$(RESET)"
	@for dir in $(PACKAGES); do \
		echo "$(CYAN)📦 Instalando em $$dir...$(RESET)"; \
		cd $$dir && $(NPM) install && cd - > /dev/null; \
		echo "$(GREEN)✓ $$dir instalado com sucesso!$(RESET)"; \
	done

clean-deps:
	@echo "$(YELLOW)╔════════════════════════════════════════╗$(RESET)"
	@echo "$(YELLOW)║      Removendo node_modules...         ║$(RESET)"
	@echo "$(YELLOW)╚════════════════════════════════════════╝$(RESET)"
	@for dir in $(PACKAGES); do \
		echo "$(YELLOW)🧹 Limpando $$dir...$(RESET)"; \
		rm -rf $$dir/node_modules; \
		echo "$(GREEN)✓ $$dir limpo com sucesso!$(RESET)"; \
	done
	@echo "$(GREEN)✓ Todas as dependências foram removidas!$(RESET)"

# =============================================================================
# 7. COMANDOS DE INFRAESTRUTURA
# =============================================================================
infra-up: network-create
	@echo "$(CYAN)$(INFRA_UP_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)✓ Infraestrutura iniciada com sucesso!$(RESET)"
	@make ps

infra-down:
	@echo "$(YELLOW)$(INFRA_DOWN_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)✓ Infraestrutura parada com sucesso!$(RESET)"

infra-build:
	@echo "$(CYAN)$(INFRA_BUILD_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) build
	@echo "$(GREEN)✓ Build concluído com sucesso!$(RESET)"

# =============================================================================
# 8. COMANDOS DE MONITORAMENTO
# =============================================================================
infra-logs:
	@echo "$(CYAN)$(INFRA_LOGS_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) logs -f

logs-monitor:
	@echo "$(CYAN)📋 Logs do Monitor:$(RESET)"
	@$(DOCKER_COMPOSE) logs -f rwa-blockchain-indexer

logs-mongodb:
	@echo "$(CYAN)📋 Logs do MongoDB:$(RESET)"
	@$(DOCKER_COMPOSE) logs -f rwa-mongodb

logs-rabbitmq:
	@echo "$(CYAN)📋 Logs do RabbitMQ:$(RESET)"
	@$(DOCKER_COMPOSE) logs -f rwa-rabbitmq

# =============================================================================
# 9. COMANDOS DE REDE
# =============================================================================
network-create:
	@echo "$(CYAN)$(NETWORK_CREATE_MSG)$(RESET)"
	@docker network rm rwa-hub-network 2>/dev/null || true
	@docker network create --driver bridge \
		--attachable \
		--label com.docker.compose.network=rwa-hub-network \
		--label com.docker.compose.project=rwa-hub \
		rwa-hub-network 2>/dev/null || true
	@echo "$(GREEN)✓ Rede criada ou já existente!$(RESET)"

network-remove:
	@echo "$(YELLOW)$(NETWORK_REMOVE_MSG)$(RESET)"
	@docker network rm rwa-hub-network 2>/dev/null || true
	@echo "$(GREEN)✓ Rede removida!$(RESET)"

network-restart: network-remove network-create
	@echo "$(GREEN)✓ Rede reiniciada com sucesso!$(RESET)"

# =============================================================================
# 10. COMANDOS DE DESENVOLVIMENTO
# =============================================================================
dev: setup-env setup-deps network-restart infra-build infra-up
	@echo "$(GREEN)╔════════════════════════════════════════╗$(RESET)"
	@echo "$(GREEN)║   Ambiente de Desenvolvimento Pronto   ║$(RESET)"
	@echo "$(GREEN)╚════════════════════════════════════════╝$(RESET)"
	@echo ""
	@echo "$(CYAN)📝 Use 'make infra-logs' para ver os logs$(RESET)"
	@echo "$(CYAN)📊 Use 'make infra-status' para ver o status$(RESET)"
	@echo ""
	@make ps

# =============================================================================
# 11. COMANDOS DE MANUTENÇÃO
# =============================================================================
infra-clean:
	@echo "$(YELLOW)$(INFRA_CLEAN_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) down -v
	@echo "$(GREEN)✓ Limpeza concluída!$(RESET)"

infra-prune:
	@echo "$(YELLOW)$(INFRA_PRUNE_MSG)$(RESET)"
	@docker system prune -f
	@docker volume prune -f
	@echo "$(GREEN)✓ Limpeza de recursos concluída!$(RESET)"

infra-restart: infra-down infra-up
	@echo "$(GREEN)✓ Serviços reiniciados com sucesso!$(RESET)" 