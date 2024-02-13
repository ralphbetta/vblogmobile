import 'package:riverpod/riverpod.dart';
import 'package:vblogmobile/model/blog.model.dart';

final blogProvider = StateNotifierProvider<BlogNotifier, List<BlogPost>>((ref) {
  return BlogNotifier();
});

final numberProvider = StateProvider<int>((ref) {
  return 0;
});

final loadingProvider = StateProvider<bool>((ref) {
  return true;
});


class BlogNotifier extends StateNotifier<List<BlogPost>> {
  BlogNotifier() : super([]);

  void addBlog(BlogPost personModel) {
    state = [...state, personModel];
  }

  void init(List<BlogPost> data){
    state = data;
  }

}