//
//  DotCalculatorViewController.m
//  Graph
//
//  Created by MacBook on 10/22/14.
//  Copyright (c) 2014 iMac. All rights reserved.
//

#import "DotCalculatorViewController.h"

@interface DotCalculatorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic) NSInteger method;
@property (nonatomic) NSInteger selectNumber;
@property (nonatomic) long double runningTotal;
@property (nonatomic) BOOL decimal;

@end

@implementation DotCalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Calculator";
    for (UIButton *button in [self.view subviews]) {
        if ([[button class] isSubclassOfClass:[UIButton class]]) {
            button.layer.borderWidth = 1.0;
            button.layer.borderColor = [self.view.tintColor CGColor];
            button.layer.cornerRadius = 4.0;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)number0:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"0"];

    }else{
        self.selectNumber = self.selectNumber*10;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }
}

- (IBAction)number1:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"1"];
    }else{
        self.selectNumber = self.selectNumber*10+1;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }

}

- (IBAction)number2:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"2"];
    }else{
        self.selectNumber = self.selectNumber*10+2;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }


}

- (IBAction)number3:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"3"];
    }else{
        self.selectNumber = self.selectNumber*10+3;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }


}

- (IBAction)number4:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"4"];
    }else{
        self.selectNumber = self.selectNumber*10+4;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }

}

- (IBAction)number5:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"5"];
    }else{
        self.selectNumber = self.selectNumber*10+5;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }

}

- (IBAction)number6:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"6"];
    }else{
        self.selectNumber = self.selectNumber*10+6;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }

}

- (IBAction)number7:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"7"];
    }else{
        self.selectNumber = self.selectNumber*10+7;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }

}

- (IBAction)number8:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"8"];
    }else{
        self.selectNumber = self.selectNumber*10+8;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }


}

- (IBAction)number9:(UIButton *)sender {
    if (self.decimal) {
        self.label.text = [self.label.text stringByAppendingString:@"9"];
    }else{
        self.selectNumber = self.selectNumber*10+9;
        self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];

    }

}

- (IBAction)divide:(UIButton *)sender {
    if (self.runningTotal == 0) {
        self.runningTotal = [self.label.text doubleValue];
        sender.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        switch (self.method) {
            case 1:
                self.runningTotal /= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            case 2:
                self.runningTotal *= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 3:
                self.runningTotal += [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 4:
                self.runningTotal -= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 5:
                self.runningTotal = [self permute:(NSInteger)[self.label.text doubleValue] ofN:(NSInteger)self.runningTotal];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 6:
                self.runningTotal = choose((NSInteger)self.runningTotal,[self.label.text longLongValue]);
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            default:
                break;
        }
    }

    
    self.selectNumber = 0;
    self.decimal = NO;

    //self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];
    self.method = 1;

    
}

- (IBAction)multiply:(UIButton *)sender {
    if (self.runningTotal == 0) {
        self.runningTotal = [self.label.text doubleValue];
        sender.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        switch (self.method) {
            case 1:
                self.runningTotal /= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            case 2:
                self.runningTotal *= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 3:
                self.runningTotal += [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 4:
                self.runningTotal -= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 5:
                self.runningTotal = [self permute:(NSInteger)[self.label.text doubleValue] ofN:(NSInteger)self.runningTotal];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 6:
                self.runningTotal = choose((NSInteger)self.runningTotal,[self.label.text longLongValue]);
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            default:
                break;
        }
    }
    
    self.selectNumber = 0;
    self.decimal = NO;

    //self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];
    self.method = 2;
}

- (IBAction)add:(UIButton *)sender {
    if (self.runningTotal == 0) {
        self.runningTotal = [self.label.text doubleValue];
        sender.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        switch (self.method) {
            case 1:
                self.runningTotal /= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            case 2:
                self.runningTotal *= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 3:
                self.runningTotal += [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 4:
                self.runningTotal -= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 5:
                self.runningTotal = [self permute:(NSInteger)[self.label.text doubleValue] ofN:(NSInteger)self.runningTotal];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 6:
                self.runningTotal = choose((NSInteger)self.runningTotal,[self.label.text longLongValue]);
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            default:
                break;
        }
    }
    
    self.selectNumber = 0;
    self.decimal = NO;
    //self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];
    self.method = 3;
}

- (IBAction)minus:(UIButton *)sender {
    if (self.runningTotal == 0) {
        self.runningTotal = [self.label.text doubleValue];
        sender.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        switch (self.method) {
            case 1:
                self.runningTotal /= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            case 2:
                self.runningTotal *= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 3:
                self.runningTotal += [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 4:
                self.runningTotal -= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 5:
                self.runningTotal = [self permute:(NSInteger)[self.label.text doubleValue] ofN:(NSInteger)self.runningTotal];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 6:
                self.runningTotal = choose((NSInteger)self.runningTotal,[self.label.text longLongValue]);
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            default:
                break;
        }
    }

    
    self.selectNumber = 0;
    self.decimal = NO;
    //self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];
    self.method = 4;
}

- (IBAction)equals:(UIButton *)sender {
    if (self.runningTotal == 0) {
        self.runningTotal = [self.label.text doubleValue];
    }else{
        switch (self.method) {
            case 1:
                self.runningTotal /= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            case 2:
                self.runningTotal *= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 3:
                self.runningTotal += [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 4:
                self.runningTotal -= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 5:
                self.runningTotal = [self permute:(NSInteger)[self.label.text longLongValue] ofN:(NSInteger)self.runningTotal];
                self.label.text = [NSString stringWithFormat:@"%.Lf",self.runningTotal];
                
                break;
            case 6:
                self.runningTotal = choose((NSInteger)self.runningTotal,[self.label.text longLongValue]);
                self.label.text = [NSString stringWithFormat:@"%.Lf",self.runningTotal];
                break;
            default:
                break;
        }
    }
    self.runningTotal = 0;
    self.method = 0;
    self.decimal = NO;
    for (UIButton *button in [self.view subviews]) {
        if ([button isMemberOfClass:[UIButton class]]) {
            button.layer.borderColor = self.view.tintColor.CGColor;

        }
    }
    //self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
   
}

- (IBAction)permutation:(UIButton *)sender {
    if (self.runningTotal == 0) {
        self.runningTotal = [self.label.text doubleValue];
        sender.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        switch (self.method) {
            case 1:
                self.runningTotal /= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            case 2:
                self.runningTotal *= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 3:
                self.runningTotal += [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 4:
                self.runningTotal -= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 5:
                self.runningTotal = [self permute:(NSInteger)[self.label.text doubleValue] ofN:(NSInteger)self.runningTotal];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 6:
                self.runningTotal = choose((NSInteger)self.runningTotal,[self.label.text longLongValue]);
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            default:
                break;
        }
    }
    self.selectNumber = 0;
    self.decimal = NO;
    //self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];
    self.method = 5;
}

- (IBAction)combination:(UIButton *)sender {
    if (self.runningTotal == 0) {
        self.runningTotal = [self.label.text doubleValue];
        sender.layer.borderColor = [UIColor redColor].CGColor;
    }else{
        switch (self.method) {
            case 1:
                self.runningTotal /= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            case 2:
                self.runningTotal *= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 3:
                self.runningTotal += [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 4:
                self.runningTotal -= [self.label.text doubleValue];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 5:
                self.runningTotal = [self permute:(NSInteger)[self.label.text longLongValue] ofN:(NSInteger)self.runningTotal];
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                
                break;
            case 6:
                self.runningTotal = choose((NSInteger)self.runningTotal,[self.label.text longLongValue]);
                self.label.text = [NSString stringWithFormat:@"%Lf",self.runningTotal];
                break;
            default:
                break;
        }
    }
    self.selectNumber = 0;
    self.decimal = NO;

    //self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];
    self.method = 6;
}

- (IBAction)clear:(UIButton *)sender {
    self.selectNumber = 0;
    self.method = 0;
    self.runningTotal = 0;
    self.decimal = NO;
    self.label.text = [NSString stringWithFormat:@"%li",(long)self.selectNumber];
    for (UIButton *button in [self.view subviews]) {
        if ([button isMemberOfClass:[UIButton class]]) {
            button.layer.borderColor = self.view.tintColor.CGColor;
            
        }
    }
}

- (IBAction)factorial:(id)sender {
    NSInteger result = 1;
    for (long long x = [self.label.text longLongValue]; x > 0; x--)
    {
        result *= x;
    }
    self.label.text = [NSString stringWithFormat:@"%li",(long)result];
    self.selectNumber = 0;
    self.method = 0;
    self.runningTotal = result;
}


- (IBAction)decimal:(UIButton *)sender {
    self.decimal = YES;
    self.label.text = [NSString stringWithFormat:@"%li.",(long)self.selectNumber];
}

-(NSInteger)factorialOfN:(NSInteger)n
{
    NSInteger result = 1;
    for (NSInteger x = n; x > 0; x--)
    {
        result *= x;
    }
    return result;
}

-(NSInteger)permute:(NSInteger)k ofN:(NSInteger)n
{
    return [self factorialOfN:n]/[self factorialOfN:(n-k)];
}

-(NSInteger)combination:(NSInteger)k ofN:(NSInteger)n
{
    return [self permute:k ofN:n]/[self permute:k ofN:k];
}

unsigned long long choose(unsigned long long n, unsigned long long k) {
    if (k > n) {
        return 0;
    }
    unsigned long long r = 1;
    for (unsigned long long d = 1; d <= k; ++d) {
        r *= n--;
        r /= d;
    }
    NSLog(@"%llu",r);
    return r;
}

@end
