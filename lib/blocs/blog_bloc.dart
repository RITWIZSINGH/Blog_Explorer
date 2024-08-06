// ignore_for_file: unused_local_variable, empty_catches

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_explorer/services/api_service.dart';
import 'blog_event.dart';
import 'blog_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogBloc extends Bloc<BlogEvent,BlogState>{

  final ApiService _apiService;
  final FirebaseFirestore _firestore;

  BlogBloc(this._apiService,this._firestore):super(BlogInitial()){
    on<FectBlogs>(_onFetchBlogs);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onFetchBlogs(FectBlogs event, Emitter<BlogState> emit) async{
    emit(BlogLoading());
    try{
      final blogs = await _apiService.fetchBlogs();
      final favoritesSnapShot = await _firestore.collection('favorites').get(GetOptions(source: Source.cache));
      final favorites = favoritesSnapShot.docs.map((doc)=>doc.id).toSet();

      final updatedBlogs = blogs.map((blog)=>blog.copyWith(
        isFavorite: favorites.contains(blog.id),
      )).toList();

      emit(BlogLoaded(updatedBlogs));
    }catch(e){
      emit(BlogError('Failed to fetch blogs: $e'));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<BlogState> emit) async {
    final currentState = state;
    if (currentState is BlogLoaded){
      try{
        final updatedBlogs = currentState.blogs.map((blog){
          if(blog.id == event.blog.id){
            final newFavoriteStatus = !blog.isFavorite;
            if(newFavoriteStatus){
              _firestore.collection('favorites').doc(blog.id).set({});
            }else{
              _firestore.collection('favorites').doc(blog.id).delete();
            }
            return blog.copyWith(isFavorite: newFavoriteStatus);
          }
          return blog;
        }).toList();

        emit(BlogLoaded(updatedBlogs));
      }catch(e){
        emit(BlogError('Failed to update favorite status: $e'));
      }
    }
  }
}