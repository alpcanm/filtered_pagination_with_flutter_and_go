part of main_page;

class _MoreButton extends StatelessWidget {
  const _MoreButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          context
              .read<
                  PaginationBloc>() //filtreler dosyasında getIt ile içeri attığımız filtrelere buradan tekrar ulaşabiliyoruz.
              .add(PaginationFetch(filters: getIt<TagList>().filters));
        },
        child: const Text("Daha Fazla"));
  }
}
