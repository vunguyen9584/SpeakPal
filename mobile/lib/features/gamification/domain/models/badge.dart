class Badge {
  final String code;
  final String name;
  final String description;
  final String category;
  final String icon;
  final int requiredValue;

  const Badge({
    required this.code,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.requiredValue,
  });

  factory Badge.fromJson(Map<String, dynamic> json) {
    return Badge(
      code: json['code'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String,
      requiredValue: json['requiredValue'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'description': description,
      'category': category,
      'icon': icon,
      'requiredValue': requiredValue,
    };
  }
}

class UserBadge {
  final String id;
  final String userId;
  final String badgeCode;
  final DateTime earnedAt;
  final Badge badge;

  const UserBadge({
    required this.id,
    required this.userId,
    required this.badgeCode,
    required this.earnedAt,
    required this.badge,
  });

  factory UserBadge.fromJson(Map<String, dynamic> json) {
    return UserBadge(
      id: json['id'] as String,
      userId: json['userId'] as String,
      badgeCode: json['badgeCode'] as String,
      earnedAt: DateTime.parse(json['earnedAt'] as String),
      badge: Badge.fromJson(json['badge'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'badgeCode': badgeCode,
      'earnedAt': earnedAt.toIso8601String(),
      'badge': badge.toJson(),
    };
  }
}
