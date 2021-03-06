//
//  main.m
//  Assignment1
//
//  Created by Alex Altabaev on 01.11.12.
//  Copyright (c) 2012 Alex Altabaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"

@interface Cell (Mutator)
-(void) mutate:(int) n;
@end

@implementation Cell (Mutator)
-(void) mutate:(int)n {
    // подготавливаем массив для набора n% случайных индексов массива ДНК 
    int k = 0; // счетчик
    int index = 0; // переменная для случайного значения
    int q = floorf(n*(self->lenght +1)/100);// переменная для количества ячеек составляющих n% от длины масива ДНК
    int indexes[q]; // собственно сам масив для случайных индексов - при инициализации заполнен нолями
    for(int i = 0; i < q; i++){ // заполняем массив заведомо недостижимым индексом
        indexes[i] = q;         // поскольку arc4random может сгенерировать 0 и будут проблемы
    }
    while(k < q) { // заполняем массив случайными индексами при этом проверяем чтобы индексы были уникальны
        index = arc4random()%(self->lenght + 1);
        bool exists = NO;
        for(int i = 0; i < q; i++){
            if (indexes[i] == index) {
                exists = YES;
                break;
            }
        }
        if(!exists) {
            indexes[k] = index;
            k++;
        }
    }
    //массив случайных индексов готов - начинаем мутацию :)
    for(int i = 0; i < q; i++) {
        NSMutableArray *letters_cutted = [[NSMutableArray alloc] initWithArray: self->letters];// создаем копию массива букв
        [letters_cutted removeObjectIdenticalTo:self->DNA[indexes[i]]];// удаляем из копии текущее занчение по индексу
        [self->DNA replaceObjectAtIndex:indexes[i] withObject:letters_cutted[arc4random()%3]];// генерируем новое значение
    }                                                                                         // из обрезаного массива букв
}
@end

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        Cell *myCell1;
        myCell1 = [[Cell alloc] init]; // инициализируем первый Cell
        
        Cell *myCell2;
        myCell2 = [[Cell alloc] init]; // инициализируем втоой Cell
        
        for(int i = 0; i <=myCell1->lenght; i++) { // я решил вывести их рядом - удобно для тестирования
            NSLog(@"%@ %@", myCell1->DNA[i], myCell2->DNA[i]);
        }
        
        NSLog(@"Hamming distance is %i",[myCell1 hammingDistance:myCell2]); // подсчет расстояния Хэмминга

        [myCell1 mutate:50]; // мутируем первый 
        [myCell2 mutate:50]; // мутируем второй
        
        for(int i = 0; i <=myCell1->lenght; i++) { // выводим мутантов :)
            NSLog(@"%@ %@", myCell1->DNA[i], myCell2->DNA[i]);
        }
        
        NSLog(@"Hamming distance is %i",[myCell1 hammingDistance:myCell2]); // подсчет расстояния Хэмминга для мутантов
    }
    return 0;
}

