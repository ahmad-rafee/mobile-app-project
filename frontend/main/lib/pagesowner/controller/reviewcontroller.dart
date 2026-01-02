import "package:main/pagesowner/models/revie.dart";
class ReviewsController {
  List<Review> getReviews() {
    return [
      Review(id: '1', propertyId: '1', rating: 5, comment: 'Excellent place'),
    ];
  }
}
