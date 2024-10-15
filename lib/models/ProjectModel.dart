class Project {
  int? userId;
  int? projectId;
  String? propertyName;
  String? description;
  String? amenities;
  String? builder;
  String? address;
  String? mapLocation;
  String? projectThumbnailImg;
  String? pricingDesc;
  String? city;
  int? isFeatured;
  int? createdBy;
  String? createdAt;
  Null? updatedBy;
  String? updatedAt;
  String? website;

  Project(
      {this.userId,
      this.projectId,
      this.propertyName,
      this.description,
      this.amenities,
      this.builder,
      this.address,
      this.mapLocation,
      this.projectThumbnailImg,
      this.pricingDesc,
      this.city,
      this.isFeatured,
      this.createdBy,
      this.createdAt,
      this.updatedBy,
      this.updatedAt,
      this.website});

  Project.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    projectId = json['project_id'];
    propertyName = json['property_name'] ?? '';
    description = json['description'] ?? '';
    amenities = json['amenities'] ?? '';
    builder = json['builder'] ?? '';
    address = json['address'] ?? '';
    mapLocation = json['map_location'] ?? '';
    projectThumbnailImg = json['project_thumbnail_img'] ?? '';
    pricingDesc = json['pricing_desc'];
    city = json['city'] ?? '';
    isFeatured = json['is_featured'] ?? '';
    createdBy = json['created_by'] ?? '';
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    website = json['website'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['project_id'] = this.projectId;
    data['property_name'] = this.propertyName;
    data['description'] = this.description;
    data['amenities'] = this.amenities;
    data['builder'] = this.builder;
    data['address'] = this.address;
    data['map_location'] = this.mapLocation;
    data['project_thumbnail_img'] = this.projectThumbnailImg;
    data['pricing_desc'] = this.pricingDesc;
    data['city'] = this.city;
    data['is_featured'] = this.isFeatured;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
