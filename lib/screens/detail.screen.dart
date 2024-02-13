import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vblogmobile/config/size.config.dart';
import 'package:vblogmobile/constant/constant.dart';
import 'package:vblogmobile/constant/route.path.dart';
import 'package:vblogmobile/model/blog.model.dart';
import 'package:vblogmobile/provider/app.provider.dart';
import 'package:vblogmobile/services/graphql.service.dart';
import 'package:vblogmobile/utils/toast.utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostDetails extends ConsumerStatefulWidget {
  final String postId;
  const PostDetails({super.key, required this.postId});

  @override
  ConsumerState<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends ConsumerState<PostDetails>
    with SingleTickerProviderStateMixin {
  final GraphQLService _graphQLService = GraphQLService();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    BlogPost? data = await _graphQLService.singleBlog(blogId: widget.postId);
    ref.read(postProvider.notifier).state = data;
  }

  @override
  Widget build(BuildContext context) {
    BlogPost? _blogPost = ref.watch(postProvider);
    bool loading = ref.watch(loadingProvider);


    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Blog Detail",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color!),
          ),
        ),
        body: _blogPost == null
            ? const Center(child: Text("Loading..."))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeInRight(
                            child: Text(_blogPost.title ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 22)),
                          ),
                          ZoomIn(
                            child: Container(
                              height: AppSize.height(20),
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(bannerUrl),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                          FadeInUp(
                            child: Text(
                              _blogPost.subTitle ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontSize: 18),
                            ),
                          ),
                          SizedBox(height: 10),
                          SlideInUp(
                               delay: Duration(milliseconds: 1 * 400),

                            child: Text(
                              _blogPost.body ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
                  SizedBox(
                    width: double.infinity,
                    height: AppSize.height(15),
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: (){
                                    context.push(AppRoutes.editscreen, extra: _blogPost);
                                  },
                                  child: FadeInLeft(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            "Edit Post",
                                            style: TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {

                                    ref.read(loadingProvider.notifier).state = true;
                                    bool response = await _graphQLService
                                        .deleteBlog(blogId: _blogPost.id!);
                                    List<BlogPost> books =
                                        await _graphQLService.blogPosts();
                                    ref.read(blogProvider.notifier).init(books);
                                    if (response) {
                                    ref.read(loadingProvider.notifier).state = false;
                                     if(mounted){
                                       context.pop();
                                      showToast(context, "Deleted Succesfully");
                                     }
                                    }
                                  },
                                  child: FadeInRight(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 15),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: Colors.red),
                                      child: Row(
                                        children:  [
                                          const Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                          ),
                                         const SizedBox(width: 15),
                                          Text(
                                            loading ? "Deleting": "Delete Post",
                                            style: const TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
  }
}
