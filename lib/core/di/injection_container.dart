// Single composition root: registers every dependency with GetIt in layer
// order (external -> datasources -> repositories -> usecases -> cubits).
// Add new features here following the same section pattern.

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../network/dio_client.dart';

// Auth — Data
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';

// Auth — Domain
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';

// Auth — Presentation
import '../../features/auth/presentation/cubit/auth_cubit.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initializes all application dependencies.
/// Must be called before [runApp] in `main`.
Future<void> initDependencies() async {
  // ─────────────────────────────────────────
  // 1. External / third-party
  // ─────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // ─────────────────────────────────────────
  // 2. Core — DioClient (singleton)
  // ─────────────────────────────────────────
  sl.registerSingleton<DioClient>(DioClient());

  // ─────────────────────────────────────────
  // 3. Data Sources (lazy singleton)
  // ─────────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );

  // ─────────────────────────────────────────
  // 4. Repositories (lazy singleton)
  // ─────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // ─────────────────────────────────────────
  // 5. Use Cases (factory — new instance every time)
  // ─────────────────────────────────────────
  sl.registerFactory<LoginUseCase>(
    () => LoginUseCase(repository: sl()),
  );

  // ─────────────────────────────────────────
  // 6. Cubits (factory — new instance per BlocProvider)
  // ─────────────────────────────────────────
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(loginUseCase: sl()),
  );
}
