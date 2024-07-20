//
// Uint8List encryptBytesCTR(String keyString, Uint8List inputBytes) {
//   final key = Key.fromUtf8(keyString);
//   final iv = IV.fromLength(16); // Random IV of 16 bytes (CTR mode also uses IV)
//   final encrypter = Encrypter(AES(key, mode: AESMode.ctr));
//   final encrypted = encrypter.encryptBytes(inputBytes, iv: iv);
//   var ivInFrontBytes = iv.bytes + encrypted.bytes;
//   return Uint8List.fromList(ivInFrontBytes);
// }
//
// List<int> decryptBytesCTR(String keyString, Uint8List inputBytes) {
//   final key = Key.fromUtf8(keyString);
//   final iv = IV(Uint8List.fromList(
//       inputBytes.sublist(0, 16))); // Extract IV from the beginning of the file
//   final encryptedData =
//       inputBytes.sublist(16); // The rest is the encrypted data
//   final encrypter = Encrypter(AES(key, mode: AESMode.ctr));
//   final decrypted = encrypter.decryptBytes(Encrypted(encryptedData), iv: iv);
//   return decrypted;
// }
