class User_model {
  String id, name, email, pass, image;

  User_model({
    required this.id,
    required this.name,
    required this.email,
    required this.pass,
    required this.image,
  });

  User_model.from_json(map)
    : this(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        pass: map['pass'],
        image: map['image'],
      );

  to_json() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'pass': pass,
      'image': image,
    };
  }
}
