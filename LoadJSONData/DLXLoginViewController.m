//
//  DLXLoginViewController.m
//  LoadJSONData
//
//  Created by admin on 15/9/17.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "DLXLoginViewController.h"

#import "DLXSpaceViewController.h"

@interface DLXLoginViewController ()
{
    UILabel *_cancelLabel;
    UIImageView *_loadImageView;
    NSMutableArray *_loadImages;
}
@end

static NSString *loginStr = @"json_ws.asmx/login";

@implementation DLXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    
    UITapGestureRecognizer *tapGesutre = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer)];
    [self.view addGestureRecognizer:tapGesutre];
    
    _loadImages = [NSMutableArray arrayWithCapacity:23];
    for (int i=1; i<24; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"b%d.png",i]];
        
        image = [UIImage imageWithCGImage:image.CGImage scale:0.5 orientation:UIImageOrientationUp];
        [_loadImages addObject:image];
    }
    
    
    _loadImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,60, 60)];
    [_loadImageView setCenter:_loginBtn.center];
    [_loadImageView setHidden:YES];
    [self.view addSubview:_loadImageView];
}

#pragma mark -手势方法
-(void)tapGestureRecognizer
{
    [_userNameTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];

}
#pragma mark -登录事件
- (IBAction)login
{
    if (_userNameTextField.text.length==0)//textField为空的动画
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat x = _userNameTextField.center.x;
        CGFloat y = _userNameTextField.center.y;
        
        [path moveToPoint:CGPointMake(x-15, y)];
        [path addLineToPoint:CGPointMake(x+15, y)];
        [path closePath];
        
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = path.CGPath;
        moveAnim.repeatCount = 2 ;
        moveAnim.speed = 4;
        moveAnim.autoreverses = YES;
        [_userNameTextField.layer addAnimation:moveAnim forKey:@"shakeAnimation"];
    }
   else if (_pwdTextField.text.length==0)//textField为空的动画
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGFloat x = _pwdTextField.center.x;
        CGFloat y = _pwdTextField.center.y;
        
        [path moveToPoint:CGPointMake(x-15, y)];
        [path addLineToPoint:CGPointMake(x+15, y)];
        [path closePath];
        
        CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnim.path = path.CGPath;
        moveAnim.repeatCount = 2 ;
        moveAnim.speed = 4;
        moveAnim.autoreverses = YES;
        [_pwdTextField.layer addAnimation:moveAnim forKey:@"shakeAnimation"];
    }
    else
    {
        [_userNameTextField resignFirstResponder];
        [_pwdTextField resignFirstResponder];
        [self showLoading];
        [self loginForwardWithInfo:_userNameTextField.text pwd:_pwdTextField.text];
    
    }
}

- (IBAction)cancel:(id)sender {
    
    DLXSpaceViewController *spaceController = [[DLXSpaceViewController alloc]init];
    [self presentViewController:spaceController animated:YES completion:nil];
}

#pragma mark -显示加载条
-(void)showLoading
{
    [_loginBtn setHidden:YES];
    [_loadImageView setHidden:NO];
    [_loadImageView setAnimationImages:_loadImages];
    [_loadImageView setAnimationDuration:1.0f];
    [_loadImageView startAnimating];

}

#pragma mark -异步登陆方法
-(void)loginForwardWithInfo:(NSString *)userName pwd:(NSString *)pwd;
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kBasicURL,loginStr];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:2.0f];
    
    [request setHTTPMethod:@"POST"];
    NSString *httpBodyStr = [NSString stringWithFormat:@"strUser=%@&strPwd=%@",userName,pwd];
    NSData *HTTPdata = [httpBodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:HTTPdata];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *strResponse;
        [_loadImageView setHidden:YES];
        [_loginBtn setHidden:NO];
        if(data)
       {
            strResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
           NSRange range = [strResponse rangeOfString:@"用户名"];
           if (range.location>0)
           {
              
              [_superViewController setOnLine:YES];
               [self dismissViewControllerAnimated:YES completion:nil];
           }
           else
           {
               [alertView setMessage:strResponse];
               [alertView show];
           }
           
       }
       else if (!data && !connectionError)
       {
           strResponse = @"登陆失败，请重试";
        
           [alertView setMessage:strResponse];
           [alertView show];
       }
        else
        {
            strResponse = [connectionError localizedDescription];
            [alertView setMessage:strResponse];
            [alertView show];
        }
        
    }];
   
   

}
@end
