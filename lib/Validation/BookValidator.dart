mixin BookValidationMixin {

  String? validateBookName(String? value){

    if(value!.length<1){
      return "Book names length must be more than 1 words.";

    }

  }
  String? validateAuthorName(String? value){

    if(value!.length<1){
      return "Author names length must be more than 1 words.";

    }

  }
  String? validateTopic(String? value){

    if(value!.length<1){
      return "Topics length must be more than 1 words.";

    }

  }
  String? validatePageNumber(String? value){

    int number = int.parse(value!);
    if(number<1){
      return "Page Number must be greater than 0.";
    }

  }
}