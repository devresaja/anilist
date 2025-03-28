class Pagination<T> {
  final List<T>? data;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final bool hasNextPage;

  Pagination({
    required this.data,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.hasNextPage,
  });
}
