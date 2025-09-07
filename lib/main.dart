import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'models/cart.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/order_tracking_screen.dart';
import 'screens/rating_screen.dart';
import 'package:flutter/services.dart';

const kBrandRed = Color(0xFFC8012C);


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: const KexGoApp(),
    ),
  );
}

class KexGoApp extends StatelessWidget {
  const KexGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KexGO',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed
        (seedColor: kBrandRed, brightness: Brightness.light),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(        // appbars rojas con texto/iconos blancos
          backgroundColor: kBrandRed,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed
        (seedColor: kBrandRed, brightness: Brightness.dark),
        appBarTheme: const AppBarTheme(
          backgroundColor: kBrandRed,
          foregroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
      ),
      routes: {
        '/': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
        '/search': (_) => const SearchScreen(),
        '/cart': (_) => const CartScreen(),
        '/tracking': (_) => const OrderTrackingScreen(),
        '/rate': (_) => const RatingScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == ProductDetailScreen.routeName) {
          final product = settings.arguments as Product;
          return MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product));
        }
        return null;
      },
    );
  }
}
