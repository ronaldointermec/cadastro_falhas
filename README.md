# Sistema de Cadastro e Gestão de Falhas (Brady)

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)](https://firebase.google.com)
[![Material Design 3](https://img.shields.io/badge/Material%2C%20Design%203-757575?style=for-the-badge&logo=material-design&logoColor=white)](https://m3.material.io)

Aplicativo corporativo multiplataforma desenvolvido em **Flutter** integrado ao **Firebase (Cloud Firestore & Auth)** para o controle, validação, aprovação e rastreabilidade de falhas produtivas e de processos, seguindo estritamente as diretrizes da identidade visual da **Brady** (*Brady Blue `#002B49`*).

---

## 🚀 Principais Funcionalidades

- **Dashboard Responsivo**: Tela inicial adaptativa com suporte otimizado para coletores industriais (Android 7), celulares e telas de desktop/web.
- **Validação de Falhas**: Listagem virtualizada de alta performance para validação rápida de registros pendentes.
- **Gestão de Aprovados**: Consulta e acompanhamento de falhas aprovadas com cartões detalhados e interface moderna baseada em Material 3.
- **Exportação de Dados**: Geração de relatórios em CSV com seletor de intervalo de datas integrado (`showDateRangePicker`), busca automática e feedback visual de progresso.
- **Comunicação com Impressoras**: Configuração de socket IP com validação estrita de endereços IPv4 via Expressão Regular (*RegEx*).
- **Identidade Visual Corporativa**: Tema completo em **Brady Blue**, logotipo oficial na barra superior (*AppBar*) e suporte a ícones de atalho e tela de abertura (*Splash Screen*) nativos para múltiplas versões do Android (Android 7 a 13+).

---

## 🛠️ Stack Tecnológica & Arquitetura

- **Framework**: Flutter (Dart)
- **Banco de Dados & Autenticação**: Firebase Cloud Firestore & Firebase Auth
- **Gerenciamento de Estado**: Provider
- **Padrão de Projeto**: DAOs (*Data Access Objects*) para isolamento de lógica de banco de dados e DTOs para transferência de dados.
- **Performance**: Consultas otimizadas com paginação e limites (`.limit()`) para prevenção de ANRs e estouros de memória em coletores industriais.

---

## 📦 Como Executar o Projeto

1. **Pré-requisitos**:
   - Flutter SDK instalado (versão compatível com o projeto)
   - Dart SDK
   - Configuração do ambiente Firebase (arquivo `google-services.json` para Android)

2. **Instalação das Dependências**:
   ```bash
   flutter pub get
   ```

3. **Executando o Aplicativo**:
   ```bash
   flutter run
   ```

---

## ⚙️ CI/CD & Deploy (Firebase Hosting)

O projeto conta com automação de integração contínua e entrega contínua (**CI/CD**) configurada via **GitHub Actions**. 
Sempre que há novos *commits* ou atualizações nas branches principais, o pipeline automatizado executa a compilação do projeto e realiza o deploy contínuo para o **Firebase Hosting**.

---

## 📋 Versão & Histórico

- **Versão Atual**: 1.0.2
- **Desenvolvido para**: Ambiente industrial e corporativo Brady.
