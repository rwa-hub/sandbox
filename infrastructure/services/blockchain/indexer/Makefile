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
PROJECT_ROOT := ../../../../packages/blockchain/indexer
DOCKER_COMPOSE := docker-compose -f docker-compose.yml

# Mensagens
DOCKER_UP_MSG := "🚀 Iniciando containers em modo detached..."
DOCKER_DOWN_MSG := "🔽 Parando todos os containers..."
DOCKER_BUILD_MSG := "🏗️  Construindo imagens Docker..."
DOCKER_LOGS_MSG := "📋 Exibindo logs dos containers..."
BUILD_MSG := "🔨 Compilando o projeto..."
TEST_MSG := "🧪 Executando testes..."
CLEAN_MSG := "🧹 Limpando arquivos gerados..."
DEPS_MSG := "📦 Instalando dependências..."
UPDATE_MSG := "⬆️  Atualizando dependências..."
LINT_MSG := "🔍 Verificando código..."

# Define todos os targets como PHONY
.PHONY: help all build test clean deps docker-* dev lint update-deps

# Target padrão mostra a ajuda
.DEFAULT_GOAL := help

# Ajuda
help:
	@echo "$(BOLD)🛠️  Monitor Indexer Service - Comandos Disponíveis:$(RESET)"
	@echo ""
	@echo "$(BOLD)Comandos de Desenvolvimento:$(RESET)"
	@echo "  $(CYAN)make dev$(RESET)          - Inicia ambiente de desenvolvimento completo"
	@echo "  $(CYAN)make build$(RESET)        - Compila o projeto"
	@echo "  $(CYAN)make test$(RESET)         - Executa os testes"
	@echo "  $(CYAN)make lint$(RESET)         - Executa linters e verificações"
	@echo ""
	@echo "$(BOLD)Comandos Docker:$(RESET)"
	@echo "  $(YELLOW)make docker-up$(RESET)     - Inicia os containers"
	@echo "  $(YELLOW)make docker-down$(RESET)   - Para os containers"
	@echo "  $(YELLOW)make docker-build$(RESET)  - Constrói as imagens"
	@echo "  $(YELLOW)make docker-logs$(RESET)   - Exibe logs dos containers"
	@echo "  $(YELLOW)make docker-restart$(RESET)- Reinicia os containers"
	@echo ""
	@echo "$(BOLD)Comandos de Manutenção:$(RESET)"
	@echo "  $(MAGENTA)make deps$(RESET)         - Instala dependências"
	@echo "  $(MAGENTA)make update-deps$(RESET)  - Atualiza dependências"
	@echo "  $(MAGENTA)make clean$(RESET)        - Remove arquivos gerados"
	@echo ""

# Instala todas as dependências do projeto
deps:
	@echo "$(CYAN)$(DEPS_MSG)$(RESET)"
	@cd $(PROJECT_ROOT) && go mod download
	@cd $(PROJECT_ROOT) && go mod tidy
	@echo "$(GREEN)✓ Dependências instaladas com sucesso!$(RESET)"

# Constrói o projeto
build:
	@echo "$(CYAN)$(BUILD_MSG)$(RESET)"
	@cd $(PROJECT_ROOT) && go build -o monitor-service cmd/main.go
	@echo "$(GREEN)✓ Build realizado com sucesso!$(RESET)"

# Executa os testes
test:
	@echo "$(CYAN)$(TEST_MSG)$(RESET)"
	@cd $(PROJECT_ROOT) && go test ./... -v
	@echo "$(GREEN)✓ Testes concluídos!$(RESET)"

# Limpa os arquivos gerados
clean:
	@echo "$(YELLOW)$(CLEAN_MSG)$(RESET)"
	@cd $(PROJECT_ROOT) && rm -f monitor-service
	@cd $(PROJECT_ROOT) && go clean
	@echo "$(GREEN)✓ Limpeza concluída!$(RESET)"

# Verifica o código
lint:
	@echo "$(CYAN)$(LINT_MSG)$(RESET)"
	@cd $(PROJECT_ROOT) && go vet ./...
	@cd $(PROJECT_ROOT) && golangci-lint run
	@echo "$(GREEN)✓ Verificação de código concluída!$(RESET)"

# Atualiza todas as dependências
update-deps:
	@echo "$(CYAN)$(UPDATE_MSG)$(RESET)"
	@cd $(PROJECT_ROOT) && go get -u all
	@cd $(PROJECT_ROOT) && go mod tidy
	@echo "$(GREEN)✓ Dependências atualizadas com sucesso!$(RESET)"

# Comandos Docker
docker-up:
	@echo "$(CYAN)$(DOCKER_UP_MSG)$(RESET)"
	@cd .. && docker-compose up -d
	@echo "$(GREEN)✓ Containers iniciados com sucesso!$(RESET)"

docker-down:
	@echo "$(YELLOW)$(DOCKER_DOWN_MSG)$(RESET)"
	@cd .. && docker-compose down
	@echo "$(GREEN)✓ Containers parados com sucesso!$(RESET)"

docker-build:
	@echo "$(CYAN)$(DOCKER_BUILD_MSG)$(RESET)"
	@cd .. && docker-compose build
	@echo "$(GREEN)✓ Build dos containers concluído!$(RESET)"

docker-logs:
	@echo "$(CYAN)$(DOCKER_LOGS_MSG)$(RESET)"
	@cd .. && docker-compose logs -f

# Comando principal para desenvolvimento com Docker
dev: docker-build docker-up
	@echo "$(GREEN)✓ Ambiente de desenvolvimento pronto!$(RESET)"
	@echo "$(CYAN)📝 Use 'make docker-logs' para ver os logs$(RESET)"

# Para o ambiente de desenvolvimento
docker-restart: docker-down docker-up
	@echo "$(GREEN)✓ Containers reiniciados com sucesso!$(RESET)" 