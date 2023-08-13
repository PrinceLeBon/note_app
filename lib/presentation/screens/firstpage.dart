import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/business_logic/cubit/hashtags/hashtag_cubit.dart';
import 'package:note_app/business_logic/cubit/notes/note_cubit.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/presentation/widgets/hashtags.dart';
import 'package:note_app/presentation/widgets/note.dart';
import '../../utils/constants.dart';
import '../widgets/gap.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GoogleText(
              text: "My Notes",
              fontSize: 50,
              fontWeight: true,
            ),
            const Gap(horizontalAlign: false, gap: 10),
            BlocBuilder<HashtagCubit, HashtagState>(
              builder: (context, state) {
                if (state is HashTagsGotten) {
                  if (state.hashTags.isNotEmpty) {
                    return SizedBox(
                      height: 40,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.hashTags.length,
                          itemBuilder: (context, index) {
                            return Hashtags(
                              hashtag: state.hashTags[index],
                            );
                          }),
                    );
                  }
                  return const Center(
                    child:
                        GoogleText(text: "Vous n'avez pas encore de hashtags"),
                  );
                }
                return (state is GettingAllHashTags)
                    ? CircularProgressIndicator(
                        color: whiteColor,
                      )
                    : (state is GettingAllHashTagsFailed)
                        ? Row(
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: GoogleText(
                                      text:
                                          "Nous n'avons pas pu récupérer vos hashtags, veuillez rééssayer"),
                                ),
                              ),
                              IconButton(
                                  onPressed: () => context
                                      .read<HashtagCubit>()
                                      .getHashTags(),
                                  icon: Icon(
                                    Icons.download,
                                    color: whiteColor,
                                  ))
                            ],
                          )
                        : Container();
              },
            ),
            const Gap(horizontalAlign: false, gap: 10),
            BlocBuilder<NoteCubit, NoteState>(
              builder: (context, state) {
                if (state is NotesGotten) {
                  if (state.notesFiltered.isNotEmpty) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: state.notesFiltered.length,
                        itemBuilder: (context, index) {
                          return Note(
                            title: state.notesFiltered[index].title,
                            label: state.notesFiltered[index].note,
                          );
                        });
                  }
                  return const Center(
                    child: GoogleText(text: "Vous n'avez pas encore de notes"),
                  );
                }
                return (state is GettingAllNotes)
                    ? CircularProgressIndicator(
                        color: whiteColor,
                      )
                    : (state is GettingAllNotesFailed)
                        ? Row(
                            children: [
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: GoogleText(
                                      text:
                                          "Nous n'avons pas pu récupérer vos notes, veuillez rééssayer"),
                                ),
                              ),
                              IconButton(
                                  onPressed: () =>
                                      context.read<NoteCubit>().getNotes(),
                                  icon: Icon(
                                    Icons.download,
                                    color: whiteColor,
                                  ))
                            ],
                          )
                        : Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
