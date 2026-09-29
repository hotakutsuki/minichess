# Inkachess (Inti: The Inka Chess Game)

Minichess game built in **Flutter**, published and **in production** at https://inkachess.com/.
Repo: `github.com/hotakutsuki/minichess` · package name: `inti_the_inka_chess_game`.

> **Workflow + feature roadmap (bosses, modifiers, story mode, …):** see
> [`docs/PROJECT.md`](docs/PROJECT.md). This file is the technical/architecture reference.

## Stack
- Flutter (Android, iOS, web, desktop targets present)
- Firebase (Firestore, Functions in `firebasefunctions/`, Hosting)
- Separate `notificationserver/` for push notifications

## Current goal
Add **enhancements to make the game more fun**. Ideas to be brainstormed with the user
before scoping — do NOT start building features until the scope is agreed.

## Architecture (as of refactor start)
- State mgmt: **GetX** (controllers under `lib/app/modules/*/controllers`).
- Game core today is **not a clean layer**: rules live as free functions in the
  god-file `lib/app/utils/utils.dart` (`isValidMovmentPerPiece`, `checkIfValidMove`,
  `checkIfWin`) mixed with UI/audio/regex helpers. Piece movement is a hardcoded `switch`.
- Board is a fixed **3×4 minichess**; pawn promotes to knight at `j==3` (`gameState.dart`).
- AI in `ai_controller.dart` (minimax-ish eval). Note: `getPlay` returns early at the
  `return makeLocalDecision()` — the remote-play block below it is **dead/unreachable**.
- Movement is now **data-driven** via `engine/rules.dart` `pieceOffsets()` (Stage 3).
  This also fixed the old knight bug (it compared `possession` to `player`, so the enemy
  knight's diagonals were mirrored wrong — only affected the AI's king-safety heuristic,
  since this game has no check). The knight (an invented promoted-pawn piece) now mirrors
  by owner like the pawn.

## Build / run
- Emulator alias in user's zsh: **`celular`** → launches AVD `@Small_Phone`. Mobile-first,
  then web (`flutter run -d chrome`).
- `lib/firebase_options.dart` is gitignored — generate with `flutterfire configure`
  (project `minichess-34a02`) on a fresh clone. Present locally now.
- On Linux, imports are case-sensitive: keep filenames/imports consistent (the repo had
  `GameState.dart` vs `gameState.dart` mismatch — fixed on the refactor branch).

## Toolchain (Fedora 43) — fixed on feature/refactor-core
- Fedora ships **JDK 25**, too new for the Android build. Flutter pinned to **JDK 17**
  (Temurin) via `flutter config --jdk-dir /usr/lib/jvm/java-17-temurin-jdk`. Persisted.
- **AGP 8.9.1**, **Gradle 8.11.1**, `compileSdk 36` (required by upgraded plugins).
- `android/gradle.properties`: Jetifier **disabled** (AndroidX-only) + heap `-Xmx4G`
  (Jetifier+1.5G heap was OOMing the Flutter jars).

## Dependency upgrade (done on feature/refactor-core) — latest everything
- Dart SDK constraint → `>=3.0.0 <4.0.0`.
- **Firebase to latest majors**: core 4, auth 6, firestore 6, analytics 12, messaging 16,
  crashlytics 5, storage 13. Removed manual `firebase-bom`/`firebase-analytics(-ktx)` from
  `app/build.gradle` (FlutterFire injects them; `-ktx` artifacts no longer exist).
- Dropped **`firebase_notifications_handler`** (unmaintained, blocked the Firebase majors;
  it was only re-exporting firebase_messaging types in `main.dart`).
- `flutter_local_notifications` 18→22 (`show()` now all-named args), `file_picker` 9→11
  (`FilePicker.pickFiles()` is now static), `connectivity_plus` 6→7, `flutter_lints` 5→6.
- iOS/macOS deployment targets raised to **iOS 15 / macOS 10.15** (Firebase req).

## Build status (verified from clean)
- ✅ **Android** APK debug builds. ✅ **Web** builds. (Both green.)
- ⚠️ **iOS/macOS**: config updated for the upgrade but **UNVERIFIED** — needs a Mac with
  Xcode + `pod install` to confirm. Cannot be built on this Linux machine.

## Workflow for changes (per user) — gitflow
- Branching: `feature/*` → **`dev`** (integration) → **`main`** (production).
  One `feature/*` branch per feature, branched off `dev`.
- **Open a PR for every change; the user merges** (do NOT push straight to `main`/`dev`;
  `main` has branch protection requiring PRs).
- `main` is production: merging into it triggers the live Firebase Hosting deploy
  (`inkachess.com`). Only release to `main` once everything is tested in `dev`.
- Verify each step with `flutter analyze` + unit tests; full emulator/web build at
  milestones so the user can try it.

## Notes
- This is a live production app — be careful with anything touching Firestore rules,
  schema, or deploys.
