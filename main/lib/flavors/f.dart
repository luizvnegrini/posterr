// ignore_for_file: file_names

enum Flavor {
  dev,
  hml,
  prod,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.dev:
        return 'posterr dev';
      case Flavor.hml:
        return 'posterr hml';
      case Flavor.prod:
        return 'posterr prod';
      default:
        throw UnimplementedError('Flavor not encountered');
    }
  }
}
