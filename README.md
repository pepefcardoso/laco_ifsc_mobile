# Laço

App móvel projetado para conectar famílias e amigos distantes de forma afetuosa e não intrusiva. Sinta-se presente no dia a dia de quem você ama, mesmo de longe.

**Conceito Visual:** Suave como uma ligação de voz, íntimo como uma foto na geladeira.

## 🔗 Protótipos
Confira o fluxo e telas do aplicativo no nosso Figma (ou pasta de documentação):
[Acessar Protótipos no Figma](https://www.figma.com/dummy-link-laco-app)
*(Nota: screenshots e fluxos adicionais podem ser encontrados em `docs/prototype/`)*

---

## 👥 Integrantes do Grupo
- **Artur**
- **pepefcardoso** (Pedro Cardoso)

---

## ✨ Funcionalidades (Features)

Abaixo estão os requisitos solicitados e como os implementamos:

| Requisito | Implementação |
|------------|---------------|
| **Navegação com rotas nomeadas** | Fluxo organizado: Login → Home → Feed → Mapa → Perfil → Grupo |
| **Gerenciamento de estado (Provider)** | Utilizado extensivamente: AuthProvider, FeedProvider, GroupProvider, LocationProvider e ProfileProvider |
| **Autenticação (Firebase)** | Login e cadastro completos usando Firebase Auth (E-mail/Senha e Google) |
| **Armazenamento (Firebase)** | Cloud Firestore para dados (usuários, posts, grupos) e Firebase Storage para imagens (fotos de post e perfil) |
| **Sensor (GPS)** | Geolocator integrado. A aba "Mapa" exibe a última localização conhecida de cada membro do grupo |
| **Widgets próprios** | Mais de 7 widgets encapsulados e reutilizáveis (e.g. `MemberRow`, `PostCard`, `WeatherBadge`, `HugButton`) garantindo que as telas tenham menos de 200 linhas |
| **API externa (criatividade)** | Integração com OpenWeatherMap API para exibir clima (temperatura e ícone) na cidade atual de cada membro |
| **Animação (criatividade)** | Lottie animations utilizadas para enviar um "Abraço Virtual" com feedback tátil, exibido em tempo real no feed |
| **Tratamento Offline/Assíncrono** | Tratamento robusto de Loading/Error states em todas as chamadas e suporte a cache local via `cached_network_image` |

---

## 🛠️ Stack Tecnológica

- **Framework:** Flutter (Dart)
- **Gerenciamento de Estado:** Provider
- **Backend as a Service:** Firebase (Auth, Firestore, Storage)
- **Localização:** `geolocator`, `geocoding`
- **Mapas:** `google_maps_flutter`
- **Clima:** OpenWeatherMap API
- **Mídia:** `image_picker`, `cached_network_image`
- **Animações:** `lottie`

---

## 🚀 Como Rodar o Projeto

Siga os passos abaixo para testar o projeto localmente:

### Pré-requisitos
1. **Flutter SDK** instalado (versão `^3.11.5` ou compatível)
2. **Android Studio** (com Android SDK) ou **Xcode** para iOS
3. Conta no Firebase e no OpenWeatherMap (para obter as chaves de API, caso deseje compilar do zero)

### Passo a Passo

1. **Clonar o Repositório**
   ```bash
   git clone https://github.com/seu-usuario/laco_ifsc_mobile.git
   cd laco_ifsc_mobile
   ```

2. **Instalar Dependências**
   ```bash
   flutter pub get
   ```

3. **Configuração do Firebase e Google Maps**
   - O repositório já contém as bibliotecas necessárias.
   - Você precisará adicionar o seu arquivo `google-services.json` (Android) na pasta `android/app/` e `GoogleService-Info.plist` (iOS) na pasta `ios/Runner/`.
   - Adicione sua API Key do Google Maps no arquivo `android/app/src/main/AndroidManifest.xml` e no `ios/Runner/AppDelegate.swift`.

4. **Executar o Aplicativo**
   - Inicie um Emulador Android ou Simulador iOS.
   - Execute o comando:
   ```bash
   flutter run
   ```

---

## 📁 Estrutura de Pastas

```text
lib/
├── main.dart
├── firebase_options.dart
├── app.dart                  # Configuração de MaterialApp e rotas
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart   # Design System (Cores, Espaçamento, Sombras)
│   │   └── app_routes.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── firestore_service.dart
│   │   ├── storage_service.dart
│   │   ├── location_service.dart
│   │   └── weather_service.dart
│   └── utils/
│       └── date_formatter.dart
│
├── models/
│   ├── user_model.dart
│   ├── group_model.dart
│   ├── post_model.dart
│   ├── member_location_data.dart
│   └── hug_model.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── group_provider.dart
│   ├── feed_provider.dart
│   ├── profile_provider.dart
│   └── location_provider.dart
│
├── screens/                  # Todas as telas possuem < 200 linhas
│   ├── auth/                 # login, register
│   ├── feed/                 # feed_screen, create_post_screen
│   ├── map/                  # map_screen
│   ├── profile/              # profile_screen, edit_profile_sheet
│   ├── group/                # group_screen
│   └── splash/               # splash_screen
│
└── widgets/                  # Componentes reutilizáveis isolados
    ├── member_row.dart
    ├── post_card.dart
    ├── hug_button.dart
    ├── weather_badge.dart
    ├── map_header_card.dart
    ├── member_bottom_sheet.dart
    └── online_indicator.dart
```

---

## 💾 Modelagem de Dados (Firestore)

A estrutura NoSQL no Firebase está definida da seguinte forma:

```text
users/ {uid}
  name, photoUrl, email, groupId, lastLocation, lastSeen

groups/ {groupId}
  name, code, createdBy, members[], createdAt
  
  posts/ {postId}
    authorId, imageUrl, caption, reactions{}, createdAt
    
  hugs/ {hugId}
    fromUid, toUid, sentAt
```
