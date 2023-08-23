import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:note_app/business_logic/cubit/hashtags/hashtag_cubit.dart';
import 'package:note_app/business_logic/cubit/notes/note_cubit.dart';
import 'package:note_app/data/models/hashtag.dart';
import 'package:note_app/data/models/note.dart';
import 'package:note_app/data/repositories/hashtag.dart';
import 'package:note_app/data/repositories/note.dart';
import 'package:note_app/presentation/screens/splash_screen.dart';
import 'package:note_app/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(HashTagAdapter());
  await Hive.openBox("Notes");
  await Hive.openBox("User");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<NoteRepository>(
            create: (context) => NoteRepository()),
        RepositoryProvider<HashTagRepository>(
            create: (context) => HashTagRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
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
        ],
        child: MaterialApp(
          theme: ThemeData(
            canvasColor: blackColor,
            scaffoldBackgroundColor: blackColor,
            appBarTheme: AppBarTheme(
              color: blackColor,
            ),
            textTheme: Theme.of(context).textTheme.apply(
                  bodyColor: whiteColor,
                  displayColor: whiteColor,
                ),
          ),
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
