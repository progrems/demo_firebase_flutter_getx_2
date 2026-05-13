import 'package:get/get.dart';

import '../../features/forgot/bindings/forgot_view_binding.dart';
import '../../features/forgot/views/forgot_view_screen.dart';
import '../../features/home/bindings/home_view_binding.dart';
import '../../features/home/views/home_page_view_screen.dart';
import '../../features/not_found/bindings/not_found_view_binding.dart';
import '../../features/not_found/views/screens/not_found_view_screen.dart';
import '../../features/root/bindings/root_binding.dart';
import '../../features/root/views/screens/root_view.dart';
import '../middleware/auth_middleware.dart';
import 'app_routes.dart';

abstract class AppPages {
  static const initial = Routes.root;

  // Chaque GetPage relie une route à sa view et au binding qui prépare son controller.
  static final pages = <GetPage<dynamic>>[
    GetPage(
      // name = le nom de route utilisé par Get.toNamed / Get.offAllNamed.
      name: Routes.root,
      // page = la view affichée pour cette route.
      page: () => const RootView(),
      // binding = l'injection des controllers/services nécessaires à cette view.
      binding: RootBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomePageViewScreen(),
      binding: HomeViewBinding(),
      // Home est protégée : le middleware refuse l'accès si l'email n'est pas vérifié.
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: Routes.forgot,
      page: () => const ForgotViewScreen(),
      binding: ForgotViewBinding(),
    ),
    GetPage(
      name: Routes.notFound,
      page: () => const NotFoundViewScreen(),
      binding: NotFoundViewBinding(),
    ),
  ];

  static final unknownRoute = GetPage(
    name: Routes.notFound,
    page: () => const NotFoundViewScreen(),
    binding: NotFoundViewBinding(),
  );
}
