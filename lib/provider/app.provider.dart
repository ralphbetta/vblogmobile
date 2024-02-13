import 'package:riverpod/riverpod.dart';
import 'package:vblogmobile/model/blog.model.dart';
import 'package:vblogmobile/services/graphql.service.dart';

final blogProvider = StateNotifierProvider<BlogNotifier, List<BlogPost>>((ref) {
  return BlogNotifier();
});

final numberProvider = StateProvider<int>((ref) {
  return 0;
});

final postProvider = StateProvider<BlogPost?>((ref) {
  return null;
});

final loadingProvider = StateProvider<bool>((ref) {
  return true;
});

final GraphQLService _graphQLService = GraphQLService();

class BlogNotifier extends StateNotifier<List<BlogPost>> {
  BlogNotifier() : super([]);


  void addBlog(BlogPost personModel) {
    state = [...state, personModel];
  }

  void updatePost(BlogPost personModel) async {
    bool response = await _graphQLService.updateBlogPost(
        blogId: personModel.id!,
        title: personModel.title!,
        subTitle: personModel.subTitle!,
        body: personModel.body!);

    if (response) {
      List<BlogPost> blogs = await _graphQLService.blogPosts();
      if (response) {
        state = blogs;
      }
    }

  }

  void init(List<BlogPost> data) {
    state = data;
  }
}
