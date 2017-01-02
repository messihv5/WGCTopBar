//
//  WGCTopBar.h
//  CustomViewTopBar
//
//  Created by messihv5 on 24/12/2016.
//  Copyright © 2016 messihv5. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WGCTopBarIndicatorType) {
    WGCTopBarIndicatorTypeDefault,
    WGCTopBarIndicatorTypeShort
};

@class WGCTopBar;

@protocol WGCTopBarDelegate <NSObject>

@optional

- (void)topBar:(WGCTopBar *)topBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface WGCTopBar : UIView

//use to set the topbar titles.
@property (strong, nonatomic) NSArray *titles;
@property (weak  , nonatomic) id<WGCTopBarDelegate>delegate;

@property (strong, nonatomic) UIColor *unSelectedTitleColor;//default is black.
@property (strong, nonatomic) UIColor *selectedTitleColor;//default is cyanColor.

@property (strong, nonatomic) UIFont  *unSelectedTitleFont;//default is 14.
@property (strong, nonatomic) UIFont  *selectedTitleFont;//default is 18.

@property (assign, nonatomic) WGCTopBarIndicatorType indicatorType;
@property (assign, nonatomic) CGFloat indicatorHeight;//default is 4.
@property (assign, nonatomic) CGFloat indicatorWidth;//default is 20.

@property (strong, nonatomic) UIColor *topBarItemBackgroudColor;//default is white.

//move the indicator lineView to the item of index, and make the item selected.
- (void)moveIndicatorToIndex:(NSInteger)index;

//move the indicator view centerX to centerX.
- (void)moveIndicatorToCenterX:(CGFloat)centerX;

@end
