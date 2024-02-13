import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vblogmobile/config/size.config.dart';
import 'package:vblogmobile/constant/route.path.dart';
import 'package:vblogmobile/model/blog.model.dart';
import 'package:vblogmobile/provider/app.provider.dart';
import 'package:vblogmobile/services/graphql.service.dart';
import 'package:vblogmobile/utils/toast.utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPost extends ConsumerStatefulWidget {
  final BlogPost? post;
  const EditPost({super.key, this.post});

  @override
  ConsumerState<EditPost> createState() => _PostDetailsState();
}

class _PostDetailsState extends ConsumerState<EditPost>
    with SingleTickerProviderStateMixin {
  final GraphQLService _graphQLService = GraphQLService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    _titleController.text = widget.post!.title ?? "";
    _subTitleController.text = widget.post!.subTitle ?? "";
    _bodyController.text = widget.post!.body ?? "";
    _idController.text = widget.post!.id ?? "";
  }

  @override
  Widget build(BuildContext context) {
    BlogPost? _blogPost = ref.watch(postProvider);
    bool loading = ref.watch(loadingProvider);


    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Edit Blog Post",
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color!),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).highlightColor),
                    child: TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          hintText: "Enter post title",
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).highlightColor),
                    child: TextFormField(
                      controller: _subTitleController,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          hintText: "Enter post subtitle",
                          border: InputBorder.none),
                    ),
                  ),
                  Container(
                    height: AppSize.height(20),
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).highlightColor),
                    child: TextFormField(
                      controller: _bodyController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 9,
                      decoration: const InputDecoration(
                          hintText: "Enter post body",
                          border: InputBorder.none),
                    ),
                  ),
                ],
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
                            onTap: () async {
                              ref.read(loadingProvider.notifier).state = true;

                              bool response =
                                  await _graphQLService.updateBlogPost(
                                      blogId: _idController.text,
                                      title: _titleController.text,
                                      subTitle: _subTitleController.text,
                                      body: _bodyController.text);

                              if (response) {
                                List<BlogPost> books =
                                    await _graphQLService.blogPosts();
                                ref.read(blogProvider.notifier).init(books);
                                if (response) {
                                  if (context.mounted) {
                                    showToast(context, "Updated Sucessfuly");
                                    ref.read(loadingProvider.notifier).state =
                                        false;
                                    context.pushReplacement(AppRoutes.home);
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                 const SizedBox(width: 15),
                                  Text(
                                   loading? "Submiting": "Update Post",
                                    style: const TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
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
