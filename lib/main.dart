import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/business_logic/cubit/hashtags/hashtag_cubit.dart';
import 'package:note_app/business_logic/cubit/notes/note_cubit.dart';
import 'package:note_app/business_logic/cubit/sync/sync_cubit.dart';
import 'package:note_app/business_logic/cubit/theme/theme_cubit.dart';
import 'package:note_app/business_logic/cubit/users/user_cubit.dart';
import 'package:note_app/data/models/hashtag.dart';
import 'package:note_app/data/models/note.dart';
import 'package:note_app/data/models/sync_operation.dart';
import 'package:note_app/data/providers/firestore.dart';
import 'package:note_app/data/repositories/hashtag.dart';
import 'package:note_app/data/repositories/note.dart';
import 'package:note_app/data/repositories/user.dart';
import 'package:note_app/presentation/screens/splash_screen.dart';
import 'package:note_app/services/connectivity_service.dart';
import 'package:note_app/services/sync_service.dart';
import 'package:note_app/utils/app_theme.dart';

import 'data/models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(HashTagAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(SyncOperationAdapter());

  await Hive.openBox("Notes");
  await Hive.openBox("User");
  await Hive.openBox("sync_queue");

  final connectivityService = ConnectivityService();
  connectivityService.initialize();

  final syncService = SyncService(
    firestoreAPI: const FirestoreAPI(),
    connectivityService: connectivityService,
  );
  syncService.initialize();

  runApp(MyApp(
    connectivityService: connectivityService,
    syncService: syncService,
  ));
}

class MyApp extends StatelessWidget {
  final ConnectivityService connectivityService;
  final SyncService syncService;

  const MyApp({
    super.key,
    required this.connectivityService,
    required this.syncService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ConnectivityService>(
          create: (_) => connectivityService,
        ),
        RepositoryProvider<SyncService>(
          create: (_) => syncService,
        ),
        RepositoryProvider<NoteRepository>(
          create: (context) => NoteRepository(
            connectivityService: connectivityService,
            syncService: syncService,
          ),
        ),
        RepositoryProvider<HashTagRepository>(
          create: (context) => HashTagRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (context) => UserRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (BuildContext context) => ThemeCubit(),
          ),
          BlocProvider<SyncCubit>(
            create: (BuildContext context) => SyncCubit(
              syncService: RepositoryProvider.of<SyncService>(context),
            ),
          ),
          BlocProvider<NoteCubit>(
            create: (BuildContext context) => NoteCubit(
                noteRepository: RepositoryProvider.of<NoteRepository>(context))
              ..getNotes(),
          ),
          BlocProvider<HashtagCubit>(
            create: (BuildContext context) => HashtagCubit(
                hashTagRepository:
                    RepositoryProvider.of<HashTagRepository>(context))
              ..getHashTags(),
          ),
          BlocProvider<UserCubit>(
            create: (BuildContext context) => UserCubit(
                userRepository: RepositoryProvider.of<UserRepository>(context)),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return MaterialApp(
              title: 'Note App',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeState.themeMode,
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
