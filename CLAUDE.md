# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

HarmonyOS (鸿蒙) native app built with ArkTS + ArkUI declarative framework, targeting API 6. A venue reservation app with tab navigation (home, news, sports knowledge, venue booking, profile).

## Build & Run

- **Build & run:** Open in DevEco Studio and run/debug from the IDE (Hvigor build system)
- **Start backend JSON server:** `cd server && npx json-server --watch db.json --port 3000`
- **Run tests:** Via DevEco Studio (ohosTest configuration)
- **Server URL:** Hardcoded in `entry/src/main/ets/utils/MyHttp.ets:3` — change `BASE_URL` to your local IP for device testing, or `http://127.0.0.1:3000/` for previewer

## Architecture

### Navigation
- **Tab navigation:** `App.ets` uses `Tabs` with 5 tabs: 首页, 场馆动态, 运动常识, 场馆预约, 我的
- **Page routing:** `NavPathStack` (new API) for in-tab page navigation, with routes defined in `route_map.json`
- **Legacy router:** Some pages still use `getUIContext().getRouter().pushUrl()` — migration in progress

### Data Layer
- **Local SQLite:** `DBTools.ets` (singleton via `relationalStore`) with `UserDao.ets` and `PlayerDao.ets` for CRUD on `USER` and `PLAYER` tables
- **Remote JSON server:** `MyHttp.ets` for venue data (`/quicks`) and user auth (`/user`, `/user/{id}`)
- **AppStorage:** Global state for caching logged-in user info

### Key Source Layout
```
entry/src/main/ets/
├── pages/
│   ├── app/App.ets            # Root component with Tabs navigation
│   ├── home/Home.ets          # Home tab (quick entry grid, hot list)
│   ├── message/Message.ets    # News/场馆动态 tab
│   ├── know/Know.ets          # Sports knowledge tab
│   ├── restime/               # Venue booking tab + sub-pages (Application, ResDetail, Reports)
│   ├── mine/                  # Profile tab + Login, Register, Update pages
│   └── common/                # Shared pages (MyDetail, YuyueList)
├── entity/                    # Data models (User, Player, Quick, News, Type)
├── utils/                     # HTTP client, SQLite helpers, DAOs
├── entryability/EntryAbility.ets  # App lifecycle, DB init
```

### Entry Flow
1. `EntryAbility.onCreate()` creates SQLite DB + tables + seed users
2. `EntryAbility.onWindowStageCreate()` loads `pages/Index` → renders `App.ets`
3. `App.ets` renders 5-tab layout; each tab loads its own `@Component` tree
4. Home tab fetches quick-entry data from json-server via `MyHttp`
5. Booking flow: user selects date/venue → fills form → saves to local SQLite + optionally to server

## Important Notes

- **IDE required:** DevEco Studio (HarmonyOS IDE) — not Android Studio or VS Code
- **Package manager:** OHPM (not npm). Dependencies in `oh-package.json5`
- **Dual data paths:** Local SQLite for bookings, remote JSON server for venue data and auth
- **Tests:** Located in `entry/src/ohosTest/` using `@ohos/hypium` framework
- **Server static files:** `server/public/` mirrors rawfile assets (tab icons, venue images)
