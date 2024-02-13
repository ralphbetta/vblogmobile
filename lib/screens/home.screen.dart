import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vblogmobile/config/size.config.dart';
import 'package:vblogmobile/config/theme.config.dart';
import 'package:vblogmobile/constant/constant.dart';
import 'package:vblogmobile/constant/route.path.dart';
import 'package:vblogmobile/model/blog.model.dart';
import 'package:vblogmobile/provider/app.provider.dart';
import 'package:vblogmobile/provider/theme.provider.dart';
import 'package:vblogmobile/services/graphql.service.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final GraphQLService _graphQLService = GraphQLService();

  void _load() async {
    List<BlogPost> books = await _graphQLService.blogPosts();
    ref.read(blogProvider.notifier).init(books);
    ref.read(loadingProvider.notifier).state = false;
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  List<String> categories = [
    'All',
    "Business",
    "Crypto",
    "Gaming",
    "Technology"
  ];

  @override
  Widget build(BuildContext context) {
    
    AppSize().init(context);
    bool isLoading = ref.watch(loadingProvider);
    int catIndex = ref.watch(numberProvider);

    List<BlogPost> blogs = ref.watch(blogProvider);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness:
                ThemeClass.themeNotifier.value != ThemeMode.dark
                    ? Brightness.light
                    : Brightness.dark),
        title: Container(),
        actions: [
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("vBlogs",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(
                "Today ${DateFormat("MMMM dd").format(DateTime.now())}",
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).highlightColor)),
                      child: const Icon(Icons.notifications_outlined)),
                  Positioned(
                    right: 9,
                    top: 10,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )
                ],
              ),
              GestureDetector(
                onTap: () {
                  AppTheme().switchTheme();
                },
                child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            width: 1, color: Theme.of(context).highlightColor)),
                    child: Icon(
                      ThemeClass.themeNotifier.value != ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                    )),
              ),
            ],
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*---------------------------------------
                    SEARCH SECTION
                  --------------------------------------------*/

                  Container(
                    decoration: BoxDecoration(
                        color:
                            Theme.of(context).highlightColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50)),
                    margin: const EdgeInsets.symmetric(vertical: 18),
                    child: TextFormField(
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: const Icon(Icons.sort),
                            ),
                          ),
                          hintText: "Search Article",
                          contentPadding: const EdgeInsets.only(
                              top: 18, left: 20, bottom: 18),
                          border: InputBorder.none),
                    ),
                  ),

                  /*---------------------------------------
                    CATEGORY SECTION
                  --------------------------------------------*/

                  SizedBox(
                    height: 35,
                    child: ListView.builder(
                        itemCount: categories.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              ref.read(numberProvider.notifier).state = index;
                            },
                            child: SlideInUp(
                              delay: Duration(milliseconds: index * 100),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: catIndex != index
                                          ? Theme.of(context)
                                              .highlightColor
                                              .withOpacity(0.2)
                                          : Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!,
                                      borderRadius: BorderRadius.circular(20)),
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  child: Center(
                                      child: Text(
                                    categories[index],
                                    style: TextStyle(
                                        color: catIndex != index
                                            ? Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .color!
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor),
                                  ))),
                            ),
                          );
                        }),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: BounceInLeft(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Trending",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  "View More",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor),
                                )
                              ],
                            ),
                          ),
                        ),

                   /*---------------------------------------
                   SECTION ONE BLOGS
                  --------------------------------------------*/
                        SizedBox(
                          height: AppSize.height(32),
                          child: ListView.builder(
                              itemCount: blogs.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    context.push(AppRoutes.postDetails, extra: blogs[index].id);
                                  },
                                  child: SlideInUp(
                                    delay: Duration(milliseconds: index * 400),
                                    child: Container(
                                        width: AppSize.width(60),
                                        decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Theme.of(context)
                                                      .shadowColor
                                                      .withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 20)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        margin: const EdgeInsets.only(
                                            right: 25, left: 4, top: 4, bottom: 6),
                                        // padding: const EdgeInsets.symmetric(
                                        //     horizontal: 15, vertical: 8),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              height: AppSize.height(18),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                      image:
                                                          NetworkImage(bannerUrl),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: AppSize.height(7.5),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                          width: AppSize.width(50),
                                                          child: Text(
                                                            blogs[index].title!,
                                                            style: const TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "All",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.calendar_today,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          Text(
                                                            DateFormat("MMM dd")
                                                                .format(blogs[index]
                                                                    .dateCreated!),
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.w300,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 5),
                                                          const Icon(
                                                            Icons.visibility,
                                                            size: 15,
                                                          ),
                                                          const SizedBox(width: 5),
                                                          const Text(
                                                            "22K",
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight.w300,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Trending",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "View More",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        ),
                        ...List.generate(
                            blogs.length,
                            (index) => InkWell(
                              onTap: (){
                                context.push(AppRoutes.postDetails, extra: blogs.reversed.toList()[index].id);

                              },
                              child: SlideInLeft(
                                  delay: Duration(milliseconds: index * 400),
                                child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, right: 5, left: 5),
                                      width: double.infinity,
                                      height: AppSize.height(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Theme.of(context).scaffoldBackgroundColor,
                                                        
                                        boxShadow: [
                                          BoxShadow(
                                              color: Theme.of(context)
                                                  .shadowColor
                                                  .withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 20)
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: AppSize.width(28),
                                            decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.horizontal(
                                                left: Radius.circular(10)
                                              ),
                                               color: Theme.of(context).shadowColor,
                                              image: DecorationImage(image: NetworkImage(blogs.reversed.toList()[index].image!), fit: BoxFit.cover),
                                            ),
                                            margin: const EdgeInsets.only(right: 5),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: AppSize.height(7.5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: AppSize.width(50),
                                                        child: Text(
                                                          blogs.reversed.toList()[index].title!,
                                                          style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                   
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.calendar_today,
                                                          size: 15,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          DateFormat("MMM dd")
                                                              .format(blogs[index]
                                                                  .dateCreated!),
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 5),
                                                        const Icon(
                                                          Icons.visibility,
                                                          size: 15,
                                                        ),
                                                        const SizedBox(width: 5),
                                                        const Text(
                                                          "22K",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                              ),
                            ))
                      ],
                    ),
                  ))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(onPressed: (){
              context.push(AppRoutes.creatscreen, extra: "");
            }, backgroundColor: Theme.of(context).primaryColor, child: const Icon(Icons.wrap_text),),
    );
  }
}
