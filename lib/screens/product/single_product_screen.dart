import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_baz/models/favorite_model.dart';
import 'package:n_baz/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/cart_model.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_product_viewmodel.dart';

class SingleProductScreen extends StatefulWidget {
  const SingleProductScreen({Key? key}) : super(key: key);

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleProductViewModel>(
        create: (_) => SingleProductViewModel(), child: SingleProductBody());
  }
}

class SingleProductBody extends StatefulWidget {
  const SingleProductBody({Key? key}) : super(key: key);

  @override
  State<SingleProductBody> createState() => _SingleProductBodyState();
}

class _SingleProductBodyState extends State<SingleProductBody> {
  late SingleProductViewModel _singleProductViewModel;
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? productId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _singleProductViewModel =
          Provider.of<SingleProductViewModel>(context, listen: false);
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        productId = args;
      });
      print(args);
      getData(args);
    });
    super.initState();
  }

  bool isCheckout = false;
  Future<void> getData(String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.getFavoritesUser();
      await _authViewModel.getCartsUser();
      await _singleProductViewModel.getProducts(productId);
    } catch (e) {}
    _ui.loadState(false);
  }

  Future<void> favoritePressed(
      FavoriteModel? isFavorite, String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.favoriteAction(isFavorite, productId);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Favorite updated.")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong. Please try again.")));
      print(e);
    }
    _ui.loadState(false);
  }

  Future<void> cartPressed(CartModel? isCart, String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.cartAction(isCart, productId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Added to cart successfully."),
        backgroundColor: Colors.deepOrangeAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 20,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong. Please try again."),
        backgroundColor: Colors.deepOrangeAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(50),
        elevation: 20,
      ));
      print(e);
    }
    _ui.loadState(false);
  }

  int count = 1;

  Widget _buildColorProduct({required Color color}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: color,
      ),
      height: 40,
      width: 40,
    );
  }

  List<bool> sized = [true, false, false, false];
  List<bool> colored = [true, false, false, false];
  int sizeIndex = 0;
  late String size;
  void getSize() {
    if (sizeIndex == 0) {
      setState(() {
        size = "S";
      });
    } else if (sizeIndex == 1) {
      setState(() {
        size = "M";
      });
    } else if (sizeIndex == 2) {
      setState(() {
        size = "L";
      });
    } else if (sizeIndex == 3) {
      setState(() {
        size = "XL";
      });
    }
  }

  int colorIndex = 0;
  late String color;
  void getColor() {
    if (colorIndex == 0) {
      setState(() {
        color = "Light Blue";
      });
    } else if (colorIndex == 1) {
      setState(() {
        color = "Light Green";
      });
    } else if (colorIndex == 2) {
      setState(() {
        color = "Light Yellow";
      });
    } else if (colorIndex == 3) {
      setState(() {
        color = "Cyan";
      });
    }
  }

  Widget _buildSizePart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        ListTile(
          leading: Text(
            "Size",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          contentPadding: EdgeInsets.only(right: 10),
          trailing: Container(
            width: 250,
            height: 50,
            child: ToggleButtons(
              splashColor: Colors.transparent,
              renderBorder: false,
              borderRadius: BorderRadius.circular(50),
              children: [
                Text("S"),
                Text("M"),
                Text("L"),
                Text("XL"),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int indexBtn = 0; indexBtn < sized.length; indexBtn++) {
                    if (indexBtn == index) {
                      sized[indexBtn] = true;
                    } else {
                      sized[indexBtn] = false;
                    }
                  }
                });
                setState(() {
                  sizeIndex = index;
                });
              },
              isSelected: sized,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColorPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        ListTile(
          leading: Text(
            "Color",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          contentPadding: EdgeInsets.only(right: 10),
          trailing: Container(
            width: 250,
            child: ToggleButtons(
              hoverColor: Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(50),
              // fillColor: Colors.deepOrange.shade50,
              renderBorder: false,
              children: [
                _buildColorProduct(color: Colors.blue),
                _buildColorProduct(color: Colors.green),
                _buildColorProduct(color: Colors.yellow),
                _buildColorProduct(color: Colors.cyan),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int indexBtn = 0;
                      indexBtn < colored.length;
                      indexBtn++) {
                    if (indexBtn == index) {
                      colored[indexBtn] = true;
                    } else {
                      colored[indexBtn] = false;
                    }
                  }
                });
                setState(() {
                  colorIndex = index;
                });
              },
              isSelected: colored,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuentityPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          "Quentity",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 40,
          width: 130,
          decoration: BoxDecoration(
            color: Color(0xff746bc9),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.remove,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    if (count > 1) {
                      count--;
                    }
                  });
                },
              ),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              GestureDetector(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onTap: () {
                  setState(() {
                    count++;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SingleProductViewModel, AuthViewModel>(
        builder: (context, singleProductVM, authVm, child) {
      return singleProductVM.product == null
          ? Scaffold(
              body: Container(
                child: Text("Error"),
              ),
            )
          : singleProductVM.product!.id == null
              ? Scaffold(
                  body: Center(
                    child: Container(
                      child: Text("Please wait..."),
                    ),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.deepOrangeAccent,
                    actions: [
                      Builder(builder: (context) {
                        FavoriteModel? isFavorite;
                        try {
                          isFavorite = authVm.favorites.firstWhere((element) =>
                              element.productId == singleProductVM.product!.id);
                        } catch (e) {}

                        return IconButton(
                            onPressed: () {
                              print(singleProductVM.product!.id!);
                              favoritePressed(
                                  isFavorite, singleProductVM.product!.id!);
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite != null
                                  ? Colors.red
                                  : Colors.white,
                            ));
                      }),
                      SizedBox(
                        width: 2,
                      ),
                      GestureDetector(
                        onTap: () => Share.share(
                            singleProductVM.product!.imageUrl.toString()),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Icon(
                            Icons.share,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Color(0xFFf5f5f4),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10),
                                      blurRadius: 20,
                                      spreadRadius: 0),
                                  BoxShadow(
                                      color: Colors.white,
                                      offset: Offset(0, -10),
                                      blurRadius: 20,
                                      spreadRadius: 0)
                                ]),
                            child: Image.network(
                              singleProductVM.product!.imageUrl.toString(),
                              height: 400,
                              width: double.infinity,
                              // fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'assets/images/logo.png',
                                  height: 400,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 10),
                                        blurRadius: 20,
                                        spreadRadius: 0),
                                    BoxShadow(
                                        color: Colors.white,
                                        offset: Offset(0, -10),
                                        blurRadius: 20,
                                        spreadRadius: 0)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rs. " +
                                        singleProductVM.product!.productPrice
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    singleProductVM.product!.productName
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    singleProductVM.product!.productDescription
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  _buildColorPart(),
                                  _buildSizePart()
                                ],
                              )),
                        ),
                        Builder(builder: (context) {
                          CartModel? isCart;
                          try {
                            isCart = authVm.carts.firstWhere((element) =>
                                element.productId ==
                                singleProductVM.product!.id);
                          } catch (e) {}

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      cartPressed(
                                          isCart, singleProductVM.product!.id!);
                                    },
                                    icon: Icon(
                                      Icons.shopping_cart,
                                      color: isCart != null
                                          ? Colors.white
                                          : Colors.grey,
                                    )),
                              ),
                              Container(
                                width: 140,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed("/payment");
                                    },
                                    icon: Icon(
                                      Icons.shopping_cart_checkout,
                                      color: isCheckout
                                          ? Colors.grey
                                          : Colors.white,
                                    )),
                              )
                            ],
                          );
                        })
                      ],
                    ),
                  ),
                );
    });
  }
}
