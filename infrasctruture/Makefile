# Cores e formatação
BOLD := \033[1m
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
MAGENTA := \033[35m
CYAN := \033[36m
RESET := \033[0m

# Variáveis do projeto
DOCKER_COMPOSE := docker-compose -f docker-compose.yml
DOCKER_COMPOSE_INFRA := $(DOCKER_COMPOSE) -f db/docker-compose.yml -f rabbitMQ/docker-compose.yml

# Mensagens
INFRA_UP_MSG := "🚀 Iniciando infraestrutura completa..."
INFRA_DOWN_MSG := "🔽 Parando toda infraestrutura..."
INFRA_BUILD_MSG := "🏗️  Construindo imagens Docker..."
INFRA_LOGS_MSG := "📋 Exibindo logs dos containers..."
INFRA_STATUS_MSG := "📊 Status dos serviços..."
INFRA_CLEAN_MSG := "🧹 Limpando volumes e containers..."
INFRA_PRUNE_MSG := "🗑️  Removendo recursos não utilizados..."
NETWORK_CREATE_MSG := "🌐 Criando rede rwa-hub-network..."
NETWORK_REMOVE_MSG := "🌐 Removendo rede rwa-hub-network..."
SETUP_ENV_MSG := "🔧 Configurando arquivos .env..."

# Define todos os targets como PHONY
.PHONY: help infra-up infra-down infra-build infra-logs infra-status infra-clean infra-prune network-create network-remove dev ps logs-monitor logs-mongodb logs-rabbitmq setup-env

# Target padrão mostra a ajuda
.DEFAULT_GOAL := help

# Ajuda
help:
	@echo "$(BOLD)🛠️  RWA Hub Infrastructure - Comandos Disponíveis:$(RESET)"
	@echo ""
	@echo "$(BOLD)Comandos Principais:$(RESET)"
	@echo "  $(CYAN)make setup-env$(RESET)       - Configura arquivos .env iniciais"
	@echo "  $(CYAN)make dev$(RESET)             - Inicia ambiente de desenvolvimento completo"
	@echo "  $(CYAN)make infra-up$(RESET)        - Inicia todos os serviços"
	@echo "  $(CYAN)make infra-down$(RESET)      - Para todos os serviços"
	@echo "  $(CYAN)make infra-build$(RESET)     - Constrói todas as imagens"
	@echo "  $(CYAN)make ps$(RESET)              - Lista todos os containers rodando"
	@echo ""
	@echo "$(BOLD)Comandos de Monitoramento:$(RESET)"
	@echo "  $(YELLOW)make infra-logs$(RESET)      - Exibe logs de todos os serviços"
	@echo "  $(YELLOW)make logs-monitor$(RESET)    - Logs do serviço monitor"
	@echo "  $(YELLOW)make logs-mongodb$(RESET)    - Logs do MongoDB"
	@echo "  $(YELLOW)make logs-rabbitmq$(RESET)   - Logs do RabbitMQ"
	@echo "  $(YELLOW)make infra-status$(RESET)    - Mostra status dos serviços"
	@echo ""
	@echo "$(BOLD)Comandos de Manutenção:$(RESET)"
	@echo "  $(MAGENTA)make infra-clean$(RESET)    - Remove containers e volumes"
	@echo "  $(MAGENTA)make infra-prune$(RESET)    - Limpa recursos não utilizados"
	@echo "  $(MAGENTA)make infra-restart$(RESET)  - Reinicia todos os serviços"
	@echo ""
	@echo "$(BOLD)Comandos de Rede:$(RESET)"
	@echo "  $(BLUE)make network-create$(RESET)  - Cria rede Docker"
	@echo "  $(BLUE)make network-remove$(RESET)  - Remove rede Docker"
	@echo ""

# Configura arquivos .env
setup-env:
	@echo "$(CYAN)$(SETUP_ENV_MSG)$(RESET)"
	@mkdir -p ./db
	@if [ ! -f "./db/.env" ]; then \
		echo "Criando ./db/.env..."; \
		echo "# MongoDB Configuration" > ./db/.env; \
		echo "MONGO_USER=admin" >> ./db/.env; \
		echo "MONGO_PASSWORD=password123" >> ./db/.env; \
		echo "MONGO_DATABASE=rwa_hub" >> ./db/.env; \
		echo "MONGO_PORT=27017" >> ./db/.env; \
		echo "MONGO_MEMORY_LIMIT=2G" >> ./db/.env; \
		echo "MONGO_MEMORY_REQUEST=1G" >> ./db/.env; \
	fi
	@mkdir -p ./rabbitMQ
	@if [ ! -f "./rabbitMQ/.env" ]; then \
		echo "Criando ./rabbitMQ/.env..."; \
		echo "# RabbitMQ Configuration" > ./rabbitMQ/.env; \
		echo "RABBITMQ_USER=guest" >> ./rabbitMQ/.env; \
		echo "RABBITMQ_PASSWORD=guest" >> ./rabbitMQ/.env; \
		echo "RABBITMQ_DEFAULT_VHOST=/" >> ./rabbitMQ/.env; \
		echo "RABBITMQ_PORT=5672" >> ./rabbitMQ/.env; \
		echo "RABBITMQ_MANAGEMENT_PORT=15672" >> ./rabbitMQ/.env; \
	fi
	@mkdir -p ../packages/blockchain/monitor
	@if [ ! -f "../packages/blockchain/monitor/.env" ]; then \
		echo "Criando ../packages/blockchain/monitor/.env..."; \
		echo "RPC_URL=ws://host.docker.internal:8546" > ../packages/blockchain/monitor/.env; \
		echo "# App Configuration" >> ../packages/blockchain/monitor/.env; \
		echo "APP_ENV=development" >> ../packages/blockchain/monitor/.env; \
		echo "APP_PORT=8082" >> ../packages/blockchain/monitor/.env; \
		echo "" >> ../packages/blockchain/monitor/.env; \
		echo "# MongoDB Connection" >> ../packages/blockchain/monitor/.env; \
		echo "MONGO_URI=mongodb://admin:password123@rwa-mongodb:27017/rwa_hub?authSource=admin" >> ../packages/blockchain/monitor/.env; \
		echo "" >> ../packages/blockchain/monitor/.env; \
		echo "# RabbitMQ Connection" >> ../packages/blockchain/monitor/.env; \
		echo "RABBITMQ_URI=amqp://guest:guest@rwa-rabbitmq:5672/" >> ../packages/blockchain/monitor/.env; \
		echo "" >> ../packages/blockchain/monitor/.env; \
		echo "CONTRACT_COMPLIANCE=0x9F035Be9853eb3Fc10155361fda197C159eFDD09" >> ../packages/blockchain/monitor/.env; \
		echo "CONTRACT_MODULAR_COMPLIANCE=0xf935973e9f884c66e6E3ce681344064e565e0250" >> ../packages/blockchain/monitor/.env; \
		echo "CONTRACT_IDENT_REGISTRY_STORAGE=0xE777fAf8240196bA99c6e2a89E8F24B75C52Eb2a" >> ../packages/blockchain/monitor/.env; \
		echo "CONTRACT_REGISTRY_MD=0x9e699d6c7ccf183F0B09675A9E867d1486EEF85b" >> ../packages/blockchain/monitor/.env; \
		echo "CONTRACT_IDENTITY_REGISTRY=0x9e699d6c7ccf183F0B09675A9E867d1486EEF85b" >> ../packages/blockchain/monitor/.env; \
		echo "CONTRACT_TOKEN_RWA=0x66D5dD63fC9655a36B0bAe3BA619B7Cc2eCd6507" >> ../packages/blockchain/monitor/.env; \
		echo "" >> ../packages/blockchain/monitor/.env; \
		echo "RABBITMQ_QUEUE_NAME=monitor-events" >> ../packages/blockchain/monitor/.env; \
	fi
	@echo "$(GREEN)✓ Arquivos .env configurados com sucesso!$(RESET)"

# Cria a rede Docker
network-create:
	@echo "$(CYAN)$(NETWORK_CREATE_MSG)$(RESET)"
	@docker network rm rwa-hub-network 2>/dev/null || true
	@docker network create --driver bridge \
		--attachable \
		--label com.docker.compose.network=rwa-hub-network \
		--label com.docker.compose.project=rwa-hub \
		rwa-hub-network 2>/dev/null || true
	@echo "$(GREEN)✓ Rede criada ou já existente!$(RESET)"

# Remove a rede Docker
network-remove:
	@echo "$(YELLOW)$(NETWORK_REMOVE_MSG)$(RESET)"
	@docker network rm rwa-hub-network 2>/dev/null || true
	@echo "$(GREEN)✓ Rede removida!$(RESET)"

# Comando para reiniciar a rede
network-restart: network-remove network-create
	@echo "$(GREEN)✓ Rede reiniciada com sucesso!$(RESET)"

# Inicia todos os serviços
infra-up: network-create
	@echo "$(CYAN)$(INFRA_UP_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) up -d
	@echo "$(GREEN)✓ Infraestrutura iniciada com sucesso!$(RESET)"
	@make ps

# Para todos os serviços
infra-down:
	@echo "$(YELLOW)$(INFRA_DOWN_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) down
	@echo "$(GREEN)✓ Infraestrutura parada com sucesso!$(RESET)"

# Constrói todas as imagens
infra-build:
	@echo "$(CYAN)$(INFRA_BUILD_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) build
	@echo "$(GREEN)✓ Build concluído com sucesso!$(RESET)"

# Exibe logs de todos os serviços
infra-logs:
	@echo "$(CYAN)$(INFRA_LOGS_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) logs -f

# Logs específicos por serviço
logs-monitor:
	@echo "$(CYAN)📋 Logs do Monitor:$(RESET)"
	@$(DOCKER_COMPOSE) logs -f rwa-blockchain-monitor

logs-mongodb:
	@echo "$(CYAN)📋 Logs do MongoDB:$(RESET)"
	@$(DOCKER_COMPOSE) logs -f rwa-mongodb

logs-rabbitmq:
	@echo "$(CYAN)📋 Logs do RabbitMQ:$(RESET)"
	@$(DOCKER_COMPOSE) logs -f rwa-rabbitmq

# Mostra status dos serviços
infra-status:
	@echo "$(CYAN)$(INFRA_STATUS_MSG)$(RESET)"
	@echo ""
	@echo "$(BOLD)Containers:$(RESET)"
	@$(DOCKER_COMPOSE) ps
	@echo ""
	@echo "$(BOLD)Volumes:$(RESET)"
	@docker volume ls | grep "rwa-"
	@echo ""
	@echo "$(BOLD)Networks:$(RESET)"
	@docker network ls | grep "rwa-"
	@echo ""
	@echo "$(BOLD)Portas em uso:$(RESET)"
	@docker ps --format "table {{.Names}}\t{{.Ports}}" | grep "rwa-"

# Lista containers ativos
ps:
	@$(DOCKER_COMPOSE) ps

# Remove containers e volumes
infra-clean:
	@echo "$(YELLOW)$(INFRA_CLEAN_MSG)$(RESET)"
	@$(DOCKER_COMPOSE) down -v
	@echo "$(GREEN)✓ Limpeza concluída!$(RESET)"

# Limpa recursos não utilizados
infra-prune:
	@echo "$(YELLOW)$(INFRA_PRUNE_MSG)$(RESET)"
	@docker system prune -f
	@docker volume prune -f
	@echo "$(GREEN)✓ Limpeza de recursos concluída!$(RESET)"

# Comando principal para desenvolvimento
dev: setup-env network-restart infra-build infra-up
	@echo "$(GREEN)✓ Ambiente de desenvolvimento pronto!$(RESET)"
	@echo "$(CYAN)📝 Use 'make infra-logs' para ver os logs$(RESET)"
	@echo "$(CYAN)📊 Use 'make infra-status' para ver o status$(RESET)"
	@echo ""
	@make ps

# Comando para reiniciar todos os serviços
infra-restart: infra-down infra-up
	@echo "$(GREEN)✓ Serviços reiniciados com sucesso!$(RESET)" 