// ignore_for_file: unused_local_variable, empty_catches

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_explorer/services/api_service.dart';
import 'blog_event.dart';
import 'blog_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blog_explorer/models/blog.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final ApiService _apiService;
  final FirebaseFirestore _firestore;

  BlogBloc(this._apiService, this._firestore) : super(BlogInitial()) {
    on<FetchBlogs>(_onFetchBlogs);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetchBlogs(FetchBlogs event, Emitter<BlogState> emit) async {
    emit(BlogLoading());
    try {
      List<Blog> blogs = await _apiService.fetchBlogs();
      final favoritesSnapshot = await _firestore.collection('favorites').get();
      
      final favorites = Map.fromEntries(
        favoritesSnapshot.docs.map((doc) => MapEntry(doc.id, doc.data()['favoriteTimestamp'] as Timestamp?))
      );

      blogs = blogs.map((blog) {
        final isFavorite = favorites.containsKey(blog.id);
        return blog.copyWith(
          isFavorite: isFavorite,
          favoriteTimestamp: favorites[blog.id],
        );
      }).toList();
      
      emit(BlogLoaded(blogs));
    } catch (e) {
      try {
        final favoritesSnapshot = await _firestore.collection('favorites').get();
        final favoriteBlogs = favoritesSnapshot.docs.map((doc) => Blog.fromMap(doc.data())).toList();
        if (favoriteBlogs.isNotEmpty) {
          emit(BlogLoaded(favoriteBlogs));
        } else {
          emit(BlogError('No favorite blogs available offline'));
        }
      } catch (e) {
        emit(BlogError('Failed to fetch blogs: $e'));
      }
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<BlogState> emit) async {
    final currentState = state;
    if (currentState is BlogLoaded) {
      try {
        final updatedBlogs = currentState.blogs.map((blog) {
          if (blog.id == event.blog.id) {
            final newFavoriteStatus = !blog.isFavorite;
            final newTimestamp = newFavoriteStatus ? Timestamp.now() : null;
            if (newFavoriteStatus) {
              _firestore.collection('favorites').doc(blog.id).set({
                ...blog.toMap(),
                'favoriteTimestamp': newTimestamp,
              });
            } else {
              _firestore.collection('favorites').doc(blog.id).delete();
            }
            return blog.copyWith(isFavorite: newFavoriteStatus, favoriteTimestamp: newTimestamp);
          }
          return blog;
        }).toList();

        emit(BlogLoaded(updatedBlogs));
      } catch (e) {
        emit(BlogError('Failed to update favorite status: $e'));
      }
    }
  }
}