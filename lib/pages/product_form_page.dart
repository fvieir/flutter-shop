import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _focusPrice = FocusNode();
  final _focusDescription = FocusNode();

  @override
  void dispose() {
    super.dispose();

    _focusPrice.dispose();
    _focusDescription.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Produtos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Nome'),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusPrice);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Preço'),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                focusNode: _focusPrice,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_focusDescription);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  label: Text('Descrição'),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                focusNode: _focusDescription,
              )
            ],
          ),
        ),
      ),
    );
  }
}
