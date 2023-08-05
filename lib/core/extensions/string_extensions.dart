extension StringTruncate on String {
  String truncate(int length) {
    return this.length > length ? substring(0, length) : this;
  }

  String truncateWithEllipsis(int length) {
    return this.length > length ? '${substring(0, length)}..' : this;
  }
}
