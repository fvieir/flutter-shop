import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product_list.dart';

import '../models/product.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = <String, Object>{};
  bool isLoad = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;

      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();

    _imageUrlFocus.dispose();
    _imageUrlFocus.removeListener(_updateImage);
  }

  void _updateImage() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    bool isvalidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endWithType = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg');

    return isvalidUrl && endWithType;
  }

  dynamic defaultValidateWithString(String label, int letersLength) {
    if (label.trim().isEmpty) {
      return 'Campo nome é obrigatório!';
    }

    if (label.trim().length < letersLength) {
      return 'Campo precisa no minimo de $letersLength letras!';
    }

    return null;
  }

  void navigatorPop() {
    return Navigator.of(context).pop();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => isLoad = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);
      navigatorPop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(
            'Algo deu errado',
            style: TextStyle(color: Colors.black87),
          ),
          content: const Text(
              'Erro ao salvar produto, entre em contato com suporte'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isLoad = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulario de Produtos'),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoad
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: const InputDecoration(labelText: 'Nome'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name as String,
                      validator: (newValue) {
                        final name = newValue ?? '';
                        return defaultValidateWithString(name, 3);
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: const InputDecoration(
                        labelText: 'Preço',
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      focusNode: _priceFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      validator: (value) {
                        final priceString = value ?? '';
                        double price = double.tryParse(priceString) ?? -1;

                        if (price <= 0) {
                          return 'Informe um valor maior que 0.';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: const InputDecoration(labelText: 'Descrição'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocus,
                      onSaved: (description) =>
                          _formData['description'] = description as String,
                      validator: (value) {
                        String description = value ?? '';
                        return defaultValidateWithString(description, 10);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Imagem Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocus,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? '',
                            validator: (value) {
                              String url = value ?? '';

                              if (!isValidImageUrl(url)) {
                                return 'Favor informar url válida!';
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Informe a Url')
                              : Image.network(_imageUrlController.text),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
