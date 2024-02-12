// class MyModel {
//   String? title;
//   String? description;
//   String? date;
//
//   MyModel({this.title, this.description, this.date});
//
//   MyModel.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     description = json['description'];
//     date = json['date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['date'] = this.date;
//     return data;
//   }
// }


class AddNote {
  int? id;
  String heading;
  String description; // Add a description field
  bool? pinned;
  String color; // Add a color property

  AddNote({
    this.id,
    required this.heading,
    required this.description,
    this.color ="yellow",
    this.pinned,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'heading': heading,
      'description': description, // Include description in the map
    };
  }

  factory AddNote.fromMap(Map<String, dynamic> map) {
    return AddNote(
      id: map['id'],
      heading: map['heading'],
      description: map['description'], // Retrieve description from the map
    );
  }
}
