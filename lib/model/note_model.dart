import 'data.dart';

class NoteModel {
  final int? id;
  final String? title;
  final String? description;

  const NoteModel({this.id,
    this.title,
    this.description
  });

  Map<String, dynamic> toMap()
      {
        return {
          colTitle: title,
          colDescription: description
        };
      }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map[colId],
      title: map[colTitle],
      description: map[colDescription]

    );
  }
}
