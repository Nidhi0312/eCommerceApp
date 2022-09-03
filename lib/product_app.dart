import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_cart/routeInfo/routes.dart';

import 'routeInfo/route_name.dart';

class ProductApp extends StatelessWidget {
  const ProductApp({Key? key}) : super(key: key);

//here we can provide design size according to xd
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            initialRoute: RouteName.shoppingListPage,
            routes: Routes.allRoutes);
      },
    );
  }
}
