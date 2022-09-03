import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_cart/common/appcomponent_base.dart';
import 'package:product_cart/common/constants/string_constants.dart';
import 'package:product_cart/model/product_list_model.dart';
import 'package:product_cart/routeInfo/route_name.dart';
import 'package:product_cart/screens/shopping_dashboard/shopping_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShoppingMallView extends StatefulWidget {
  const ShoppingMallView({Key? key}) : super(key: key);

  @override
  _ShoppingMallViewState createState() => _ShoppingMallViewState();
}

class _ShoppingMallViewState extends State<ShoppingMallView> {
  final ShoppingBloc _shopBloc = ShoppingBloc();
  final ScrollController _scrollController = ScrollController();
  AppComponentBase appComponentBase = AppComponentBase.instance;

  @override
  void initState() {
    _shopBloc.add(GetProductList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: true,
        child: BlocProvider(
          create: (_) => _shopBloc,
          child: BlocListener<ShoppingBloc, ShoppingState>(
            listener: (context, state) {},
            child: BlocBuilder<ShoppingBloc, ShoppingState>(
              builder: (context, state) {
                if (state is ShoppingInitial) {
                  return _buildLoading();
                } else if (state is ShoppingLoading) {
                  return _buildLoading();
                } else if (state is ProductLoaded &&
                    state.productListModel != null) {
                  return _buildShoppingList(context, state.productListModel!);
                } else if (state is NoInternetAvailable) {
                  return SizedBox(
                    child: Center(
                      child: Text(
                        StringConstants.noInternetConnection,
                        style: appComponentBase.noInternetStyle,
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
      title: const Text(
        'Shopping Mall',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      actions: [
        InkWell(
          onTap: () async {
            var result =
                await Navigator.of(context).pushNamed(RouteName.myCartPage);
            if (result != null) {
              _shopBloc.add(GetProductList());
            }
          },
          child: const Icon(
            Icons.shopping_cart,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10.sp,
        )
      ],
    );
  }

  _buildShoppingList(BuildContext context, List<ProductListModelData> model) {
    return model.isNotEmpty
        ? OrientationBuilder(builder: (context, orientation) {
            return GridView.builder(
                controller: _scrollController
                  ..addListener(() {
                    if (_scrollController.offset ==
                        _scrollController.position.maxScrollExtent) {
                      _shopBloc.add(LoadMoreProduct());
                    }
                  }),
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(10.sp, 20.sp, 10.sp, 0.sp),
                shrinkWrap: true,
                itemCount: model.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
                    crossAxisSpacing: 8.sp,
                    mainAxisSpacing: 8.sp,
                    childAspectRatio: 0.85),
                itemBuilder: (BuildContext context, int index) {
                  return _buildCart(context, index, model[index]);
                });
          })
        : Container();
  }

  _buildCart(BuildContext context, int index, ProductListModelData data) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 60.sp,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(0.sp),
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Center(
                      child:
                          data.featuredImage != null && data.featuredImage != ''
                              ? CachedNetworkImage(
                                  imageUrl: data.featuredImage!,
                                  fit: BoxFit.contain,
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : const SizedBox(),
                    )),
                Container(
                  padding: EdgeInsets.fromLTRB(5.sp, 15.sp, 5.sp, 8.sp),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(child: Text(data.title ?? '')),
                      InkWell(
                        onTap: () {
                          if (_shopBloc.products[index].isSelected) {
                            _shopBloc.selectedProducts.remove(data);
                          } else {
                            _shopBloc.selectedProducts.add(data);
                          }
                          _shopBloc
                              .add(UpdateProductList(data, index, context));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              StringConstants.cartUpdated,
                              style: appComponentBase.cartUpdatedStyle,
                            ),
                          ));
                        },
                        child: Icon(
                          Icons.shopping_cart,
                          color: data.isSelected
                              ? Colors.lightBlue
                              : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
