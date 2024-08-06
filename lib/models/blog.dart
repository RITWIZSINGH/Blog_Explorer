import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Blog extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final bool isFavorite;
  final Timestamp? favoriteTimestamp;

  const Blog(
      {required this.id,
      required this.title,
      required this.imageUrl,
      this.isFavorite = false,
      this.favoriteTimestamp});

  Blog copyWith({
    String? id,
    String? title,
    String? imageUrl,
    bool? isFavorite,
    Timestamp? favoriteTimestamp,
  }) {
    return Blog(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteTimestamp: favoriteTimestamp ?? this.favoriteTimestamp,
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'favoriteTimestamp': favoriteTimestamp,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      isFavorite: map['isFavorite'] ?? false,
      favoriteTimestamp: map['favoriteTimestamp'],
    );
  }

  @override
  List<Object?> get props => [id, title, imageUrl, isFavorite, favoriteTimestamp];
}
