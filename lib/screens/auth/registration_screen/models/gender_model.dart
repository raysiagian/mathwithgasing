class Gender{
  final String explanation;
  final String imageGender;
  final String code;

  Gender({
    required this.imageGender,
    required this.explanation,
    required this.code,
 });

 static final listGender = [
  Gender(
    code: 'P',
    imageGender: 'assets/images/icon_profile woman.png',
    explanation: 'Perempuan',
  ),
  Gender(
    code: 'L',
    imageGender: 'assets/images/icon_profile man.png',
    explanation: 'Laki - Laki',
  ),
 ];
}
