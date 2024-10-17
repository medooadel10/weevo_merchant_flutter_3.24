class Slide {
  String title;
  String image;
  String desc;

  Slide({
    required this.image,
    required this.desc,
    required this.title,
  });
}

final slideList = [
  Slide(
    image: 'assets/images/on_boarding_02.png',
    desc: 'ابدأ بعرض طلبات الشحن لمنتجاتك\nبكل سهولة',
    title: "قدم طلبات الشحن",
  ),
  Slide(
    image: 'assets/images/on_boarding_03.png',
    desc: 'تصفح عروض التوصيل المقدمة\nواختر الأفضل',
    title: "استقبل عروض الشحن",
  ),
  Slide(
    image: 'assets/images/on_boarding_01.png',
    desc: 'قدم طلب السحب واختر وسيلة\nالتحويل الأنسب',
    title: "استلم تكلفة طلباتك",
  ),
];
