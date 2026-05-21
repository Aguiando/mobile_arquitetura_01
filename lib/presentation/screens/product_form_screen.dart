import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/product.dart';
import '../../services/providers.dart';
import '../widgets/labeled_field.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  /// If [product] is provided the form is in edit mode; otherwise create mode.
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _price;
  late final TextEditingController _image;
  late final TextEditingController _category;

  bool _isLoading = false;
  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _title = TextEditingController(text: p?.title ?? '');
    _description = TextEditingController(text: p?.description ?? '');
    _price = TextEditingController(
        text: p != null ? p.price.toStringAsFixed(2) : '');
    _image = TextEditingController(text: p?.thumbnail ?? '');
    _category = TextEditingController(text: p?.category ?? '');
  }

  @override
  void dispose() {
    for (final c in [_title, _description, _price, _image, _category]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(productsProvider.notifier);

      if (_isEditing) {
        final updated = widget.product!.copyWith(
          title: _title.text.trim(),
          description: _description.text.trim(),
          price: double.parse(_price.text.trim()),
          thumbnail: _image.text.trim(),
          category: _category.text.trim(),
        );
        await notifier.update((products) => products
            .map((p) => p.id == updated.id ? updated : p)
            .toList());
      } else {
        final newProduct = Product(
          title: _title.text.trim(),
          description: _description.text.trim(),
          price: double.parse(_price.text.trim()),
          thumbnail: _image.text.trim(),
          category: _category.text.trim(),
          rating: 0,
        );
        await notifier.add(newProduct);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                _isEditing ? 'Produto atualizado!' : 'Produto criado!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Produto' : 'Novo Produto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LabeledField(
                label: 'Título *',
                controller: _title,
                hint: 'Nome do produto',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
              ),
              LabeledField(
                label: 'Descrição *',
                controller: _description,
                hint: 'Descreva o produto',
                maxLines: 3,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
              ),
              LabeledField(
                label: 'Preço (R\$) *',
                controller: _price,
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
                  if (double.tryParse(v.trim()) == null) return 'Valor inválido';
                  return null;
                },
              ),
              LabeledField(
                label: 'URL da Imagem',
                controller: _image,
                hint: 'https://...',
                keyboardType: TextInputType.url,
              ),
              LabeledField(
                label: 'Categoria',
                controller: _category,
                hint: 'ex: electronics',
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_isEditing ? 'Salvar alterações' : 'Cadastrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}