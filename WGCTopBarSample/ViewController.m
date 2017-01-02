//
//  ViewController.m
//  WGCTopBarSample
//
//  Created by Messi on 02/01/2017.
//  Copyright © 2017 WGC. All rights reserved.
//

#import "ViewController.h"
#import "WGCTopBar.h"
#import <YYKit/UIView+YYAdd.h>
#import "MessiViewController.h"
#import "IniestaViewController.h"
#import "XaviViewController.h"

@interface ViewController ()<UIScrollViewDelegate, WGCTopBarDelegate>

@property (strong, nonatomic) WGCTopBar *topBar;
@property (strong, nonatomic) UIScrollView *scrContainer;
@property (strong, nonatomic) MessiViewController *messiVC;
@property (strong, nonatomic) IniestaViewController *iniestaVC;
@property (strong, nonatomic) XaviViewController *xaviVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.topBar];
    
    [self.view addSubview:self.scrContainer];
    
    [self.scrContainer addSubview:self.messiVC.view];
    [self.scrContainer addSubview:self.iniestaVC.view];
    [self.scrContainer addSubview:self.xaviVC.view];
}

#pragma mark - UIScrollViewDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    
    [self.topBar moveIndicatorToCenterX:self.view.width/self.topBar.titles.count/2+offset.x/3];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    NSInteger index = offset.x/self.view.width;
    [self.topBar moveIndicatorToIndex:index];
}

#pragma mark - WGCTopBarDelegate

- (void)topBar:(WGCTopBar *)topBar didSelectItemAtIndex:(NSInteger)index {
    self.scrContainer.contentOffset = CGPointMake(self.view.width*index, 0);
}

#pragma mark - setters&getters

- (WGCTopBar *)topBar {
    if (!_topBar) {
        _topBar = [[WGCTopBar alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 50)];
        
        //set the properties of the topbar.
        _topBar.titles = @[@"Messi", @"Iniesta", @"Xavi"];
        _topBar.topBarItemBackgroudColor = [UIColor lightGrayColor];
        _topBar.delegate = self;
    }
    return _topBar;
}

- (UIScrollView *)scrContainer {
    if (!_scrContainer) {
        _scrContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topBar.bottom, self.view.width, self.view.height-self.topBar.bottom)];
        _scrContainer.contentSize = CGSizeMake(self.view.width*3, _scrContainer.height);
        _scrContainer.pagingEnabled = YES;
        _scrContainer.delegate = self;
    }
    return _scrContainer;
}

- (MessiViewController *)messiVC {
    if (!_messiVC) {
        _messiVC = [[MessiViewController alloc] init];
        _messiVC.view.frame = CGRectMake(0, 0, self.view.width, self.scrContainer.height);
        [self addChildViewController:_messiVC];
    }
    return _messiVC;
}

- (IniestaViewController *)iniestaVC {
    if (!_iniestaVC) {
        _iniestaVC = [[IniestaViewController alloc] init];
        _iniestaVC.view.frame = CGRectMake(self.view.width, 0, self.view.width, self.scrContainer.height);
        [self addChildViewController:_iniestaVC];
    }
    return _iniestaVC;
}

- (XaviViewController *)xaviVC {
    if (!_xaviVC) {
        _xaviVC = [[XaviViewController alloc] init];
        _xaviVC.view.frame = CGRectMake(self.view.width*2, 0, self.view.width, self.scrContainer.height);
        [self addChildViewController:_xaviVC];
    }
    return _xaviVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
