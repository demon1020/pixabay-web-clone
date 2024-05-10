import '/core.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  bool obscureText;
  double height;
  double width;
  final bool showSuffixIcon;
  final Widget? suffix;
  final FormFieldValidator? validator;
  final TextInputType textInputType;
  final void Function(String)? onFieldSubmitted;
  final void Function()? onEditingComplete;

  AppTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.obscureText = false,
    this.showSuffixIcon = false,
    this.validator,
    this.textInputType = TextInputType.text,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.suffix,
    required this.height,
    required this.width,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        validator: widget.validator,
        keyboardType: widget.textInputType,
        onEditingComplete: widget.onEditingComplete,
        onFieldSubmitted: widget.onFieldSubmitted,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 30, right: 10),
            child: Icon(
              Icons.search,
              // color: Colors.green,
            ),
          ),
          suffixIcon: widget.suffix,
          // suffixIcon: widget.showSuffixIcon
          //     ? IconButton(
          //         onPressed: () {
          //           widget.obscureText = !widget.obscureText;
          //           setState(() {});
          //         },
          //         icon: widget.obscureText
          //             ? const Icon(Icons.remove_red_eye_outlined)
          //             : const Icon(Icons.lock),
          //       )
          //     : const SizedBox.shrink(),
          fillColor: AppColor.white,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: AppColor.lightGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        ),
        expands: true,
        minLines: null,
        maxLines: null,
      ),
    );
  }
}
