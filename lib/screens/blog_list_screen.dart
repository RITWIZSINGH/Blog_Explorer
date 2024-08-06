// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_explorer/blocs/blog_bloc.dart';
import 'package:blog_explorer/blocs/blog_state.dart';
import 'package:blog_explorer/blocs/blog_event.dart';
import 'blog_detail_screen.dart';
import 'package:blog_explorer/models/blog.dart';

class BlogListScreen extends StatelessWidget {
  const BlogListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Blog Explorer'),
        ),
        body: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogInitial) {
              BlocProvider.of<BlogBloc>(context).add(FectBlogs());
              return Center(child: CircularProgressIndicator());
            } else if (state is BlogLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BlogLoaded) {
              return ListView.builder(itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogListItem(blog: blog);
              });
            } else if (state is BlogError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ));
  }
}

class BlogListItem extends StatelessWidget {
  final Blog blog;

  const BlogListItem({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(blog.imageUrl),
      ),
      title: Text(blog.title),
      trailing: IconButton(
        icon: Icon(
          blog.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: blog.isFavorite ? Colors.red : null,
        ),
        onPressed: () {
          BlocProvider.of<BlogBloc>(context).add(ToggleFavorite(blog));
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(),
          ),
        );
      },
    );
  }
}
