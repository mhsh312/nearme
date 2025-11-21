import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final String cloudName = 'dfdrkayfb';
  final String presetName = 'nearme_preset';

  Future<String> uploadImage(XFile? file) async {
    final String uploadUrl =
        'https://api.cloudinary.com/v1_1/$cloudName/upload';

    final request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

    request.fields['upload_preset'] = presetName;
    request.files.add(await http.MultipartFile.fromPath('file', file!.path));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final String? imageUrl = data['secure_url'];

      if (imageUrl != null) {
        return imageUrl;
      }

      throw Exception('Cloudinary upload success, but secure_url is missing.');
    } else {
      final errorData = json.decode(response.body);
      final String errorMessage =
          errorData['error']['message'] ?? 'Unknown Cloudinary error.';
      throw Exception(
        'Cloudinary upload failed (Status ${response.statusCode}): $errorMessage',
      );
    }
  }
}
