# Semana da Computação - UFOP 📱

Um aplicativo Flutter completo para gerenciamento de atividades da Semana da Computação da Universidade Federal de Ouro Preto (UFOP), desenvolvido com Clean Architecture e integrado ao Firebase.

## 📋 Sobre o Projeto

Este aplicativo permite aos usuários visualizar, favoritar e gerenciar atividades da Semana da Computação. Conta com sistema de autenticação, interface diferenciada com as cores da UFOP, e funcionalidades específicas para administradores e usuários comuns.

### ✨ Funcionalidades Principais

#### 👤 Para Usuários Comuns:
- **Visualização de Atividades**: Lista completa de palestras e workshops
- **Sistema de Favoritos**: Marque atividades como favoritas para acompanhar
- **Filtros**: Filtre por tipo (Palestra, Workshop, Todos)
- **Detalhes Completos**: Informações detalhadas sobre cada atividade
- **Agenda Pessoal**: Visualize apenas suas atividades favoritas

#### 👨‍💼 Para Administradores:
- **CRUD Completo**: Criar, editar e excluir atividades
- **Gerenciamento Total**: Controle completo sobre o conteúdo
- **Interface Dedicada**: Dashboard específico para administradores
- **Validações**: Validação de dados

#### 🔐 Sistema de Autenticação:
- **Login/Cadastro**: Sistema completo de autenticação
- **Sincronização**: Favoritos sincronizados na nuvem para usuários logados

## 🛠️ Tecnologias Utilizadas

### Framework Principal
- **Flutter**: Framework cross-platform para desenvolvimento mobile
  - Versão: 3.10.7+
  - Material Design 3
  - Suporte a Android, iOS, Web, Windows, macOS e Linux

### Backend & Banco de Dados
- **Firebase**:
  - **Firebase Auth**: Autenticação de usuários
  - **Cloud Firestore**: Banco de dados NoSQL em tempo real
  - **Firebase Core**: Inicialização e configuração

### Gerenciamento de Estado
- **Provider**: Padrão de gerenciamento de estado reativo

### Bibliotecas Adicionais
- **Intl**: Formatação de datas e internacionalização
- **Shared Preferences**: Armazenamento local de dados
- **Google Fonts**: Tipografia Roboto para consistência visual

### Arquitetura
- **Clean Architecture**: Separação clara entre camadas (UI, Domain, Data)
- **MVVM Pattern**: Separação de responsabilidades
- **Repository Pattern**: Abstração de acesso a dados

## 📁 Estrutura do Projeto

```
lib/
├── core/                    # Configurações globais
│   ├── constants.dart       # Constantes da aplicação
│   ├── theme.dart          # Tema e estilos visuais
│   └── utils.dart          # Utilitários (formatação de datas)
├── models/                  # Modelos de dados
│   └── activity_model.dart  # Modelo de atividade
├── providers/               # Gerenciamento de estado
│   └── activities_provider.dart
├── services/                # Serviços externos
│   ├── auth_service.dart    # Serviço de autenticação
│   └── firestore_service.dart # Serviço Firestore
├── ui/                      # Interface do usuário
│   ├── screens/             # Telas da aplicação
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   ├── signup_screen.dart
│   │   ├── home_screen.dart
│   │   ├── admin_dashboard_screen.dart
│   │   ├── activity_form_screen.dart
│   │   └── activity_details_screen.dart
│   └── widgets/             # Widgets reutilizáveis
│       └── activity_card.dart
└── main.dart               # Ponto de entrada da aplicação
```

## 🚀 Como Executar o Projeto

### 📋 Pré-requisitos

- **Flutter SDK** (versão 3.10.7 ou superior)
- **Android Studio** ou **VS Code** com extensões Flutter/Dart
- **Conta Google** para configurar Firebase

### 🔧 Configuração Rápida

1. **Clone o repositório:**
   ```bash
   git clone https://github.com/thiagomaravilha/flutter_application_ufop.git
   cd flutter_application_ufop
   ```

2. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

3. **Configure o Firebase:**
   - Crie um projeto no [Firebase Console](https://console.firebase.google.com/)
   - Habilite Authentication (Email/Password) e Firestore
   - Execute `flutterfire configure` para conectar o projeto

4. **Execute o aplicativo:**
   ```bash
   flutter run
   ```

### 🧪 Testes e Build

- **Executar testes:** `flutter test`
- **Build para produção:** `flutter build apk --release`
```bash
flutter build web --release
```

## 🔑 Configuração de Usuários Admin

Para criar usuários administradores:

1. **Via Firebase Console**:
   - Vá para Firestore Database
   - Crie uma coleção chamada `admins`
   - Adicione documentos com o UID do usuário como ID do documento

2. **Estrutura do documento admin**:
```json
{
  "email": "admin@ufop.edu.br",
  "role": "admin"
}
```

## 📱 Funcionalidades Detalhadas

### Sistema de Favoritos
- **Usuários Logados**: Favoritos sincronizados no Firestore

### Validações
- **Datas**: Data de fim deve ser posterior à data de início
- **Campos Obrigatórios**: Título, descrição, palestrante, local
- **Formatação**: Datas e horários com validação automática

### Interface Responsiva
- **Material Design 3**: Design system moderno
- **Tema UFOP**: Identidade visual consistente
- **Navegação Intuitiva**: BottomNavigationBar com abas claras

---

**Semana da Computação - UFOP** | Desenvolvido em Flutter
