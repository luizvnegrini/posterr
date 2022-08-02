import 'app.dart';
import 'flavors/flavors.dart';

void main() {
  F.appFlavor = Flavor.prod;
  Startup.run();
}
