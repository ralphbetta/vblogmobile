class BlogPost {
    String? typename;
    String? id;
    String? title;
    String? subTitle;
    String? body;
    DateTime? dateCreated;

    BlogPost({
        this.typename,
        this.id,
        this.title,
        this.subTitle,
        this.body,
        this.dateCreated,
    });

    factory BlogPost.fromJson(Map<String, dynamic> json) => BlogPost(
        typename: json["__typename"],
        id: json["id"].toString(),
        title: json["title"],
        subTitle: json["subTitle"],
        body: json["body"],
        dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    );

    Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
        "title": title,
        "subTitle": subTitle,
        "body": body,
        "dateCreated": dateCreated?.toIso8601String(),
    };
}
