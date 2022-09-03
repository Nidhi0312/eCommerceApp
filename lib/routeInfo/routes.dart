import '../screens/shopping_dashboard/shopping_view.dart';
import '../screens/my_cart/mycart_view.dart';
import 'route_name.dart';

class Routes {
  static final allRoutes = {
    RouteName.shoppingListPage: (context) => const ShoppingMallView(),
    RouteName.myCartPage: (context) => const MyCartView(),
  };
}
