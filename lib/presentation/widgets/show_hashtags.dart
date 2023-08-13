import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/data/models/hashtag.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/tem_hashtag.dart';
import '../../business_logic/cubit/hashtags/hashtag_cubit.dart';

class ShowHashtags extends StatelessWidget {
  final List<HashTag> hashtags;
  final List<HashTag> hashtagsFiltered;

  const ShowHashtags(
      {super.key, required this.hashtags, required this.hashtagsFiltered});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: hashtagsFiltered.isNotEmpty,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(horizontalAlign: true, gap: 10),
          SizedBox(
            height: 30.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: hashtagsFiltered.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(
                  right: 11.0,
                ),
                child: InkWell(
                  onTap: () => context
                      .read<HashtagCubit>()
                      .deleteHashTagFiltered(index, hashtags, hashtagsFiltered),
                  child: TempHashTag(hashtag: hashtagsFiltered[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
