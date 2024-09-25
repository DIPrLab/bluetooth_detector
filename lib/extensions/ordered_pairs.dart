extension OrderedPairs<T, E> on List<T> {
  List<(T, T)> orderedPairs() {
    List<(T, T)> result = List.empty(growable: true);
    for (int i = 0; i < this.length - 1; i++) {
      T t1 = this[i];
      T t2 = this[i + 1];
      result.add((t1, t2));
    }
    return result;
  }

  List<E> mapOrderedPairs(E Function((T, T)) toElement) => this.orderedPairs().map(toElement).toList();

  void forEachMappedOrderedPair(E Function(T) toElement, void Function((E, E)) action) =>
      this.map(toElement).toList().orderedPairs().forEach(action);
}
