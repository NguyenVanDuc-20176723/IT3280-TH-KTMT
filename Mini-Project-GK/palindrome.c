#include<stdio.h>
#include<string.h>
int is_palindrome(char *str){
  int i = 0,dem = 0, len = strlen(str);
  if(len > 0){
    for(;i <= (len/2);i++){
      if(str[i] != str[len-1-i]){
	dem = 1;
	break;
      }
    }
  }else dem = 1;
  return dem;
}

void main(){
  char str[100];
  printf("nhap xau:\n");
  gets(str);
  if(is_palindrome(str) == 0){
    printf("\"%s\" la palindrome.\n",str);
  }else printf("\"%s\" khong phai la palindrome.\n",str);
}
