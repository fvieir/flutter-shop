import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/pages/auth_page.dart';
import 'package:shop/pages/product_overview_page.dart';

class AuthOrHomePAge extends StatelessWidget {
  const AuthOrHomePAge({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return !auth.isAuth ? const AuthPage() : const ProductOverviewPage();
  }
}
