import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vblogmobile/config/graphql.config.dart';
import 'package:vblogmobile/constant/constant.dart';
import 'package:vblogmobile/model/blog.model.dart';

const String queryx = """
query fetchAllBlogs {
  allBlogPosts {
    id
    title
    subTitle
    body
    dateCreated
  }
}
""";

class GraphQLService {
  static GraphQLConfig graphQLConfig = GraphQLConfig();
  GraphQLClient client = graphQLConfig.clientToQuery();

  Future<List<BlogPost>> blogPosts() async {
    try {
      QueryResult result = await client.query(
        QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql(queryx),
          variables: const <String, dynamic>{},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      }

      List? res = result.data?['allBlogPosts'];

      if (res == null || res.isEmpty) {
        return [];
      } else {
        List<BlogPost> books = [
          ...List.generate(res.length, (index) { 
            BlogPost data = BlogPost.fromJson(res[index]);
            data.image = bannerUrl;
            return data;
            })
        ];

        return books;
      }
    } catch (error) {
      return [];
    }
  }

  Future<bool> createBlogPost({
    required String title,
    required String subTitle,
    required String body,
  }) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
              mutation createBlogPost(\$title: String!, \$subTitle: String!, \$body: String!) {
                createBlog(title: \$title, subTitle: \$subTitle, body: \$body) {
                  success
                  blogPost {
                    id
                    title
                    subTitle
                    body
                    dateCreated
                  }
                }
              }
            """),
          variables: {'title': title, "subTitle": subTitle, "body": body},
        ),
      );
      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> updateBlogPost({
    required String title,
    required String subTitle,
    required String body,
    required String blogId,
  }) async {
    Map<String, dynamic> variables = {
      'blogId': blogId,
      'title': title,
      "subTitle": subTitle,
      "body": body
    };

    print("result $variables");

    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
             mutation updateBlogPost(\$blogId: String!, \$title: String!, \$subTitle: String!, \$body: String!) {
              updateBlog(blogId: \$blogId, title: \$title, subTitle: \$subTitle, body: \$body) {
                success
                blogPost {
                  id
                  title
                  subTitle
                  body
                  dateCreated
                }
              }
            }
         """),
          variables: variables,
        ),
      );

      print(result);

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  Future<bool> deleteBlog({required String blogId}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            mutation deleteBlogPost(\$blogId: String!) {
              deleteBlog(blogId: \$blogId) {
                success
              }
            }
          """),
          variables: {
            "blogId": blogId,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return true;
      }
    } catch (error) {
      return false;
    }
  }


    Future<BlogPost?> singleBlog({required String blogId}) async {
    try {
      QueryResult result = await client.mutate(
        MutationOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql("""
            query getBlog(\$blogId: String!) {
              blogPost(blogId: \$blogId) {
                id
                title
                subTitle
                body
                dateCreated
              }
            }
          """),
          variables: {
            "blogId": blogId,
          },
        ),
      );

      var response =  result.data!['blogPost'];

      if (result.hasException) {
        throw Exception(result.exception);
      } else {
        return BlogPost.fromJson(response);
      }
    } catch (error) {
      return null;
    }
  }
}
