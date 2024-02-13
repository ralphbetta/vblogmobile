import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vblogmobile/config/size.config.dart';
import 'package:vblogmobile/constant/constant.dart';
import 'package:vblogmobile/model/blog.model.dart';
import 'package:vblogmobile/services/graphql.service.dart';
import 'package:vblogmobile/utils/toast.utils.dart';

class PostDetails extends StatefulWidget {
  final String postId;
  const PostDetails({super.key, required this.postId});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> with SingleTickerProviderStateMixin {
  final GraphQLService _graphQLService = GraphQLService();
  BlogPost? _blogPost;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _blogPost = await _graphQLService.singleBlog(blogId: widget.postId);
    setState(() => {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Blog Detail", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color!),),
        ),
        body: _blogPost == null
            ? const Center(child: Text("Loading..."))
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
               
               Expanded(
                child: Padding(
                       padding: const EdgeInsets.symmetric(
                horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(_blogPost!.title?? "",  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                            
                    Container(
                      height: AppSize.height(20),
                       width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(image: NetworkImage(bannerUrl), fit: BoxFit.fill)
                      ),
                      
                    ),            
                    Text(_blogPost!.subTitle?? "", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),),
                    Text(_blogPost!.body?? "", style: Theme.of(context).textTheme.bodySmall,)
                  ],
                               ),
                )),
            SizedBox(            
            width: double.infinity,
            height: AppSize.height(15),

            child: Column(
              children: [

                const Divider(thickness: 2,),
                Padding(
                      padding: const EdgeInsets.symmetric(
                horizontal: 15, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                           padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 15
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Theme.of(context).primaryColor,
                
                          ),
                          child: Row(
                           children: const [
                              Icon(Icons.edit, color: Colors.white,),
                              SizedBox(width: 15),
                             Text("Edit Post", style: TextStyle(color: Colors.white),)
                           ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                       Expanded(
                        child: InkWell(
                          onTap: () async{
                          bool response = await _graphQLService.deleteBlog(blogId: _blogPost!.id!);

                          if(response){
                            context.pop();
                             showToast(context, "Deleted Succesfully");

                          }

                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                               color: Colors.red
                                       
                            ),
                            child: Row(
                             children: const [
                               Icon(Icons.delete_forever, color: Colors.white,),
                               SizedBox(width: 15),
                               Text("Delete Post", style: TextStyle(color: Colors.white),)
                             ],
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
