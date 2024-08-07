// ignore_for_file: unnecessary_this

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String id;
  final String title;
  final String imageUrl;
  bool isFavorite;
  Timestamp? favoriteTimestamp;

  Blog({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isFavorite = false,
    this.favoriteTimestamp,
  });

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
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      favoriteTimestamp: map['favoriteTimestamp'],
    );
  }

  Blog copyWith({
    bool? isFavorite,
    Timestamp? favoriteTimestamp,
  }) {
    return Blog(
      id: this.id,
      title: this.title,
      imageUrl: this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      favoriteTimestamp: favoriteTimestamp ?? this.favoriteTimestamp,
    );
  }
}

