import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../viewmodels/global_ui_viewmodel.dart';
import '../../viewmodels/single_category_viewmodel.dart';

class SingleCategoryScreen extends StatelessWidget {
  const SingleCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SingleCategoryViewModel>(
        create: (_) => SingleCategoryViewModel(), child: SingleCategoryBody());
  }
}

class SingleCategoryBody extends StatefulWidget {
  const SingleCategoryBody({Key? key}) : super(key: key);

  @override
  State<SingleCategoryBody> createState() => _SingleCategoryBodyState();
}

class _SingleCategoryBodyState extends State<SingleCategoryBody> {
  late SingleCategoryViewModel _singleCategoryViewModel;
  late GlobalUIViewModel _ui;
  String? categoryId;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _singleCategoryViewModel =
          Provider.of<SingleCategoryViewModel>(context, listen: false);
      _ui = Provider.of<GlobalUIViewModel>(context, listen: false);
      final args = ModalRoute.of(context)!.settings.arguments.toString();
      setState(() {
        categoryId = args;
      });
      print("ARGS :: " + args);
      getData(args);
    });
    super.initState();
  }

  double rating = 0;
  Future<void> getData(String categoryId) async {
    _ui.loadState(true);
    try {
      await _singleCategoryViewModel.getProductByCategory(categoryId);
    } catch (e) {
      print(e);
    }
    _ui.loadState(false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleCategoryViewModel>(
        builder: (context, singleCategoryVM, child) {
      return SafeArea(
        child: singleCategoryVM.category == null
            ? Text("Please wait")
            : Scaffold(
                backgroundColor: Colors.deepOrangeAccent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                ),
                body: RefreshIndicator(
                  onRefresh: () => getData(categoryId.toString()),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (singleCategoryVM.category != null &&
                            singleCategoryVM.category!.imageUrl != null)
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage(
                                  singleCategoryVM.category!.imageUrl
                                      .toString(),
                                ),
                                // child: Image.network(
                                //   singleCategoryVM.category!.imageUrl.toString(),
                                //   height: 250,
                                //   fit: BoxFit.cover,
                                // ),
                              ),
                              Positioned(
                                top: 60,
                                bottom: 1,
                                child: Container(
                                    width: double.infinity,
                                    decoration:
                                        BoxDecoration(color: Colors.white70),
                                    child: Text(
                                      singleCategoryVM.category!.categoryName
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700),
                                    )),
                              )
                            ],
                          ),
                        SizedBox(
                          height: 20,
                        ),
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
                              ...singleCategoryVM.products
                                  .map((e) => ProductCard(e))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      );
    });
  }

  Widget ProductCard(ProductModel e) {
    return InkWell(
      onTap: () {
        // print(e.id);
        Navigator.of(context).pushNamed("/single-product", arguments: e.id);
      },
      child: Container(
        height: 500,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      e.imageUrl.toString(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    e.productName.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    e.productDescription.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "\$ ${e.productPrice.toString()}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RatingBar.builder(
                    itemSize: 21,
                    minRating: 1,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) => setState(() {
                      this.rating = rating;
                    }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      // child: Container(
      //   width: 250,
      //   child: Card(
      //     elevation: 5,
      //     child: Stack(
      //       children: [
      //         ClipRRect(
      //             borderRadius: BorderRadius.circular(5),
      //             child: Image.network(
      //               e.imageUrl.toString(),
      //               height: 300,
      //               width: double.infinity,
      //               fit: BoxFit.cover,
      //               errorBuilder: (BuildContext context, Object exception,
      //                   StackTrace? stackTrace) {
      //                 return Image.asset(
      //                   'assets/images/HamroPasal.png',
      //                   height: 300,
      //                   width: double.infinity,
      //                   fit: BoxFit.cover,
      //                 );
      //               },
      //             )),
      //         Positioned.fill(
      //           child: Align(
      //             alignment: Alignment.bottomCenter,
      //             child: Container(
      //                 width: double.infinity,
      //                 padding: EdgeInsets.symmetric(vertical: 5),
      //                 decoration:
      //                     BoxDecoration(color: Colors.white.withOpacity(0.8)),
      //                 child: Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     Text(
      //                       e.productName.toString(),
      //                       style: TextStyle(fontSize: 20),
      //                       textAlign: TextAlign.center,
      //                       maxLines: 2,
      //                     ),
      //                     Text(
      //                       "Rs. " + e.productPrice.toString(),
      //                       style: TextStyle(fontSize: 15, color: Colors.green),
      //                       textAlign: TextAlign.center,
      //                       maxLines: 2,
      //                     ),
      //                   ],
      //                 )),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
