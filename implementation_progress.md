# Implementation Progress

## 📅 Phase 1: Manual Collector (The "Share" Utility)
- [x] **Project Setup**
    - [x] Initialize Flutter project (FVM, Android).
    - [x] Set up Modular Architecture (`core`, `features`).
    - [x] Configure Dependency Injection (`get_it`, `injectable`).
- [x] **Database (Drift/SQLite)**
    - [x] Define `ClipboardClips` table.
    - [x] Enable FTS5 (Full Text Search).
    - [x] Implement `ClipboardRepository` (CRUD + Search).
- [x] **State Management (BLoC)**
    - [x] Implement `ClipboardBloc` (Load, Add, Delete, Pin, Search).
- [x] **Integration**
    - [x] **Share Intent:** Handle `ACTION_SEND` from other apps.
    - [x] **Process Text:** Handle `ACTION_PROCESS_TEXT` (Context Menu).
    - [x] **Foreground Watcher:** Auto-save clips when app is open (`clipboard_watcher`).
- [x] **UI**
    - [x] Main List View.
    - [x] Search Bar.
    - [x] Clip Actions (Copy, Delete, Pin).
- [x] **Testing**
    - [x] Unit Tests: `ClipboardBloc`.
    - [x] Unit Tests: `ClipboardRepository`.
    - [x] Widget Tests: `ClipboardPage` / `ClipboardItemWidget`.

## ⌨️ Phase 2: Quick Switcher (The IME Service)
- [ ] **Android Native (Kotlin)**
    - [ ] Create `ClipboardInputMethodService` class.
    - [ ] Add `BIND_INPUT_METHOD` permission in Manifest.
    - [ ] Define `method_config.xml`.
- [ ] **Flutter Integration**
    - [ ] Set up `MethodChannel` for communication.
    - [ ] Implement "Insert Clip" logic (sending text from Flutter to Android IME).
- [ ] **Keyboard UI**
    - [ ] Design Custom Keyboard View in Flutter (or Native View if needed).
    - [ ] Display Clipboard History in Keyboard.

## ☁️ Phase 3: Smart Features & Cloud Sync
- [ ] **Cloud Sync**
    - [ ] Set up Firebase/Supabase.
    - [ ] Implement Auth (Google Sign-In).
    - [ ] Sync Logic (Upload/Download clips).
- [ ] **Smart Actions**
    - [ ] Detect URL/Email/Phone in clips.
    - [ ] Add Action Buttons to UI.

## 💰 Monetization
- [ ] **AdMob Integration**
    - [ ] Add Banner Ads to Main List.
    - [ ] Add Native Ads to Feed.
- [ ] **Subscription (RevenueCat/Stripe)**
    - [ ] Implement "Pro" status check.
    - [ ] Hide Ads for Pro users.
