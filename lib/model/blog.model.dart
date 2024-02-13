class BlogPost {
    String? typename;
    String? id;
    String? title;
    String? subTitle;
    String? body;
    String? image;
    DateTime? dateCreated;

    BlogPost({
        this.typename,
        this.id,
        this.title,
        this.subTitle,
        this.body,
        this.image,
        this.dateCreated,
    });

    factory BlogPost.fromJson(Map<String, dynamic> json) => BlogPost(
        typename: json["__typename"],
        id: json["id"].toString(),
        title: json["title"],
        subTitle: json["subTitle"],
        body: json["body"],
        image: json['image'],
        dateCreated: json["dateCreated"] == null ? null : DateTime.parse(json["dateCreated"]),
    );

    Map<String, dynamic> toJson() => {
        "__typename": typename,
        "id": id,
        "title": title,
        "subTitle": subTitle,
        "body": body,
        "image": image,
        "dateCreated": dateCreated?.toIso8601String(),
    };
}
