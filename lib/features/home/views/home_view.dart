import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared_components/styles/app_colors.dart';
import '../../../shared_components/styles/app_text_styles.dart';
import '../../../shared_components/widgets/custom_button.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // HomeView affiche seulement les données. Le chargement vient du controller.
    final homeController = Get.find<HomeController>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Obx(() {
                // Obx reconstruit cette partie quand isLoading ou user change.
                if (homeController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final user = homeController.user.value;
                if (user == null) {
                  return const Text(
                    'Aucune information utilisateur disponible.',
                    style: AppTextStyles.body,
                  );
                }

                return Card(
                  // Carte simple qui affiche le profil récupéré depuis Firestore.
                  elevation: 0,
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Home', style: AppTextStyles.dialogTitle),
                        const SizedBox(height: 18),
                        _InfoRow(label: 'Nom complet', value: user.fullName),
                        _InfoRow(label: 'Email', value: user.email),
                        _InfoRow(
                          label: 'Email vérifié',
                          value: user.emailVerified ? 'Oui' : 'Non',
                        ),
                        const SizedBox(height: 22),
                        CustomButton(
                          label: 'Déconnexion',
                          icon: Icons.logout,

                          // La vue délègue la déconnexion au HomeController.
                          onPressed: homeController.logout,
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
          Text(label, style: AppTextStyles.muted),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.body),
        ],
      ),
    );
  }
}
