class Pokemon {
  final String id;
  final String name;
  final String image;
  final String category;
  final String weight;
  final String height;
  final String abilities;
  bool isMyFav;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.weight,
    required this.height,
    required this.abilities,
    required this.isMyFav,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['name'],
      name: json['name'],
      image: json['image'],
      category: json['category'],
      weight: json['weight'],
      height: json['height'],
      abilities: json['abilities'],
      isMyFav: false,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category,
      'weight': weight,
      'height': height,
      'abilities': abilities,
      'isMyFav': isMyFav,
    };
  }
}
