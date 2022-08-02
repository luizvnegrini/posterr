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
        return 'Transport_app dev';
      case Flavor.hml:
        return 'Transport_app hml';
      case Flavor.prod:
        return 'Transport_app prod';
      default:
        throw UnimplementedError('Flavor not encountered');
    }
  }
}
