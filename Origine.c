int processa (char num, int val){
    int tmp;
    if(num<58)
        tmp=(num-48+val)/2;
    else tmp=val;
    return tmp;
}
main(){
    char num[8];
    int V[8],i,a;

    printf("Inserisci una stringa di soli numeri\n");
    scanf("%s",NUM);
   for(int i=0;i<strlen(NUM);i++){
       printf("Inserisci un numero\n");
        scanf("%d,&a);
        V[i]=confronta(NUM[i],a);
        printf("Valore=%d\n",V[i]);
    }
}
