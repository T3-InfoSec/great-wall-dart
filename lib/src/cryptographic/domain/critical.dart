import 'package:cryptography/cryptography.dart';
import 'package:great_wall/src/cryptographic/domain/entropy.dart';

class Critical extends Entropy {

  late SecretBox secretBox;

  Critical(super.value);

}