import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../constants/colors.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String initialValue;
  final bool obscureText;
  final bool autoFocus;
  final FocusNode? focusNode;
  final IconButton? suffixIcon;
  final void Function()? onEditingComplete;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final bool? isTextCentered;
  final TextCapitalization textCapitalization;
  final int? maxLines;
  final bool wantToShowLabel;

  // AutoComplete
  final bool isAutoComplete;
  final List<String>? suggestions;
  final void Function(String)? onSuggestionSelected;

  const MyTextField({
    Key? key,
    this.controller,
    this.hintText = '',
    this.initialValue = '',
    this.obscureText = false,
    this.autoFocus = false,
    this.focusNode,
    this.suffixIcon,
    this.onEditingComplete,
    this.readOnly,
    this.keyboardType,
    this.textInputAction,
    this.onTap,
    this.onChanged,
    this.isTextCentered,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.isAutoComplete = false,
    this.suggestions,
    this.onSuggestionSelected,
    this.wantToShowLabel = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isAutoComplete) {
      return _buildAutoCompleteTextField();
    } else {
      return _buildTextFormField();
    }
  }

  Widget _buildTextFormField({
    TextEditingController? controllerFromParent,
    FocusNode? focusNodeFromParent,
  }) {
    return TextFormField(
      focusNode: focusNodeFromParent ?? (autoFocus ? null : focusNode),
      autofocus: autoFocus,
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        // labelText: hintText,
        labelText: wantToShowLabel ? hintText : null,
        hintText: wantToShowLabel ? null : hintText,
        suffixIcon: suffixIcon,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorConstants.primary,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
      obscureText: obscureText,
      cursorColor: ColorConstants.primary,
      onEditingComplete: () => onEditingComplete?.call(),
      readOnly: readOnly ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      textInputAction: textInputAction,
      onTap: () => onTap?.call(),
      onChanged: (value) => onChanged?.call(value),
      textAlign: isTextCentered ?? false ? TextAlign.center : TextAlign.start,
      controller: controllerFromParent ??
          (initialValue.isNotEmpty
              ? TextEditingController(text: initialValue)
              : controller),
      textCapitalization: textCapitalization,
      autocorrect: false,
      maxLines: maxLines,
    );
  }

  Widget _buildAutoCompleteTextField() {
    return TypeAheadField<String>(
      suggestionsCallback: (pattern) {
        return suggestions!.where((element) {
          return element.toLowerCase().contains(pattern.toLowerCase());
        }).toList();
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSelected: (String suggestion) {
        onSuggestionSelected?.call(suggestion);
      },
      builder: (context, controller, focusNode) {
        return _buildTextFormField(
          controllerFromParent: controller,
          focusNodeFromParent: focusNode,
        );
      },
      controller: controller,
    );
  }
}




// import 'package:flutter/material.dart';

// import '../../constants/colors.dart';

// class MyTextField extends StatelessWidget {
//   final TextEditingController? controller;
//   final String hintText;
//   final String initialValue;
//   final bool obscureText;
//   final bool autoFocus;
//   final FocusNode? focusNode;
//   final IconButton? suffixIcon;
//   final void Function()? onEditingComplete;
//   final bool? readOnly;
//   final TextInputType? keyboardType;
//   final TextInputAction? textInputAction;
//   final void Function()? onTap;
//   final void Function(String)? onChanged;
//   final bool? isTextCentered;
//   final TextCapitalization textCapitalization;
//   final int? maxLines;

//   const MyTextField({
//     Key? key,
//     this.controller,
//     this.hintText = '',
//     this.initialValue = '',
//     this.obscureText = false,
//     this.autoFocus = false,
//     this.focusNode,
//     this.suffixIcon,
//     this.onEditingComplete,
//     this.readOnly,
//     this.keyboardType,
//     this.textInputAction,
//     this.onTap,
//     this.onChanged,
//     this.isTextCentered,
//     this.textCapitalization = TextCapitalization.none,
//     this.maxLines = 1,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       focusNode: autoFocus ? null : focusNode,
//       autofocus: autoFocus,
//       textDirection: TextDirection.ltr,
//       decoration: InputDecoration(
//         labelText: hintText,
//         suffixIcon: suffixIcon,
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: ColorConstants.primary,
//           ),
//         ),
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.grey,
//           ),
//         ),
//       ),
//       obscureText: obscureText,
//       cursorColor: ColorConstants.primary,
//       onEditingComplete: () => onEditingComplete?.call(),
//       readOnly: readOnly ?? false,
//       keyboardType: keyboardType ?? TextInputType.text,
//       textInputAction: textInputAction,
//       onTap: () => onTap?.call(),
//       onChanged: (value) => onChanged?.call(value),
//       textAlign: isTextCentered ?? false ? TextAlign.center : TextAlign.start,
//       controller: initialValue.isNotEmpty
//           ? TextEditingController(text: initialValue)
//           : controller,
//       textCapitalization: textCapitalization,
//       // autocorrect: false,
//       maxLines: maxLines,
//     );
//   }
// }
