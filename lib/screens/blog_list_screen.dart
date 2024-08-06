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
          title:
              Text('SubSpace', style: TextStyle(fontWeight: FontWeight.bold,color: Colors. blueGrey)),
          backgroundColor: Colors.black,
        ),
        body: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogInitial) {
              BlocProvider.of<BlogBloc>(context).add(FectBlogs());
              return Center(child: CircularProgressIndicator());
            } else if (state is BlogLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BlogLoaded) {
              return ListView.builder(
                  itemCount: state.blogs.length,
                  itemBuilder: (context, index) {
                    final blog = state.blogs[index];
                    return BlogCard(blog: blog);
                  });
            } else if (state is BlogError) {
              return Center(child: Text(state.message));
            }
            return Container();
          },
        ));
  }
}

class BlogCard extends StatelessWidget {
  final Blog blog;

  const BlogCard({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: Image.network(
              blog.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              blog.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                child: Text('READ MORE'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailScreen(blog: blog),
                      ));
                },
              ),
              IconButton(
                  onPressed: () {
                    BlocProvider.of<BlogBloc>(context).add(ToggleFavorite(blog));
                  },
                  icon: Icon(
                    blog.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: blog.isFavorite ? Colors.red : null,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
