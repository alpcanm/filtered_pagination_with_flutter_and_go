part of main_page;

class _MainBody extends StatelessWidget {
  const _MainBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PaginationBloc, PaginationState>(
      buildWhen: (previous, current) => previous.products != current.products,
      builder: (context, state) {
        if (state.status == PaginationStatus.failure) {
          return const Center(child: Text("No data"));
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final _productCard = _ProductCard(product: state.products[index]);
            // 0. indexte filtreler ve _productCard var;
            if (index == 0) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [const _Filters(), _productCard]);
            } else if (index >= state.products.length - 1) {
              //son indexte _productCard ve MoreButton var;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [_productCard, const _MoreButton()]);
            }
            return _productCard;
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    Key? key,
    required this.product,
  }) : super(key: key);
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: checkColor(),
      child: Column(children: [
        Text(product.tag ?? ""),
        Text(product.title ?? ""),
        Text(product.date.toString()),
      ]),
    );
  }

  Color? checkColor() {
    return product.tag == "mavi"
        ? Colors.blue
        : product.tag == "sari"
            ? Colors.yellow
            : product.tag == "kirmizi"
                ? Colors.red
                : null;
  }
}
