import 'package:get/get.dart';
import 'user_controller.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../../services/di/injection.dart';

/// GetX binding for UserController dependency injection
class UserBinding extends Bindings {
  @override
  void dependencies() {
    // Register UserController with GetIt dependency
    Get.lazyPut<UserController>(
      () => UserController(getIt<GetUsersUseCase>()),
      fenix: true, // Keep alive for the app lifetime
    );
  }
}

/// Alternative manual binding approach
class UserManualBinding {
  static void init() {
    if (!Get.isRegistered<UserController>()) {
      Get.put<UserController>(
        UserController(getIt<GetUsersUseCase>()),
        permanent: true,
      );
    }
  }

  static void dispose() {
    if (Get.isRegistered<UserController>()) {
      Get.delete<UserController>();
    }
  }
}