import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_explorer/blocs/blog_bloc.dart';
import 'package:blog_explorer/blocs/blog_state.dart';
import 'package:blog_explorer/blocs/blog_event.dart';
import 'blog_detail_screen.dart';
import 'package:blog_explorer/models/blog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:async';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen> {
  bool _isOnline = true;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      //if the device is connected to mobile or wifi , it adds an event IneternetGainedEvent
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _isOnline = true;
      } //else it adds the event InternetLostEvent
      else {
        _isOnline = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: Text('SubSpace',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 173, 226, 252))),
          backgroundColor: Colors.black,
        ),
        body: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if (state is BlogInitial) {
              BlocProvider.of<BlogBloc>(context).add(FetchBlogs());
              return Center(child: CircularProgressIndicator());
            } else if (state is BlogLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is BlogLoaded) {
              return AnimationLimiter(
                child: ListView.builder(
                    itemCount: state.blogs.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: BlogCard(
                                blog: state.blogs[index], isOnline: _isOnline),
                          ),
                        ),
                      );
                    }),
              );
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
  final bool isOnline;

  const BlogCard({Key? key, required this.blog, required this.isOnline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            child: CachedNetworkImage(
              imageUrl: blog.imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
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
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            BlogDetailScreen(blog: blog),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          var begin = Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ));
                },
              ),
              if (isOnline)
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: IconButton(
                      key: ValueKey<bool>(blog.isFavorite),
                      onPressed: () {
                        BlocProvider.of<BlogBloc>(context)
                            .add(ToggleFavorite(blog));
                      },
                      icon: Icon(
                        blog.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: blog.isFavorite ? Colors.red : null,
                      )),
                )
            ],
          )
        ],
      ),
    );
  }
}
