import 'dart:ffi';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_baz/models/category_model.dart';
import 'package:n_baz/models/product_model.dart';
import 'package:n_baz/viewmodels/auth_viewmodel.dart';
import 'package:n_baz/viewmodels/category_viewmodel.dart';
import 'package:n_baz/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/global_ui_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AuthViewModel _authViewModel;
  late CategoryViewModel _categoryViewModel;
  late ProductViewModel _productViewModel;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _categoryViewModel =
          Provider.of<CategoryViewModel>(context, listen: false);
      _productViewModel = Provider.of<ProductViewModel>(context, listen: false);
    });
    refresh();
    super.initState();
  }

  Future<void> refresh() async {
    _categoryViewModel.getCategories();
    _productViewModel.getProducts();
    _authViewModel.getMyProducts();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      "assets/images/4.png",
      "assets/images/1.png",
      "assets/images/2.png",
      "assets/images/3.png",
    ];
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(item, fit: BoxFit.cover),
                    ],
                  ),
                ),
              ),
            ))
        .toList();
    return Consumer3<CategoryViewModel, AuthViewModel, ProductViewModel>(
        builder: (context, categoryVM, authVM, productVM, child) {
      return Container(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                margin: EdgeInsets.only(top: 60),
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.only(top: 10),
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 200,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                enlargeCenterPage: true,
                                enableInfiniteScroll: false,
                                // autoPlayAnimationDuration: Duration(seconds: 1),
                                // autoPlay: true,
                              ),
                              items: imageSliders,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...categoryVM.categories
                                    .map((e) => CategoryCard(e))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              "Products",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.count(
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: [
                              ...productVM.products.map((e) => ProductCard(e))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            HomeHeader(authVM),
          ],
        ),
      );
    });
  }

  Widget HomeHeader(AuthViewModel authVM) {
    return Align(
        alignment: Alignment.topCenter,
        child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.deepOrange,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 40,
                  color: Colors.white54,
                ),
                Text(
                  "HamroPasal",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white54),
                ),
                Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.search,
                      size: 30,
                      color: Color(0xFFF57C00),
                    )),
                Badge(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(7),
                  badgeContent: Text(
                    "3",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 30,
                      color: Color(0xFFF57C00),
                    ),
                  ),
                )
              ],
            )));
  }

  Widget WelcomeText(AuthViewModel authVM) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          authVM.loggedInUser != null
              ? authVM.loggedInUser!.name.toString()
              : "Guest",
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget CategoryCard(CategoryModel e) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed("/single-category", arguments: e.id.toString());
      },
      child: Container(
        width: 100,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Column(
          children: [
            CircleAvatar(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    e.imageUrl.toString(),
                    height: 80,
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  width: double.infinity,
                  // height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.deepOrangeAccent),
                  child: Text(
                    e.categoryName.toString() + "\n",
                    maxLines: 1,
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget ProductCard(ProductModel e) {
    return InkWell(
      onTap: () {
        // print(e.id);
        Navigator.of(context).pushNamed("/single-product", arguments: e.id);
      },
      child: Container(
        width: 250,
        child: Card(
          elevation: 0,
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    e.imageUrl.toString(),
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Image.asset(
                        'assets/images/logo.png',
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  )),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepOrangeAccent),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            e.productName.toString(),
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                          Text(
                            "Rs. " + e.productPrice.toString(),
                            style: TextStyle(fontSize: 15, color: Colors.green),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
