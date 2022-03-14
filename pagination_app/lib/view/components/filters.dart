part of main_page;

class _Filters extends StatelessWidget {
  const _Filters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ExpansionTile(
        onExpansionChanged: (value) {},
        title: const Text('Filtreler'),
        children: <Widget>[
          Wrap(
            children: TagList.tags.keys
                .map((key) => _TagCard(
                      TagList.tags[key],
                      key,
                    ))
                .toList(),
          ),
          TextButton.icon(
              onPressed: () {
                final _bloc = context.read<PaginationBloc>();
                // Alt satırlarda eklediğimiz tag i getIt paketi sayesinde PaginationFetch methodununu içerisine gönderebiliyoruz.
                //Her seferinde yeni bir arama olacağı için status=PaginationStatus.Inital yapıp gönderiyoruz.
                _bloc.add(PaginationFetch(
                    filters: getIt<TagList>().filters,
                    status: PaginationStatus.initial));
              },
              icon: const Icon(Icons.search),
              label: const Text('Ara'))
        ],
      ),
    );
  }
}

class _TagCard extends StatefulWidget {
  const _TagCard(
    this.tagValue,
    this.tagKey, {
    Key? key,
  }) : super(key: key);
  final String tagValue;
  final String tagKey;

  @override
  State<_TagCard> createState() => _TagCardState();
}

class _TagCardState extends State<_TagCard> {
  @override
  Widget build(BuildContext context) {
    //Butonun renk kontrolü
    bool _isSelected = false;
    for (String element in getIt<TagList>().filters) {
      if (element == widget.tagKey) {
        _isSelected = true;
      }
    }
    return Card(
      color: _isSelected ? Colors.purple : Colors.blueGrey,
      child: InkWell(
        onTap: () {
          bool _isInThere = false;
          for (String element in getIt<TagList>().filters) {
            if (element == widget.tagKey) {
              _isInThere = true;
            }
          }
          // Eğer içerisinde o tag ile başlayan bir veri yoksa ekliyor,Var ise tekrar tıklandığında o veriyi çıkartıyor.
          if (_isInThere) {
            getIt<TagList>().filters.remove(widget.tagKey);
          } else {
            getIt<TagList>().filters.add(widget.tagKey);
          }
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            widget.tagValue,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
