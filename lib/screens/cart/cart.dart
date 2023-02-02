import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n_baz/viewmodels/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import '../../models/cart_model.dart';
import '../../viewmodels/global_ui_viewmodel.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late GlobalUIViewModel _ui;
  late AuthViewModel _authViewModel;
  String? productId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
    });
    super.initState();
  }

  Future<void> getInit() async {
    _ui.loadState(true);
    try {
      await _authViewModel.getCartsUser();
    } catch (e) {}
    _ui.loadState(false);
  }

  Future<void> removeCartProduct(CartModel isCart, String productId) async {
    _ui.loadState(true);
    try {
      await _authViewModel.cartAction(isCart, productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cart updated."),
          backgroundColor: Colors.deepOrangeAccent,
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(50),
          elevation: 20,
        ),
      );
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

  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(builder: (context, authVM, child) {
      return Container(
        child: RefreshIndicator(
          onRefresh: getInit,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: authVM.cartProduct == null
                ? Column(
                    children: [
                      Center(child: Text("Something went wrong")),
                    ],
                  )
                : authVM.cartProduct!.length == 0
                    ? Column(
                        children: [
                          Center(child: Text("Please add to cart")),
                        ],
                      )
                    : Column(children: [
                        SizedBox(
                          height: 10,
                        ),
                        ...authVM.cartProduct!.map(
                          (e) => InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/single-product",
                                  arguments: e.id!);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              child: Card(
                                child: ListTile(
                                  horizontalTitleGap: 2,
                                  trailing: SizedBox(
                                    width: 130,
                                    child: Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _quantity--;
                                              });
                                            },
                                            child: Text("- "),
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        Text("$_quantity"),
                                        SizedBox(width: 5),
                                        SizedBox(
                                          width: 25,
                                          height: 35,
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _quantity++;
                                              });
                                            },
                                            child: Text("+"),
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 25,
                                          onPressed: () {
                                            removeCartProduct(
                                                _authViewModel.carts.firstWhere(
                                                    (element) =>
                                                        element.productId ==
                                                        e.id),
                                                e.id!);
                                          },
                                          icon: Icon(
                                            Icons.delete_outlined,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leading: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        e.imageUrl.toString(),
                                        width: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          return Image.asset(
                                            'assets/images/HamroPasal.png',
                                            width: 100,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      )),
                                  title: Text(e.productName.toString()),
                                  subtitle: Text(
                                      (e.productPrice! * _quantity).toString()),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
          ),
        ),
      );
    });
  }
}
