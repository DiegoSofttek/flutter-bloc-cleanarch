# app_template

Generic Flutter starter template following **Clean Architecture + BLoC/Cubit**. Use this repo as the baseline for new projects instead of starting from scratch.

## Stack

- **State management:** `flutter_bloc` (Cubit) — see rule below.
- **Dependency injection:** `get_it`, composed in `lib/core/di/injection_container.dart`.
- **Navigation:** `go_router`, with an auth-redirect example in `lib/core/router/app_router.dart`.
- **Networking:** `dio`, wrapped by `DioClient` (`lib/core/network/`).
- **Error handling:** `dartz`'s `Either<Failure, T>` — no exceptions cross the domain boundary.
- **Equality:** `equatable` on entities and states.
- **Testing:** `mocktail` (mocking) + `bloc_test` (Cubit state assertions).

> **Rule:** BLoC/Cubit is the only state-management approach for feature logic. Do not introduce `provider`/`ChangeNotifier` unless adding simple cross-cutting app state (e.g. theme, locale) — and if you do, document it here first.

## Architecture

Each feature is organized in three layers, with dependencies pointing inward:

```
presentation  ──depends on──>  domain  <──depends on──  data
   (UI, Cubit)                (entities,                (models,
                                contracts,                datasources,
                                usecases)                 repo impl)
```

### The Three Layers

#### 🏛️ Domain Layer
**Pure business logic—no Flutter, no HTTP, no dependencies.**

```
domain/
├── entities/              (immutable business objects)
├── repositories/          (abstract contracts — "what" operations exist)
└── usecases/              (one class per action — smallest unit of business logic)
```

- **Entities** (`user_entity.dart`): Immutable, `Equatable` business objects with no framework dependencies.
- **Repositories** (abstract): Contracts that define *what* operations exist, not *how* they work. Domain layer depends only on these interfaces.
- **Use Cases** (one per action): Smallest testable unit of business logic. Each wraps a single operation (e.g., `LoginUseCase`), calls the repository, and passes the result through.

**Key principle:** Domain layer imports nothing from `data` or `presentation`. It is 100% testable without Flutter or any external dependency.

#### 💾 Data Layer
**Implementation details—talks to APIs, databases, local storage.**

```
data/
├── datasources/           (raw API/storage access; throw typed Exceptions)
├── models/                (JSON-aware versions of entities)
└── repositories/          (implements domain contracts; catches Exceptions → maps to Failures)
```

- **Data Sources** (abstract + impl): Talk directly to `Dio`, local storage, etc. Throw typed `Exceptions` (`ServerException`, `NetworkException`) on failure. Never return `Failure`s directly.
- **Models** (`UserModel extends UserEntity`): Add JSON (de)serialization. Only the data layer knows JSON shapes; domain layer never sees them.
- **Repository Implementations**: The bridge between data and domain. Catch data-layer `Exceptions`, convert them to domain-level `Failure`s, return `Either<Failure, Entity>`. This ensures domain and presentation layers never see raw exceptions.

**Key principle:** Data layer is the *only* part of the codebase that knows about HTTP clients, JSON, databases, or other external systems. It implements the domain's abstract repositories.

#### 🎨 Presentation Layer
**UI state machine—consumes use cases, emits states.**

```
presentation/
├── cubit/                 (Cubit state machine; calls usecases; emits states)
├── pages/                 (BlocBuilder/BlocListener wired to UI)
└── (optional) widgets/    (feature-specific UI components)
```

- **States** (sealed-style hierarchy): `Initial`, `Loading`, `Success`, `Failure`. Immutable and `Equatable` so `BlocBuilder` detects changes precisely.
- **Cubits**: Call `LoginUseCase`, receive `Either<Failure, User>`, emit typed states. Persist tokens, handle side effects (navigate, show snackbars).
- **Pages**: Listen to Cubit state via `BlocBuilder<AuthCubit, AuthState>`. Dispatch events on user interaction. Read-only; never mutate state directly.

**Key principle:** Presentation layer has no business logic. It is a thin UI adapter that translates user events into use-case calls and renders state changes.

### Full Project Structure

```
lib/
├── core/                     # Shared across all features
│   ├── constants/            # Colors, text styles, strings
│   ├── di/                   # GetIt composition root (registers all usecases, repos, cubits)
│   ├── errors/               # Exception + Failure hierarchies
│   ├── network/              # DioClient, API endpoint constants
│   ├── router/               # GoRouter config + route names
│   └── widgets/              # Reusable button, text field, loading, error widgets
│
└── features/                 # Each feature is self-contained
    └── auth/                 # Canonical example: complete login flow
        ├── domain/           (business logic, entities, abstract repos)
        │   ├── entities/     (user_entity.dart)
        │   ├── repositories/ (auth_repository.dart — abstract contract)
        │   └── usecases/     (login_usecase.dart — calls repository)
        │
        ├── data/             (API calls, models, concrete repo implementations)
        │   ├── datasources/  (auth_remote_datasource.dart — talks to Dio; throws Exceptions)
        │   ├── models/       (user_model.dart — extends entity; adds fromJson/toJson)
        │   └── repositories/ (auth_repository_impl.dart — implements abstract repo; catches Exceptions → Failures)
        │
        └── presentation/     (Cubit, states, pages/widgets)
            ├── cubit/        (auth_cubit.dart, auth_state.dart)
            └── pages/        (login_page.dart, home_page.dart)
```

### How Data Flows (Login Example)

```
1. User taps "Login" button
   ↓
2. LoginPage calls: authCubit.login(email, password)
   ↓
3. AuthCubit emits AuthLoading()  ← UI shows spinner
   ↓
4. AuthCubit calls: loginUseCase(email, password)  [Domain]
   ↓
5. LoginUseCase delegates to: AuthRepository.login(...)  [Domain contract]
   ↓
6. AuthRepositoryImpl calls: remoteDataSource.login(...)  [Data implementation]
   ↓
7. AuthRemoteDataSource makes HTTP POST to /login via Dio  [External API]
   ↓
   ┌─ Success: Returns JSON with user data
   │  ↓
   │  AuthRepositoryImpl parses JSON → UserModel.fromJson()
   │  ↓
   │  Returns: Right(UserEntity)  [domain-layer type, no exceptions]
   │  ↓
   │  AuthCubit receives UserEntity
   │  ↓
   │  AuthCubit saves token to SharedPreferences [side effect]
   │  ↓
   │  AuthCubit emits: AuthSuccess(user)  ← UI navigates to home
   │
   └─ Failure: Throws ServerException (bad credentials, network error, etc.)
      ↓
      AuthRepositoryImpl catches ServerException
      ↓
      Returns: Left(ServerFailure(message))  [wrapped in domain-layer Failure]
      ↓
      AuthCubit receives Failure
      ↓
      AuthCubit emits: AuthFailure(message)  ← UI shows error snackbar
```

### Why Three Layers?

| Layer | Dependency | Independence | Testing |
|-------|-----------|--------------|---------|
| **Domain** | Nothing | Works offline; testable without Flutter, Dio, or databases | Unit test in pure Dart |
| **Data** | Domain contracts only | Swap HTTP client or database; mock easily | Unit test with `mocktail` data sources; mock repositories |
| **Presentation** | Domain (use cases) + Flutter | Inject mock Cubits for widget tests | `bloc_test` for state flow; `WidgetTester` for UI |

**Key insight:** Each layer depends only on layers toward the center (domain). Presentation depends on domain. Data implements domain. Domain depends on nothing. This prevents leakage and makes code reusable and testable.

## Adding a new feature

Copy the shape of `features/auth/` end to end:

1. **domain/entities/`<thing>`_entity.dart** — immutable, `Equatable`, no Flutter imports.
2. **domain/repositories/`<feature>`_repository.dart** — abstract contract returning `Either<Failure, T>`.
3. **domain/usecases/`<action>`_usecase.dart** — one class per use case; single `call()` method that delegates to the repository.
4. **data/models/`<thing>`_model.dart** — extends the entity, adds `fromJson`/`toJson`.
5. **data/datasources/`<feature>`_remote_datasource.dart** — talks to `DioClient`; throws `ServerException`/`NetworkException`, never returns a `Failure` directly.
6. **data/repositories/`<feature>`_repository_impl.dart** — implements the domain contract; catches exceptions and maps them to `Failure`s.
7. **presentation/cubit/`<feature>`_state.dart** — `Equatable` states (Initial/Loading/Success/Failure or feature-specific).
8. **presentation/cubit/`<feature>`_cubit.dart** — calls the usecase(s), emits states.
9. **presentation/pages/`<feature>`_page.dart** — `BlocBuilder`/`BlocListener` wired to the Cubit, built from `core/widgets/`.
10. **Register** the datasource, repository, usecase(s), and Cubit in `lib/core/di/injection_container.dart` (same section order: external → datasources → repositories → usecases → cubits).
11. **Wire** the Cubit into `MultiBlocProvider` in `main.dart` if it needs to be available above the router (e.g. for redirect logic), and add the route in `app_router.dart`.
12. **Test** each layer (see `test/features/auth/` for the pattern): a usecase test, a repository test with `mocktail`, and a Cubit test with `bloc_test`.

Every public class and method should carry a one/two-line `///` doc comment stating its single responsibility.

## Running

```sh
flutter pub get
flutter analyze
flutter test
flutter run
```

## Demo credentials

The bundled `DioClient` mock interceptor accepts:

- email: `demo@example.com`
- password: `123456`

Remove `_MockInterceptor` in `lib/core/network/dio_client.dart` once a real backend is wired up.
