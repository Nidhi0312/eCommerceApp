import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_cart/common/appcomponent_base.dart';
import 'package:product_cart/screens/my_cart/mycart_bloc.dart';

import '../../model/product_list_model.dart';

class MyCartView extends StatefulWidget {
  const MyCartView({Key? key}) : super(key: key);

  @override
  _MyCartViewState createState() => _MyCartViewState();
}

class _MyCartViewState extends State<MyCartView> {
  final MyCartBloc _cartBloc = MyCartBloc();
  final AppComponentBase appComponentBase = AppComponentBase.instance;

  @override
  void initState() {
    _cartBloc.add(GetMyProductList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: true,
        child: BlocProvider(
          create: (_) => _cartBloc,
          child: BlocListener<MyCartBloc, MyCartState>(
            listener: (context, state) {},
            child: BlocBuilder<MyCartBloc, MyCartState>(
              builder: (context, state) {
                if (state is MyCartInitial) {
                  return _buildLoading();
                } else if (state is MyCartLoading) {
                  return _buildLoading();
                } else if (state is MyProductLoaded &&
                    state.productListModel != null) {
                  return Stack(
                    children: [
                      _buildCartList(context, state.productListModel!),
                      _buildTotalUI(context)
                    ],
                  );
                } else if (state is EmptyCart) {
                  return Center(
                    child: Text(
                      'No Data Available',
                      style: appComponentBase.noDataStyle,
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

  _buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      centerTitle: true,
      title: const Text(
        'My Cart',
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      leading: InkWell(
        onTap: () {
          Navigator.of(context).pop(true);
        },
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
    );
  }

  _buildCartList(BuildContext context, List<ProductListModelData> model) {
    return ListView.builder(
        padding: EdgeInsets.only(bottom: 50.sp),
        itemCount: model.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return _buildMyCart(context, index, model[index]);
        });
  }

  _buildMyCart(BuildContext context, int index, ProductListModelData data) {
    return Container(
      margin: EdgeInsets.only(top: 20.sp, left: 5.sp),
      height: 120.sp,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0)),
        ),
        elevation: 4,
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0))),
              width: MediaQuery.of(context).size.width / 3,
              child: data.featuredImage != null && data.featuredImage != ''
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
            ),
            SizedBox(
              width: 10.sp,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Text(
                            data.title ?? '',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _cartBloc.add(DeleteMyProductList(data.id));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 8.sp),
                            child: Icon(
                              Icons.delete,
                              color: Colors.blueAccent,
                              size: 23.sp,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8.sp,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Price'),
                        Padding(
                          padding: EdgeInsets.only(right: 8.sp),
                          child: Text('Rs. ${data.price.toString()}'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Quantity'),
                        Padding(
                          padding: EdgeInsets.only(right: 8.sp),
                          child: const Text('1'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildTotalUI(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 15.sp),
        color: Colors.blueAccent,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Total Items :',
              style: appComponentBase.myCartStyle,
            ),
            SizedBox(
              width: 5.sp,
            ),
            Text(
              '${_cartBloc.products.length}',
              style: appComponentBase.myCartStyle,
            ),
            const Spacer(),
            Text(
              'Grand Total :',
              style: appComponentBase.myCartStyle,
            ),
            SizedBox(
              width: 8.sp,
            ),
            Text(
              'Rs. ${_cartBloc.grandTotal}',
              style: appComponentBase.myCartStyle,
            ),
            SizedBox(
              width: 5.sp,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
