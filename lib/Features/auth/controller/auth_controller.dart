import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todoapp/Features/auth/view/login_view.dart';
import 'package:todoapp/Features/home/view/home_view.dart';
import 'package:todoapp/api/auth_api.dart';
import 'package:todoapp/core/ustils.dart';
import 'package:appwrite/models.dart' as model;

final authControllerProvider =
    StateNotifierProvider<Authcontroller, bool>((ref) {
  return Authcontroller(
    authAPI: ref.watch(authAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class Authcontroller extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  Authcontroller({required AuthAPI authAPI})
      : _authAPI = authAPI,
        super(false);
  //Loading(While Saving data to appwrite dashboard)

  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        showSnackBar(context, "SignUp Sucessful, Please Login");
        Navigator.push(context, LoginView.route());
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        Navigator.push(context, HomeView.route());
      },
    );
  }
}
