# 📢 Avisa Mais (A+ IFPI)

<p align="center">
  <img src="assets/images/Avisa+%20IFPI%20(Telas).png" alt="Avisa Mais Logo" width="130" />
</p>

<p align="center">
  <strong>Plataforma colaborativa para reporte, acompanhamento e priorização de demandas e manutenções do campus.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
  <img src="https://img.shields.io/badge/Plataforma-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-brightgreen?style=for-the-badge" alt="Plataformas" />
  <img src="https://img.shields.io/badge/Licen%C3%A7a-MIT-yellow?style=for-the-badge" alt="Licença" />
</p>

---

## 📱 Visão Geral

O **Avisa Mais (A+ IFPI)** é uma solução mobile desenvolvida em Flutter criada para aproximar a comunidade acadêmica (alunos, professores e servidores) da equipe de infraestrutura e gestão.

Com o aplicativo, qualquer usuário pode registrar problemas de infraestrutura ou demandas (como equipamentos quebrados, salas sem climatização, iluminação e limpeza), acompanhar o status em tempo real e apoiar relatos de outros membros através de votação comunitária.

<p align="center">
  <img src="screen.png" alt="Avisa Mais Preview" width="320" style="border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);" />
</p>

---

## ✨ Funcionalidades

- **📢 Registro de Demandas:** Cadastro de ocorrências detalhando problema, setor/sala e descrição.
- **🗳️ Votação Colaborativa:** Sistema de *upvotes* e *downvotes* para priorizar os chamados mais urgentes.
- **📊 Status em Tempo Real:** Visualização do ciclo de vida dos chamados (`Pendente`, `Em andamento`, `Resolvido`).
- **💬 Interação Comunitária:** Comentários e discussões em cada chamado reportado.
- **🔍 Busca e Filtros Dinâmicos:** Localize ocorrências por palavras-chave, setor ou status.
- **🔐 Autenticação Completa:** Fluxos de Login, Cadastro com verificação OTP (código de 4 dígitos) e Recuperação de Senha.
- **🎨 Design Moderno & Responsivo:** Interface construída com Material Design 3 e paleta de cores temática.

---

## 🛠️ Tecnologias Utilizadas

- **[Flutter](https://flutter.dev/)** – Framework cross-platform
- **[Dart](https://dart.dev/)** – Linguagem de desenvolvimento
- **Material 3 Design** – Componentes visuais padronizados
- **Arquitetura MVVM / Repository Pattern** – Código modular, escalável e desacoplado

---

## 📂 Estrutura do Projeto

```text
lib/
├── data/
│   ├── models/            # Modelos de dados (Issue, User, Comment)
│   └── repositories/      # Repositórios e fontes de dados mockadas/API
├── routes/                # Gerenciamento de rotas nomeadas
├── screens/               # Telas da aplicação (Home, Login, Detalhes, etc.)
├── theme/                 # Paleta de cores, tipografia e estilos globais
├── viewmodels/            # Gerenciamento de estado e regras de apresentação
├── widgets/               # Componentes reutilizáveis (botões, cards, headers)
└── main.dart              # Ponto de entrada da aplicação
```

---

## 🚀 Como Baixar e Executar no Seu Computador

Siga o passo a passo abaixo para rodar o projeto localmente:

### 1. Pré-requisitos

Antes de começar, certifique-se de ter instalado no computador:

1. **[Git](https://git-scm.com/downloads)**
2. **[Flutter SDK](https://docs.flutter.dev/get-started/install)** (versão 3.13 ou superior)
3. Um editor de código, como **[VS Code](https://code.visualstudio.com/)** ou **[Android Studio](https://developer.android.com/studio)**
4. Dependências de ambiente:
   - Para rodar no Android: **Android Studio** com emulador ou aparelho físico conectado via depuração USB.
   - Para rodar no Navegador: **Google Chrome** instalado.
   - Para rodar no Windows Desktop: Visual Studio com ferramentas C++ para Desktop.

> 💡 **Verifique seu ambiente:** Abra o terminal e execute:
> ```bash
> flutter doctor
> ```
> O comando mostrará se há alguma dependência pendente.

---

### 2. Clonando o Repositório

Abra o terminal (Prompt de Comando, PowerShell ou Terminal do Linux/macOS) e clone o projeto:

```bash
git clone https://github.com/KaykyTFF/Avisa-Mais.git
```

Acesse a pasta do projeto:

```bash
cd Avisa-Mais
```

---

### 3. Instalando as Dependências

Baixe os pacotes e dependências necessários do Flutter:

```bash
flutter pub get
```

---

### 4. Executando o Aplicativo

Para visualizar quais dispositivos ou emuladores estão disponíveis:

```bash
flutter devices
```

Escolha uma das opções para executar:

#### Opção A: No Emulador ou Celular Conectado
Inicie o emulador (ou conecte seu smartphone com depuração USB ativada) e execute:
```bash
flutter run
```

#### Opção B: No Navegador (Chrome)
Para testar rapidamente na web:
```bash
flutter run -d chrome
```

#### Opção C: No Windows (Desktop)
Caso tenha o suporte a Windows Desktop habilitado:
```bash
flutter run -d windows
```

---

### 5. Como Abrir e Rodar no Android Studio (Passo a Passo)

Se você prefere utilizar a interface gráfica do **Android Studio**, siga as etapas:

#### 1. Instalar os Plugins do Flutter e Dart
1. Abra o Android Studio.
2. Vá em **Plugins** na tela inicial (ou no menu `File` > `Settings` > `Plugins` no Windows/Linux; `Preferences` > `Plugins` no macOS).
3. Na aba **Marketplace**, digite `Flutter` e clique em **Install** (o plugin do `Dart` será instalado automaticamente como dependência).
4. Reinicie o Android Studio se solicitado.

#### 2. Abrir o Projeto
1. Na tela inicial do Android Studio, clique em **Open** (ou vá em `File` > `Open...`).
2. Selecione a pasta onde o projeto foi clonado (`Avisa-Mais`) e clique em **OK**.
3. Aguarde o Android Studio indexar os arquivos do projeto.

#### 3. Sincronizar as Dependências
1. Abra o arquivo `pubspec.yaml` na árvore lateral esquerda.
2. Na barra de notificação superior amarela/azul, clique em **`Flutter pub get`** (ou abra o terminal integrado do Android Studio com `Alt + F12` e digite `flutter pub get`).

#### 4. Iniciar um Emulador Android ou Conectar Celular
- **Usando Emulador (AVD):**
  1. Abra o **Device Manager** na barra lateral direita ou no menu superior (`Tools` > `Device Manager`).
  2. Caso não possua um emulador configurado, clique em **Create Device** (ex: Pixel 7 com imagem de sistema Android 13/14).
  3. Clique no botão de **Play (▶️)** ao lado do emulador para iniciá-lo.
- **Usando Celular Físico:**
  - Conecte seu aparelho via cabo USB com a opção **Depuração USB** habilitada nas *Opções do Desenvolvedor*.

#### 5. Executar o Aplicativo
1. Na barra de ferramentas superior do Android Studio:
   - Certifique-se de que o alvo de execução está apontando para `main.dart` (arquivo em `lib/main.dart`).
   - No seletor de dispositivos, verifique se o seu emulador ou celular conectado está selecionado.
2. Clique no botão verde **Run** (ícone de Play ▶️ ou atalho `Shift + F10`) ou **Debug** (ícone de besouro 🐞 ou `Shift + F9`).
3. O Android Studio compilará o app e o abrirá automaticamente no emulador ou dispositivo.
4. Para aplicar mudanças no código em tempo real, use o botão de **Hot Reload** (ícone de raio ⚡ ou atalho `Ctrl + \`).

---

## 🔧 Dicas e Resolução de Problemas

- **Limpar cache e reconstruir:**
  Se encontrar qualquer problema de compilação ou assets desatualizados, execute:
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

- **Erro de emulador não detectado:**
  Inicie o emulador previamente pelo Android Studio ou use `flutter emulators --launch <nome_do_emulador>`.

---

## 🤝 Contribuição

Contribuições são super bem-vindas!
1. Faça um Fork do projeto (`https://github.com/KaykyTFF/Avisa-Mais/fork`)
2. Crie uma branch para sua funcionalidade (`git checkout -b feature/MinhaFeature`)
3. Faça commit das suas alterações (`git commit -m 'Adiciona MinhaFeature'`)
4. Faça push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um **Pull Request**

---

## 👤 Autor

Desenvolvido por **[KaykyTFF](https://github.com/KaykyTFF)**.  
Projeto institucional para o ecossistema do **IFPI**.
