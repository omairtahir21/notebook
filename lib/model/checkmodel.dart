class CheckListItem {
  int? id;
  String title;
  final String description; // Store descriptions as a single string

  CheckListItem({
    this.id,
    required this.title,
    required this.description, // Include the description field in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'heading': title,
      'description': description, // Include the description field in the map
    };
  }

  factory CheckListItem.fromMap(Map<String, dynamic> map) {
    final description = map['description'] as String; // Retrieve the description as a string
    final descriptions = description.split('\n'); // Split the string into a list of descriptions
    return CheckListItem(
      id: map['id'],
      title: map['title'],
      description: map['description'], // Retrieve the description as a string
    );
  }

}
