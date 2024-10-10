class StatusUpdate {
  int? statusUpdateId;
  String? statusThumbnailImg;
  String? title;
  String? description;
  String? statusFullImg;
  String? link;

  StatusUpdate(
      {this.statusUpdateId,
      this.statusThumbnailImg,
      this.title,
      this.description,
      this.statusFullImg,
      this.link});

  StatusUpdate.fromJson(Map<String, dynamic> json) {
    statusUpdateId = json['status_update_id'];
    statusThumbnailImg = json['status_thumbnail_img'] ?? '';
    title = json['title'];
    description = json['description'];
    statusFullImg = json['status_full_img'] ?? '';
    link = json['link'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_update_id'] = this.statusUpdateId;
    data['status_thumbnail_img'] = this.statusThumbnailImg;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status_full_img'] = this.statusFullImg;
    data['link'] = this.link;
    return data;
  }
}
