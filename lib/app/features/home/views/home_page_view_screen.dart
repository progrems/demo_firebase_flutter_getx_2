// ignore: unnecessary_library_name
library home_page;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/routes/app_routes.dart';
import '../../../config/themes/app_style.dart';
import '../../../shared_components/buttons/async_button.dart';
import '../../../shared_components/text/simple_text.dart';
import '../../../shared_components/text/title_text.dart';
import '../../../utils/models/user_model.dart';
import '../../../utils/services/app_service.dart';
import '../../../utils/services/scaffold_service.dart';

// binding
part '../bindings/home_view_binding.dart';
// controller
part '../controllers/home_view_controller.dart';

class HomePageViewScreen extends GetView<HomeViewController> {
  const HomePageViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GetView donne accès au HomeViewController avec la variable controller.
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = controller.user.value;
                if (user == null) {
                  return const SimpleText(
                    'Aucune information utilisateur disponible.',
                  );
                }

                return Card(
                  elevation: 0,
                  color: AppStyle.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppStyle.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const TitleText('Home'),
                        const SizedBox(height: 18),
                        // La photo vient de profileImageUrl et peut être modifiée ici.
                        const _ProfileImagePicker(),
                        const SizedBox(height: 18),
                        _InfoRow(label: 'Nom complet', value: user.fullName),
                        _InfoRow(label: 'Email', value: user.email),
                        _InfoRow(
                          label: 'Email vérifié',
                          value: user.emailVerified ? 'Oui' : 'Non',
                        ),
                        const SizedBox(height: 22),
                        AsyncButton(
                          label: 'Déconnexion',
                          icon: Icons.logout,
                          onPressed: controller.logout,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileImagePicker extends GetView<HomeViewController> {
  const _ProfileImagePicker();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.user.value;
      final imageUrl = user?.profileImageUrl;
      final hasProfileImage = imageUrl != null && imageUrl.isNotEmpty;
      final isUploading = controller.isUploadingProfileImage.value;

      return Center(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: AppStyle.fieldBackground,
              backgroundImage: hasProfileImage ? NetworkImage(imageUrl) : null,
              child: hasProfileImage
                  ? null
                  : const Icon(
                      Icons.person,
                      size: 42,
                      color: AppStyle.textSecondary,
                    ),
            ),
            Material(
              color: AppStyle.primary,
              shape: const CircleBorder(),
              child: IconButton(
                tooltip: hasProfileImage ? 'Modifier photo' : 'Ajouter photo',
                onPressed: isUploading
                    ? null
                    // La view déclenche seulement le controller, sans logique Firebase.
                    : controller.pickAndUploadProfileImage,
                icon: isUploading
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SimpleText(label, muted: true),
          const SizedBox(height: 4),
          SimpleText(value),
        ],
      ),
    );
  }
}
