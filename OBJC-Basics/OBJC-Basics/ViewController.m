//
//  ViewController.m
//  OBJC-Basics
//
//  Created by Gareth on 11/10/16.
//  Copyright © 2016 Gareth. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // create a string, with string literal
    NSString *productTitle = @"Bouncy Balls";
    // this is the same as the above
//    NSString *productTitleTwo = [NSString stringWithUTF8String:"Bouncy Balls"];
    
    // the string in the above is just a char, which is an array of chars for example
//    char thing[] = "This is a char string";
    
    // astrix is pointer, used when creating objects in NSString
    NSString *manufacturer = @"Acme Novalty";
    
    // no * as creating a C int, this is a primitive (scalar) : not an abject
    int quantity = 144;
    float price = 19.99;
    
    // if you set this as double you get more accuracy
    float unitPrice = price/quantity;
    
    // NS Arrays only hold objects. so cannot put primatives in like floats or ints
//    NSArray *priceArray = @[unitPrice]; <- this will fail
    // so convert to nsnuber obj using method on float and add that instead
    NSNumber *unitPriceNumber = [NSNumber numberWithFloat:unitPrice];
    NSArray *priceArray = @[unitPriceNumber];
    
    // or there is an even shorter way to driectly wrap the float
    NSArray *secondPriceArray = @[@(unitPrice)];
    
    
    // String concatination i for ints, f for foats and doubles @for strings values, which is the string
    NSString *blurb = [NSString stringWithFormat:@"You selected %@, made by %@. %@ came in quantity of %i, for a price of %.2f and a unit price of %.2f", productTitle, manufacturer, productTitle, quantity, price, unitPrice];
    // the .2 on the float is the decimal formating so how many points to display
    
    NSLog(blurb);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
