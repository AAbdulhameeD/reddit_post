class User {
  String image;

  String name;

  User({required this.image, required this.name});

  factory User.fromMap(Map<Object?, Object?> map) => User(
        image: map["image"].toString(),
        name: map["name"].toString(),
      );
  Map<String,dynamic> toMap()=>{
    "image":image,
    "name":name
  };
}
