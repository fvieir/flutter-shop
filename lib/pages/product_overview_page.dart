import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/badge.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';
import '../components/product_grid.dart';
import '../models/cart.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductOverviewPage extends StatefulWidget {
  const ProductOverviewPage({super.key});

  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool showFavoriteOnly = false;
  bool isLoad = true;

  @override
  // void initState() {
  //   super.initState();
  //   Provider.of<ProductList>(context, listen: false)
  //       .loadProducts()
  //       .then((value) {
  //     setState(() => isLoad = false);
  //   });
  //   // loadProducts();
  // }

  // loadProducts() async {
  //   await Provider.of<ProductList>(
  //     context,
  //     listen: false,
  //   ).loadProducts().catchError((error) {
  //     return showDialog(
  //       context: context,
  //       builder: (ctx) => AlertDialog(
  //         title: const Text(
  //           'Algo deu errado',
  //           style: TextStyle(
  //             color: Colors.black87,
  //           ),
  //         ),
  //         content: const Text('Entre em contato com suporte'),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Ok'),
  //           ),
  //         ],
  //       ),
  //     );
  //   }).then((value) {
  //     setState(() => isLoad = false);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            tooltip: 'Filtrar favoritos',
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Favoritos'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Todos'),
              )
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  showFavoriteOnly = true;
                } else {
                  showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<ProductList>(context, listen: false).loadProducts(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return const Center(child: Text('Algo deu errado!'));
          } else {
            return ProductGrid(showFavoriteOnly: showFavoriteOnly);
          }
        }),
      ),
      // body: isLoad
      //     ? const Center(child: CircularProgressIndicator())
      //     : ProductGrid(showFavoriteOnly: showFavoriteOnly),
    );
  }
}
