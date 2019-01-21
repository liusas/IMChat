//
//  ViewController.m
//  IMDemo
//
//  Created by 刘峰 on 2018/10/28.
//  Copyright © 2018年 Liufeng. All rights reserved.
//

#import "ViewController.h"
#import "ChatViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//按钮点击事件
- (IBAction)buttonChatClick:(id)sender {
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatMode:ChatModeSingle];
    [self.navigationController pushViewController:chatVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
