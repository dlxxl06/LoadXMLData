//
//  DLXLoginViewController.h
//  LoadJSONData
//
//  Created by admin on 15/9/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface DLXLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)login;
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,strong)  ViewController *superViewController;
@end
