# 🚀 RWA Hub Sandbox

Este é o ambiente de desenvolvimento sandbox para o projeto RWA Hub. Ele foi projetado para facilitar o desenvolvimento e teste local de todos os componentes do sistema.

## 📋 Pré-requisitos

- Git
- Make
- Docker
- Docker Compose
- Node.js (v18+)
- npm ou yarn

## 🏗️ Estrutura do Projeto

```
rwa-hub/
├── infrasctruture/     # Configurações de infraestrutura (Docker, etc)
├── packages/           # Submódulos dos projetos
│   ├── web/           # Aplicações web
│   │   ├── pannel-admin/
│   │   └── marketplace/
│   └── blockchain/    # Componentes blockchain
│       ├── indexer/
│       └── smart-contracts/
├── Makefile           # Scripts de automação
└── README.md
```

## 🚀 Começando

1. Clone o repositório:
```bash
git clone https://github.com/rwa-hub/sandbox.git
cd sandbox
```

2. Configure o ambiente:
```bash
make setup
```

Este comando irá:
- Inicializar todos os submódulos
- Instalar dependências
- Configurar a infraestrutura Docker
- Criar redes necessárias

3. Inicie o ambiente de desenvolvimento:
```bash
make dev
```

## 📚 Comandos Disponíveis

### Comandos Principais
- `make setup` - Configura todo o ambiente
- `make clean` - Limpa todo o ambiente
- `make status` - Mostra status de todos os componentes
- `make update` - Atualiza todos os submódulos

### Gerenciamento de Submódulos
- `make submodule-init` - Inicializa submódulos
- `make submodule-update` - Atualiza submódulos
- `make submodule-clean` - Remove submódulos

### Desenvolvimento
- `make dev` - Inicia ambiente de desenvolvimento
- `make install-all` - Instala dependências em todos os projetos
- `make test-all` - Executa testes em todos os projetos

### Infraestrutura
- `make infra-up` - Inicia infraestrutura
- `make infra-down` - Para infraestrutura
- `make infra-status` - Status da infraestrutura

### Git Operations
- `make commit-all` - Commit em todos os submódulos
- `make push-all` - Push em todos os submódulos

## 🔧 Configuração dos Submódulos

Os submódulos são configurados automaticamente nas seguintes URLs:

- Admin Panel: `https://github.com/rwa-hub/web-pannel-admin`
- Marketplace: `https://github.com/rwa-hub/marketplace`
- Blockchain Indexer: `https://github.com/rwa-hub/blockchain-indexer`
- Smart Contracts: `https://github.com/rwa-hub/smart-contracts`

## 🐳 Infraestrutura Docker

A infraestrutura inclui:
- MongoDB
- RabbitMQ
- Serviços de monitoramento blockchain

## 🤝 Contribuindo

1. Faça fork do projeto
2. Crie sua feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`make commit-all`)
4. Push para a branch (`make push-all`)
5. Abra um Pull Request

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes. 