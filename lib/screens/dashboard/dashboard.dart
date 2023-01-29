import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_baz/screens/account/account_screen.dart';
import 'package:n_baz/screens/cart/cart.dart';
import 'package:n_baz/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/category_viewmodel.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/product_viewmodel.dart';
import '../favorite/favorite_screen.dart';
import '../qrScreen/QRScreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController pageController = PageController();
  int selectedIndex = 0;
  _onPageChanged(int index) {
    // onTap
    setState(() {
      selectedIndex = index;
    });
  }

  _itemTapped(int selectedIndex) {
    pageController.jumpToPage(selectedIndex);
    setState(() {
      this.selectedIndex = selectedIndex;
    });
  }

  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late ProductViewModel _productViewModel;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel =
          Provider.of<CategoryViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
      getInit();
    });
    super.initState();
  }

  void getInit() {
    try {
      _categoryViewModel.getCategories();
      _productViewModel.getProducts();
      _authViewModel.getFavoritesUser();
      _authViewModel.getCartsUser();
      _authViewModel.getMyProducts();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView(
          controller: pageController,
          children: <Widget>[
            HomeScreen(),
            CartScreen(),
            QRCodeScreen(),
            FavoriteScreen(),
            AccountScreen()
          ],
          onPageChanged: _onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(
            Icons.qr_code,
            size: 40,
          ),
          onPressed: () {
            _itemTapped(2);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _itemTapped(0);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: selectedIndex == 0
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 0
                                  ? Colors.deepOrange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _itemTapped(1);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: selectedIndex == 1
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                        Text(
                          "Cart",
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 1
                                  ? Colors.deepOrange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // right tab bar icons
              // Text("Scan and Pay"),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _itemTapped(3);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: selectedIndex == 3
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                        Text(
                          "Favorite",
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 3
                                  ? Colors.deepOrange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      _itemTapped(4);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: selectedIndex == 4
                              ? Colors.deepOrange
                              : Colors.grey,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                              fontSize: 12,
                              color: selectedIndex == 4
                                  ? Colors.deepOrange
                                  : Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
