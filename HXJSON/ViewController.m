//
//  ViewController.m
//  HXJSON
//
//  Created by TAL on 2018/7/11.
//  Copyright © 2018年 TAL. All rights reserved.
//

#import "ViewController.h"
#import "HXJSON.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HXJSON * json = [HXJSON jsonWithObject:@[@"111"]];
    [json.array enumerateObjectsUsingBlock:^(HXJSON * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj == %@", obj.object);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
