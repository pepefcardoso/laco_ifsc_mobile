# Laço

App para famílias e amigos distantes se sentirem presentes no dia a dia uns dos outros.

## Features mapeadas por requisito

| Requisito | Implementação |
|------------|---------------|
| Navegação com rotas nomeadas | Login → Home → Feed → Mapa → Perfil → Grupo |
| Gerenciamento de estado (Provider) | Sessão do usuário, feed, membros do grupo |
| Autenticação (Firebase) | Login/cadastro com e-mail ou Google |
| Armazenamento (Firebase) | Firestore para dados, Storage para mídia |
| Sensor (GPS) | Mapa mostrando onde cada membro está (última localização) |
| Widgets próprios | Card de membro, bolinha de status, post card |
| API externa (criatividade) | OpenWeather para ver o clima atual de onde cada familiar está |
| Animação (criatividade) | Animação ao enviar um "abraço virtual" |

---

## Telas

### Splash / Onboarding
Apresentação do app.

### Login / Cadastro
Firebase Auth.

### Home / Feed
Linha do tempo com posts/momentos do grupo (foto + legenda + reação).

### Mapa do grupo
Mapa com pins de cada membro (GPS + cidade/clima via API).

### Publicar momento
Câmera ou galeria + legenda.

### Perfil
Foto, nome, última localização, histórico de momentos.

### Configurações do grupo
Criar/entrar em grupo via código.

---

## Stack

- **Flutter + Provider** — estado global
- **Firebase Auth** — autenticação
- **Firestore** — posts, grupos, membros
- **Firebase Storage** — fotos
- **geolocator** — GPS
- **OpenWeatherMap API** — clima por coordenada
- **google_maps_flutter** — mapa dos membros

---

## Estrutura de pastas

```text
lib/
├── main.dart
├── firebase_options.dart
├── app.dart                  # MaterialApp, rotas nomeadas, providers
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
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
│   └── hug_model.dart
│
├── providers/
│   ├── auth_provider.dart
│   ├── group_provider.dart
│   ├── feed_provider.dart
│   └── location_provider.dart
│
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart        # BottomNav container
│   ├── feed/
│   │   ├── feed_screen.dart
│   │   └── create_post_screen.dart
│   ├── map/
│   │   └── map_screen.dart
│   ├── profile/
│   │   └── profile_screen.dart
│   └── group/
│       └── group_screen.dart
│
└── widgets/
    ├── member_card.dart
    ├── post_card.dart
    ├── hug_button.dart             # animação Lottie
    ├── weather_badge.dart
    └── online_indicator.dart
```

---

## Models

### UserModel

```dart
id, name, photoUrl, email, groupId, lastLocation (GeoPoint), lastSeen (Timestamp)
```

### GroupModel

```dart
id, name, code (6 chars), createdBy, members (List<String uid>), createdAt
```

### PostModel

```dart
id, authorId, groupId, imageUrl, caption, reactions (Map<uid, emoji>), createdAt
```

### HugModel

```dart
id, fromUid, toUid, groupId, sentAt
```

---

## Providers

| Provider | Estado que gerencia |
|-----------|---------------------|
| `AuthProvider` | Usuário logado, login, logout, register |
| `GroupProvider` | Grupo atual, membros, criar/entrar |
| `FeedProvider` | Posts do grupo, criar post, reagir |
| `LocationProvider` | Localização atual, atualizar no Firestore, clima via API |

---

## Rotas nomeadas — `app_routes.dart`

```dart
/splash
/login
/register
/home          # BottomNav (feed, map, profile)
/create-post
/group
/profile/:uid
```

---

## Firestore — Coleções

```text
users/
  {uid}/
    name, photoUrl, email, groupId, lastLocation, lastSeen

groups/
  {groupId}/
    name, code, createdBy, members[], createdAt
    posts/
      {postId}/
        authorId, imageUrl, caption, reactions{}, createdAt
    hugs/
      {hugId}/
        fromUid, toUid, sentAt
```

---

## Fluxo de navegação

```text
Splash
  ├── (logado + tem grupo) → /home
  ├── (logado + sem grupo) → /group
  └── (não logado)         → /login
                                └── /register
```
