import 'package:khibrat_flutter2/core/constants/api_constants.dart';

class CompanyProfileModel {
  final String id;
  final String name;
  final String? logoUrl;
  final String? tagline;
  final String? about;
  final String? phone;
  final String? email;
  final String? address;

  CompanyProfileModel({
    required this.id,
    required this.name,
    this.logoUrl,
    this.tagline,
    this.about,
    this.phone,
    this.email,
    this.address,
  });

  factory CompanyProfileModel.fromJson(Map<String, dynamic> json) {
    return CompanyProfileModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      logoUrl: _resolveMediaUrl(json['logo_url']?.toString()),
      tagline: json['tagline']?.toString(),
      about: json['about']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
    );
  }

  /// Rewrites localhost / 127.0.0.1 media URLs to the configured API host.
  static String? _resolveMediaUrl(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    final parsed = Uri.tryParse(url.trim());
    if (parsed == null) return url;
    final base = Uri.parse(ApiConstants.baseUrl);
    if (parsed.host == 'localhost' || parsed.host == '127.0.0.1') {
      return parsed
          .replace(
            scheme: base.scheme,
            host: base.host,
            port: base.hasPort ? base.port : null,
          )
          .toString();
    }
    return url;
  }
}
