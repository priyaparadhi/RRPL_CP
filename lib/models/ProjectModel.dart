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
  int? updatedBy;
  String? updatedAt;
  String? website;

  Project({
    this.userId,
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
    this.website,
  });

  // Parsing JSON data into Project object
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
    pricingDesc = json['pricing_desc'] ?? '';
    city = json['city'] ?? '';
    isFeatured = json['is_featured'];
    createdBy = json['created_by'];
    createdAt = json['created_at'] ?? '';
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'] ?? '';
    website = json['website'] ?? '';
  }

  // Converting Project object to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['project_id'] = projectId;
    data['property_name'] = propertyName;
    data['description'] = description;
    data['amenities'] = amenities;
    data['builder'] = builder;
    data['address'] = address;
    data['map_location'] = mapLocation;
    data['project_thumbnail_img'] = projectThumbnailImg;
    data['pricing_desc'] = pricingDesc;
    data['city'] = city;
    data['is_featured'] = isFeatured;
    data['created_by'] = createdBy;
    data['created_at'] = createdAt;
    data['updated_by'] = updatedBy;
    data['updated_at'] = updatedAt;
    data['website'] = website;
    return data;
  }
}
