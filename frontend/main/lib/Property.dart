class Property {
  final String title;
  final String price;
  final String location;
  final String imageUrl;
  bool isSaved;

  Property({
    required this.title,
    required this.price,
    required this.location,
    required this.imageUrl,
    required this.isSaved,
  });
}

List<Property> properties = [
  Property(
    title: "Modern House",
    price: "\$450/2month",
    location: "Syria/Damascus",
    imageUrl: "images/build1.png",
    isSaved: false,
  ),
  Property(
    title: "Luxury Villa",
    price: "\$1200/month",
    location: "Bahamas",
    imageUrl: "images/build3.png",
    isSaved: false,
  ),
  Property(
    title: "Red Cottage",
    price: "\$290/month",
    location: "Sweden/Dalarna",
    imageUrl: "images/build4.png",
    isSaved: false,
  ),
  Property(
    title: "building",
    price: "\$290/3months",
    location: "Jordon/Amman",
    imageUrl: "images/build2.png",
    isSaved: false,
  ),
  Property(
    title: "Farm",
    price: "\$290/month",
    location: "Scotland/Tayside",
    imageUrl: "images/build6.png",
    isSaved: false,
  ),
  Property(
    title: "Small House",
    price: "\$290/month",
    location: "UAE/Dubai",
    imageUrl: "images/build7.png",
    isSaved: false,
  ),
  Property(
    title: "Car office",
    price: "\$290/month",
    location: "Russia/Moscow",
    imageUrl: "images/build8.png",
    isSaved: false,
  ),
];
