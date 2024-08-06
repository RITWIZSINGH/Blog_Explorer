import 'package:equatable/equatable.dart';

class Blog extends Equatable {
  final String id;
  final String title;
  final String imageUrl;
  final bool isFavorite;

  const Blog(
      {required this.id,
      required this.title,
      required this.imageUrl,
      this.isFavorite = false});

  Blog copyWith({
    String? id,
    String? title,
    String? imageUrl,
    bool? isFavorite,
  }) {
    return Blog(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite
    );
  }

  @override
  List<Object?> get props => [id, title, imageUrl, isFavorite];
}
