//
//  FollowingsViewController.m
//  XianMao
//
//  Created by simon cai on 21/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "FollowingsViewController.h"
#import "Command.h"

//@interface FollowingsViewController ()
//@property(nonatomic,strong) UIView *recommendLoginView;
//@end
//
//@implementation FollowingsViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.recommendLoginView.frame = CGRectMake(0, 0, kScreenWidth, 60);
//    [self.view addSubview:self.recommendLoginView];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (UIView*)recommendLoginView {
//    if (!_recommendLoginView) {
//        _recommendLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
//        _recommendLoginView.backgroundColor = [UIColor colorWithHexString:@"282828"];
//        
//        UIImage *img = [UIImage imageNamed:@"recommend_login_cat"];
//        CALayer *layer = [CALayer layer];
//        layer.contents = (id)img.CGImage;
//        layer.frame = CGRectMake(13, (_recommendLoginView.height-img.size.height)/2, img.size.width, img.size.height);
//        [_recommendLoginView.layer addSublayer:layer];
//     
//        CommandButton *loginBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-60-5, (_recommendLoginView.height-30)/2, 60, 30)];
//        loginBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
//        loginBtn.layer.masksToBounds = YES;
//        loginBtn.layer.cornerRadius = 15.f;
//        [loginBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
//        [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
//        loginBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
//        [_recommendLoginView addSubview:loginBtn];
//        
//        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectNull];
//        lbl.text = @"喵，你还没登陆呢～";
//        lbl.font = [UIFont systemFontOfSize:13.f];
//        lbl.textColor = [UIColor whiteColor];
//        [lbl sizeToFit];
//        lbl.frame = CGRectMake(67, 15, lbl.width, lbl.height);
//        [_recommendLoginView addSubview:lbl];
//        
//        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectNull];
//        lbl2.text = @"";
//        lbl2.font = [UIFont systemFontOfSize:10.f];
//        lbl2.textColor = [UIColor colorWithHexString:@"666666"];
//        [lbl2 sizeToFit];
//        lbl2.frame = CGRectMake(67, 15, lbl2.width, lbl2.height);
//        [_recommendLoginView addSubview:lbl2];
//        
//    }
//    return _recommendLoginView;
//}
//
//@end
