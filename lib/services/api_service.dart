import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blog_explorer/models/blog.dart';

class ApiService{
  static const String _baseUrl = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  static const String _adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

  Future<List<Blog>> fetchBlogs() async {

    try{
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {'x-hasura-admin-secret': _adminSecret}
      );

      if(response.statusCode == 200){
        final List<dynamic> data = json.decode(response.body)['blogs'];
        return data.map((json)=>Blog(id: json['id'], title: json['title'], imageUrl: json['image_url'],)).toList();
      }else{
        throw Exception('Failed to load blogs');
      }
    }catch(e){
      throw Exception('Error Fetching Blogs: $e');
    }

  }
}