import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vblogmobile/config/size.config.dart';
import 'package:vblogmobile/model/blog.model.dart';
import 'package:vblogmobile/provider/app.provider.dart';
import 'package:vblogmobile/services/graphql.service.dart';
import 'package:vblogmobile/utils/toast.utils.dart';

class FormScreen extends ConsumerWidget {
  final String postId;
  const FormScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _subTitleController = TextEditingController();
    final TextEditingController _bodyController = TextEditingController();
    final TextEditingController _idController = TextEditingController();

    final GraphQLService _graphQLService = GraphQLService();

    BlogPost? blog = ref.watch(postProvider);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Blog Post",
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
                                    bool response =
                                        await _graphQLService.createBlogPost(
                                            title: _titleController.text,
                                            subTitle: _subTitleController.text,
                                            body: _bodyController.text);

                                    if (response) {
                                      List<BlogPost> books = await _graphQLService.blogPosts();
                                      ref.read(blogProvider.notifier).init(books);
                                      if (response) {
                                        if(context.mounted){
                                            showToast( context, "Created Sucessfuly");
                                            Navigator.pop(context);
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        SizedBox(width: 15),
                                        Text(
                                          "Create Post",
                                          style: TextStyle(color: Colors.white),
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
