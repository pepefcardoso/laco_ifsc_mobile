# Firebase App Distribution — Setup para Flutter (Android + iOS)

## 1. Pré-requisitos

- Conta Google (para o Firebase Console)
- Node.js instalado (para o Firebase CLI)
- Flutter SDK configurado
- Para iOS: conta Apple Developer paga (US$99/ano) + Xcode

## 2. Criar projeto no Firebase

1. Acesse https://console.firebase.google.com
2. **Add project** → nomeie (ex: `laco-ifsc`)
3. Desative o Google Analytics se não for usar (opcional, agiliza a criação)

## 3. Registrar os apps no Firebase

### Android

1. No console, **Add app** → ícone Android
2. Preencha o `applicationId` — encontre em:
   ```
   android/app/build.gradle.kts (ou build.gradle)
   → defaultConfig.applicationId
   ```
3. Baixe o `google-services.json` gerado
4. Coloque em `android/app/google-services.json`
5. Anote o **App ID** exibido (formato `1:xxxxx:android:xxxxx`) — vai precisar dele no CLI

### iOS

1. No mesmo projeto Firebase, **Add app** → ícone iOS
2. Preencha o Bundle ID — encontre em:
   ```
   ios/Runner.xcodeproj/project.pbxproj → PRODUCT_BUNDLE_IDENTIFIER
   ```
   ou abra `ios/Runner.xcworkspace` no Xcode → Runner target → General
3. Baixe o `GoogleService-Info.plist`
4. Adicione ao projeto Xcode (arraste para dentro de `Runner/` no Xcode, marcando "Copy items if needed")
5. Anote o **App ID** iOS (formato `1:xxxxx:ios:xxxxx`)

## 4. Instalar o Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

Isso abre o navegador para autenticar com a mesma conta Google do projeto.

## 5. Criar grupo de testadores

1. No Firebase Console → **App Distribution** (menu lateral, em "Release & Monitor")
2. **Testers & Groups** → **Add group** → nomeie (ex: `testers`)
3. Adicione os e-mails dos familiares/amigos

> Testadores recebem um convite por e-mail. Precisam aceitar uma vez (cria conta Firebase Tester, gratuita) antes do primeiro build.

## 6. Gerar e distribuir o build — Android

```bash
flutter build apk --release
```

```bash
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app <ANDROID_APP_ID> \
  --groups "testers" \
  --release-notes "Primeira versão de testes"
```

## 7. Gerar e distribuir o build — iOS

Requer assinatura válida (certificate + provisioning profile ad-hoc ou development) configurada no Xcode antes do build.

```bash
flutter build ipa --release
```

```bash
firebase appdistribution:distribute \
  build/ios/ipa/*.ipa \
  --app <IOS_APP_ID> \
  --groups "testers" \
  --release-notes "Primeira versão de testes"
```

Se o comando falhar por falta de assinatura, abra `ios/Runner.xcworkspace` no Xcode → Signing & Capabilities → selecione o Team correto e um provisioning profile Ad Hoc.

## 8. Fluxo do testador

1. Recebe e-mail de convite (uma vez) → aceita e instala o app **Firebase App Tester**
2. A cada novo `distribute`, recebe notificação de nova versão
3. Instala direto pelo app Firebase App Tester — sem precisar de novo link manual

## 9. Automatizar (opcional)

Para não repetir os comandos a cada build, criar um script:

```bash
# scripts/distribute-android.sh
#!/bin/bash
flutter build apk --release
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app <ANDROID_APP_ID> \
  --groups "testers" \
  --release-notes "$1"
```

```bash
# uso
./scripts/distribute-android.sh "Corrige bug no login"
```

## 10. Troubleshooting comum

| Problema | Causa provável |
|---|---|
| `App ID not found` | App ID errado ou projeto Firebase incorreto no `firebase login` |
| iOS build falha assinatura | Provisioning profile não inclui os UDIDs dos dispositivos testadores (se Ad Hoc) |
| Testador não recebe e-mail | Verificar spam; reenviar convite manualmente pelo console |
| APK não instala no Android | Verificar `minSdkVersion` em `android/app/build.gradle.kts` compatível com o device |
