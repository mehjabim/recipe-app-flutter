import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String id;
  final String name;
  final String image;
  final String cal;
  final String time;
  final String rate;
  final String reviews;
  final String category;
  final List<double> ingredientsAmount;
  final List<String> ingredientsName;
  final List<String> ingredientsImage;
  final String? description;

  RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    required this.cal,
    required this.time,
    required this.rate,
    required this.reviews,
    required this.category,
    required this.ingredientsAmount,
    required this.ingredientsName,
    required this.ingredientsImage,
    this.description,
  });

  factory RecipeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return RecipeModel.fromMap(data, doc.id);
  }

  factory RecipeModel.fromMap(Map<String, dynamic> data, String id) {
    final rawAmounts = data['ingredientsAmount'];
    List<double> amounts = [];
    if (rawAmounts is List) {
      amounts = rawAmounts.map((e) => double.tryParse(e.toString()) ?? 0.0).toList();
    }

    final rawNames = data['ingredientsName'];
    List<String> names = [];
    if (rawNames is List) {
      names = rawNames.map((e) => e.toString()).toList();
    }

    final rawImages = data['ingredientsImage'];
    List<String> images = [];
    if (rawImages is List) {
      images = rawImages.map((e) => e.toString()).toList();
    }

    return RecipeModel(
      id: id,
      name: data['name']?.toString() ?? "Wholesome Dish",
      image: data['image']?.toString() ?? "",
      cal: data['cal']?.toString() ?? "250",
      time: data['time']?.toString() ?? "20",
      rate: data['rate']?.toString() ?? "4.9",
      reviews: data['reviews']?.toString() ?? "42",
      category: data['category']?.toString() ?? "Mindful Bowls",
      ingredientsAmount: amounts,
      ingredientsName: names,
      ingredientsImage: images,
      description: data['description']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'cal': cal,
      'time': time,
      'rate': rate,
      'reviews': reviews,
      'category': category,
      'ingredientsAmount': ingredientsAmount,
      'ingredientsName': ingredientsName,
      'ingredientsImage': ingredientsImage,
      if (description != null) 'description': description,
    };
  }
}
