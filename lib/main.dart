import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:n_baz/screens/account/changePassword.dart';
import 'package:n_baz/screens/account/change_your_email.dart';
import 'package:n_baz/screens/account/faqs.dart';
import 'package:n_baz/screens/account/show_profile.dart';
import 'package:n_baz/screens/auth/changeAddress.dart';
import 'package:n_baz/screens/auth/forget_password_screen.dart';
import 'package:n_baz/screens/auth/login_screen.dart';
import 'package:n_baz/screens/auth/register_screen.dart';
import 'package:n_baz/screens/cart/cart.dart';
import 'package:n_baz/screens/cart/payment.dart';
import 'package:n_baz/screens/category/single_category_screen.dart';
import 'package:n_baz/screens/dashboard/dashboard.dart';
import 'package:n_baz/screens/dashboard/payee.dart';
import 'package:n_baz/screens/product/add_product_screen.dart';
import 'package:n_baz/screens/product/edit_product_screen.dart';
import 'package:n_baz/screens/product/my_product_screen.dart';
import 'package:n_baz/screens/product/single_product_screen.dart';
import 'package:n_baz/screens/splashscreens/screen_one.dart';
import 'package:n_baz/services/local_notification_service.dart';
import 'package:n_baz/viewmodels/auth_viewmodel.dart';
import 'package:n_baz/viewmodels/category_viewmodel.dart';
import 'package:n_baz/viewmodels/global_ui_viewmodel.dart';
import 'package:n_baz/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';
import 'constants/constants.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:khalti_flutter/localization/khalti_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: "dev project", options: DefaultFirebaseOptions.currentPlatform
      );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalUIViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
      ],
      child: GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: Image.asset(
            "assets/images/loading.gif",
            height: 100,
            width: 100,
          ),
        ),
        child: Consumer<GlobalUIViewModel>(builder: (context, loader, child) {
          if (loader.isLoading) {
            context.loaderOverlay.show();
          } else {
            context.loaderOverlay.hide();
          }
          return KhaltiScope(
              //use your public/test key here
              publicKey: 'test_public_key_99795ae72a0147538c5928d21d792775',
              enabledDebugging: true,
              builder: (context, navKey) {
                return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Flutter Demo',
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                    ),
                    initialRoute: "/splash",
                    routes: {
                      "/login": (BuildContext context) => LoginScreen(),
                      "/splash": (BuildContext context) => SplashScreen(),
                      "/register": (BuildContext context) => RegisterScreen(),
                      "/forget-password": (BuildContext context) =>
                          ForgetPasswordScreen(),
                      "/dashboard": (BuildContext context) => DashboardScreen(),
                      "/add-product": (BuildContext context) =>
                          AddProductScreen(),
                      "/edit-product": (BuildContext context) =>
                          EditProductScreen(),
                      "/single-product": (BuildContext context) =>
                          SingleProductScreen(),
                      "/single-category": (BuildContext context) =>
                          SingleCategoryScreen(),
                      "/my-products": (BuildContext context) =>
                          MyProductScreen(),
                      "/faqs": (BuildContext context) => FAQsScreen(),
                      "/your_profile": (BuildContext context) => ProfileInfo(),
                      "/change_email": (BuildContext context) => ChangeEmail(),
                      "/payment": (BuildContext context) => ePayment(),
                      "/cart": (BuildContext context) => CartScreen(),
                      "/change_password": (BuildContext context) =>
                          ChangePasswordScreen(),
                      "/change_address": (BuildContext context) =>
                          ChangeAddress(),
                      // "/project": (BuildContext context) => Project(),
                    },
                    navigatorKey: navKey,
                    localizationsDelegates: const [
                      KhaltiLocalizations.delegate,
                    ]);
              });
        }),
      ),
    );
  }
}

//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       // options: FirebaseOptions(
//       //   apiKey: "AIzaSyDZopgwT3FXAHhsTs2c78yk-dw92lnnEK8",
//       //   appId: "1:350617005648:web:64921c07aa521069b4ab55",
//       //   messagingSenderId: "350617005648",
//       //   projectId: "my-app-name-3d643",
//       // ),
//       );
//   NotificationService.initialize();
//   runApp(MyApp());
// }
//

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (ctx) => OnboardingScreenOne()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/images/HamroPasal.png'),
              width: 500,
            ),
            SizedBox(),
            SpinKitChasingDots(
              color: orange,
              size: 50.0,
            ),
          ],
        ),
      ),
    );
  }
}
