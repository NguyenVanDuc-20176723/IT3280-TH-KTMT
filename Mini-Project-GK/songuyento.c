#include<stdio.h>

int is_prime(int n){
  int dem;
  
  if(n < 2) dem = 1;
  else if(n == 2) dem = 0;
  else{
    int i = 2;
    dem = 0;
    for(;i <= n/2;i++){
      if(n%i == 0){
	dem++;
	break;
      }
    }
  }
  return dem;
}

void main(){
  int n,m,i, index = 0;
  int a[100];
  printf("nhap so nguyen n va m:");
  scanf("%d%d",&n,&m);
  for(i = n; i <= m; i++){
    if(is_prime(i) == 0){
      a[index] = i;
      index++;
    }
  }
  printf("danh sach so nguyen to: ");
  for(i = 0;i<index;i++){
    printf("%d ",a[i]);
  }
  printf("\n");
}
