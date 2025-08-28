import 'package:color_parser/color_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/business_logic/cubit/hashtags/hashtag_cubit.dart';
import 'package:note_app/data/models/hashtag.dart';
import 'package:note_app/presentation/widgets/custom_text_field.dart';
import 'package:note_app/presentation/widgets/gap.dart';
import 'package:note_app/presentation/widgets/google_text.dart';
import 'package:note_app/presentation/widgets/progress_indicator.dart';
import 'package:note_app/utils/constants.dart';

class HashtagManagementPage extends StatefulWidget {
  const HashtagManagementPage({super.key});

  @override
  State<HashtagManagementPage> createState() => _HashtagManagementPageState();
}

class _HashtagManagementPageState extends State<HashtagManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hashTagController = TextEditingController();
  Color _pickerColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    // Refresh hashtags list
    context.read<HashtagCubit>().getHashTags();
  }

  @override
  void dispose() {
    _hashTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const GoogleText(
          text: "Gérer les hashtags",
          fontWeight: true,
          fontSize: 20,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => _showAddHashtagDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<HashtagCubit, HashtagState>(
        listener: (context, state) {
          if (state is HashTagsAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: GoogleText(text: "Hashtag ajouté"),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is HashTagUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: GoogleText(text: "Hashtag mis à jour"),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is HashTagsDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: GoogleText(text: "Hashtag supprimé"),
                backgroundColor: Colors.green,
              ),
            );
          }
          if (state is HashTagInUse) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GoogleText(text: state.message),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }
          if (state is DeletingHashTagFailed || 
              state is AddingHashTagFailed || 
              state is UpdatingHashTagFailed) {
            String error = "";
            if (state is DeletingHashTagFailed) error = state.error;
            if (state is AddingHashTagFailed) error = state.error;
            if (state is UpdatingHashTagFailed) error = state.error;
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: GoogleText(text: "Erreur: $error"),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GettingAllHashTags || 
              state is DeletingHashTag || 
              state is UpdatingHashTag ||
              state is CheckingHashTagUsage) {
            return const Center(
              child: CustomProgressIndicator(),
            );
          }

          if (state is HashTagsGotten) {
            // Filter out "Tout" hashtag from management
            final hashtags = state.hashTags
                .where((tag) => tag.label != "Tout")
                .toList();

            if (hashtags.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.tag,
                      size: 80,
                      color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
                    ),
                    const Gap(horizontalAlign: false, gap: 16),
                    GoogleText(
                      text: "Aucun hashtag",
                      fontSize: 18,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const Gap(horizontalAlign: false, gap: 8),
                    ElevatedButton.icon(
                      onPressed: () => _showAddHashtagDialog(context),
                      icon: const Icon(Icons.add),
                      label: const GoogleText(
                        text: "Ajouter un hashtag",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: hashtags.length,
              itemBuilder: (context, index) {
                final hashtag = hashtags[index];
                return _buildHashtagItem(context, hashtag);
              },
            );
          }

          return const Center(
            child: GoogleText(text: "Une erreur s'est produite"),
          );
        },
      ),
    );
  }

  Widget _buildHashtagItem(BuildContext context, HashTag hashtag) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showEditHashtagDialog(context, hashtag),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Modifier',
            ),
            SlidableAction(
              onPressed: (_) => _confirmDelete(context, hashtag),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Supprimer',
            ),
          ],
        ),
        child: Card(
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hexToColor(hashtag.color),
                shape: BoxShape.circle,
              ),
            ),
            title: GoogleText(
              text: hashtag.label,
              fontSize: 16,
              fontWeight: true,
            ),
            subtitle: GoogleText(
              text: "Créé le ${_formatDate(hashtag.creationDate)}",
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            trailing: Icon(
              Icons.drag_indicator,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  Future<void> _showAddHashtagDialog(BuildContext context) {
    _hashTagController.clear();
    _pickerColor = Colors.blue;
    
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const GoogleText(
                text: "Ajouter un hashtag",
                fontWeight: true,
                fontSize: 20,
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: CustomTextField(
                        controller: _hashTagController,
                        size: 15,
                        hintText: "Nom du hashtag",
                        letterSpacing: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez donner un nom à votre hashtag";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Gap(horizontalAlign: false, gap: 16),
                    const GoogleText(
                      text: "Choisissez une couleur",
                      fontWeight: true,
                      fontSize: 15,
                    ),
                    const Gap(horizontalAlign: false, gap: 10),
                    MaterialPicker(
                      pickerColor: _pickerColor,
                      onColorChanged: (color) {
                        setDialogState(() {
                          _pickerColor = color;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const GoogleText(text: "Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final String color = ColorParser.color(_pickerColor).toHex();
                      final newHashTag = HashTag(
                        id: DateTime.now().toString(),
                        label: _hashTagController.text.trim(),
                        color: color,
                        creationDate: DateTime.now(),
                        userId: '',
                      );
                      
                      // Get current hashtags from state
                      if (context.read<HashtagCubit>().state is HashTagsGotten) {
                        final currentState = context.read<HashtagCubit>().state as HashTagsGotten;
                        context.read<HashtagCubit>().addHashTag(
                          newHashTag,
                          currentState.hashTags.toList(),
                          [],
                        );
                      }
                      
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const GoogleText(
                    text: "Ajouter",
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showEditHashtagDialog(BuildContext context, HashTag hashtag) {
    _hashTagController.text = hashtag.label;
    _pickerColor = hexToColor(hashtag.color);
    
    return showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const GoogleText(
                text: "Modifier le hashtag",
                fontWeight: true,
                fontSize: 20,
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: CustomTextField(
                        controller: _hashTagController,
                        size: 15,
                        hintText: "Nom du hashtag",
                        letterSpacing: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Veuillez donner un nom à votre hashtag";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Gap(horizontalAlign: false, gap: 16),
                    const GoogleText(
                      text: "Choisissez une couleur",
                      fontWeight: true,
                      fontSize: 15,
                    ),
                    const Gap(horizontalAlign: false, gap: 10),
                    MaterialPicker(
                      pickerColor: _pickerColor,
                      onColorChanged: (color) {
                        setDialogState(() {
                          _pickerColor = color;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const GoogleText(text: "Annuler"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final String color = ColorParser.color(_pickerColor).toHex();
                      final updatedHashTag = hashtag.copyWith(
                        label: _hashTagController.text.trim(),
                        color: color,
                      );
                      
                      context.read<HashtagCubit>().updateHashTag(updatedHashTag);
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const GoogleText(
                    text: "Mettre à jour",
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, HashTag hashtag) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const GoogleText(
            text: "Confirmer la suppression",
            fontWeight: true,
            fontSize: 20,
          ),
          content: GoogleText(
            text: "Êtes-vous sûr de vouloir supprimer le hashtag '${hashtag.label}' ?",
            fontSize: 16,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const GoogleText(text: "Annuler"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<HashtagCubit>().deleteHashTag(hashtag.id);
                Navigator.of(dialogContext).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const GoogleText(
                text: "Supprimer",
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }
}
