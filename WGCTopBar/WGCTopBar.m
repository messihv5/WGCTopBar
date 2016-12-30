//
//  WGCTopBar.m
//  CustomViewTopBar
//
//  Created by messihv5 on 24/12/2016.
//  Copyright © 2016 messihv5. All rights reserved.
//

#import "WGCTopBar.h"
#import <YYKit/UIView+YYAdd.h>

@interface WGCTopBar ()

@property (strong, nonatomic) UIView  *indicatorView;
@property (strong, nonatomic) UIButton *selectedButton;

@end

@implementation WGCTopBar

@synthesize unSelectedTitleColor     = _unSelectedTitleColor;
@synthesize selectedTitleColor       = _selectedTitleColor;
@synthesize unSelectedTitleFont      = _unSelectedTitleFont;
@synthesize selectedTitleFont        = _selectedTitleFont;
@synthesize indicatorHeight          = _indicatorHeight;
@synthesize indicatorWidth           = _indicatorWidth;
@synthesize topBarItemBackgroudColor = _topBarItemBackgroudColor;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 10000;
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    if (!titles || !titles.count) {
        return;
    }
    
    _titles = titles;
    
    [self p_setup];
}

#pragma mark - public method

- (void)moveIndicatorToIndex:(NSInteger)index {
    UIView *view = [self viewWithTag:index];
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)view;
        if (button == self.selectedButton) {
            return;
        } else {
            self.selectedButton.selected = NO;
            self.selectedButton = button;
            self.selectedButton.selected = YES;
            
            self.indicatorView.centerX = self.selectedButton.centerX;
        }
    }
}

- (void)moveIndicatorToCenterX:(CGFloat)centerX {
    self.indicatorView.centerX = centerX;
}

#pragma mark - private method

//according to the titles to setup.
- (void)p_setup {
    NSInteger buttonCount = self.titles.count;
    CGFloat   buttonWidth = self.width/buttonCount;
    CGFloat   buttonHeight = self.height-self.indicatorHeight;

    //creat topbar buttons
    for (NSInteger i=0; i<buttonCount; i++) {
        NSString *title = self.titles[i];
        
        NSMutableAttributedString *unselectedAttTitle = [[NSMutableAttributedString alloc] initWithString:title];
        NSMutableAttributedString *selectedAttTitle = [[NSMutableAttributedString alloc] initWithString:title];
        
        [unselectedAttTitle addAttributes:@{NSForegroundColorAttributeName:self.unSelectedTitleColor, NSFontAttributeName:self.unSelectedTitleFont} range:NSMakeRange(0, unselectedAttTitle.length)];
        
        [selectedAttTitle addAttributes:@{NSForegroundColorAttributeName:self.selectedTitleColor, NSFontAttributeName:self.selectedTitleFont} range:NSMakeRange(0, selectedAttTitle.length)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(buttonWidth*i, 0, buttonWidth, buttonHeight);
        button.tag = i;
        
        [button setAttributedTitle:unselectedAttTitle forState:UIControlStateNormal];
        [button setAttributedTitle:selectedAttTitle forState:UIControlStateSelected];
        
        button.backgroundColor = self.topBarItemBackgroudColor;
        
        [button addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        //set the first selected button.
        if (!button.tag) {
            self.selectedButton = button;
            self.selectedButton.selected = YES;
        }
    }
    
    //creat indicatorview
    CGFloat indicatorWidth = 0;
    if (!self.indicatorWidth) {
        if (self.indicatorType == WGCTopBarIndicatorTypeDefault) {
            indicatorWidth = buttonWidth;
        } else {
            indicatorWidth = 20;
        }
        
        self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-self.indicatorHeight, indicatorWidth, self.indicatorHeight)];
    } else {
        self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-self.indicatorHeight, self.indicatorWidth, self.indicatorHeight)];
    }
    
    self.indicatorView.tag = 9999;
    self.indicatorView.backgroundColor = [UIColor redColor];
    self.indicatorView.centerX = self.selectedButton.centerX;
    
    [self addSubview:self.indicatorView];
}

#pragma mark - eventResponse

- (void)onButtonClicked:(UIButton *)sender {
    if (sender == self.selectedButton) {
        return;
    }
    
    //change the state of button
    self.selectedButton.selected = NO;
    self.selectedButton = sender;
    self.selectedButton.selected = YES;
    
    self.indicatorView.centerX = self.selectedButton.centerX;
    
    //send message to delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(topBar:didSelectItemAtIndex:)]) {
        [self.delegate topBar:self didSelectItemAtIndex:sender.tag];
    }
}

#pragma mark - setter&getter

- (UIColor *)unSelectedTitleColor {
    if (!_unSelectedTitleColor) {
        _unSelectedTitleColor = [UIColor blackColor];
    }
    return _unSelectedTitleColor;
}

- (void)setUnSelectedTitleColor:(UIColor *)unSelectedTitleColor {
    _unSelectedTitleColor = unSelectedTitleColor;
    
    if (self.titles && self.titles.count) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                
                NSMutableAttributedString *string = [button attributedTitleForState:UIControlStateNormal].mutableCopy;
                
                [string addAttributes:@{NSForegroundColorAttributeName:_unSelectedTitleColor} range:NSMakeRange(0, string.length)];
                
                [button setAttributedTitle:string forState:UIControlStateNormal];
                
            }
        }
    }
}

- (UIColor *)selectedTitleColor {
    if (!_selectedTitleColor) {
        _selectedTitleColor = [UIColor cyanColor];
    }
    return _selectedTitleColor;
}

- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor {
    _selectedTitleColor = selectedTitleColor;
    
    if (self.titles && self.titles.count) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                
                NSMutableAttributedString *string = [button attributedTitleForState:UIControlStateSelected].mutableCopy;
                
                [string addAttributes:@{NSForegroundColorAttributeName:_selectedTitleColor} range:NSMakeRange(0, string.length)];
                
                [button setAttributedTitle:string forState:UIControlStateSelected];
            }
        }
    }
}

- (UIFont *)unSelectedTitleFont {
    if (!_unSelectedTitleFont) {
        _unSelectedTitleFont = [UIFont systemFontOfSize:14];
    }
    return _unSelectedTitleFont;
}

- (void)setUnSelectedTitleFont:(UIFont *)unSelectedTitleFont {
    _unSelectedTitleFont = unSelectedTitleFont;
    
    if (self.titles && self.titles.count) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                
                NSMutableAttributedString *string = [button attributedTitleForState:UIControlStateNormal].mutableCopy;

                [string addAttributes:@{NSFontAttributeName:_unSelectedTitleFont} range:NSMakeRange(0, string.length)];
                
                [button setAttributedTitle:string forState:UIControlStateNormal];
            }
        }
    }
}

- (UIFont *)selectedTitleFont {
    if (!_selectedTitleFont) {
        _selectedTitleFont = [UIFont systemFontOfSize:18];
    }
    return _selectedTitleFont;
}

- (void)setSelectedTitleFont:(UIFont *)selectedFont {
    _selectedTitleFont = selectedFont;
    
    if (self.titles && self.titles.count) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                
                NSMutableAttributedString *string = [button attributedTitleForState:UIControlStateSelected].mutableCopy;
                
                [string addAttributes:@{NSFontAttributeName:_selectedTitleFont} range:NSMakeRange(0, string.length)];
                
                [button setAttributedTitle:string forState:UIControlStateSelected];
            }
        }
    }
}

- (void)setIndicatorType:(WGCTopBarIndicatorType)indicatorType {
    _indicatorType = indicatorType;
    
    CGFloat indicatorWidth = 0;
    if (_indicatorType == WGCTopBarIndicatorTypeDefault) {
        indicatorWidth = self.width/self.titles.count;
    } else {
        indicatorWidth = 20;
    }
    
    self.indicatorView.size = CGSizeMake(indicatorWidth, self.indicatorView.height);
    self.indicatorView.centerX = self.selectedButton.centerX;
}

- (UIColor *)topBarItemBackgroudColor {
    if (!_topBarItemBackgroudColor) {
        _topBarItemBackgroudColor = [UIColor whiteColor];
    }
    return _topBarItemBackgroudColor;
}

- (void)setTopBarItemBackgroudColor:(UIColor *)topBarItemBackgroudColor {
    _topBarItemBackgroudColor = topBarItemBackgroudColor;
    
    if (self.titles && self.titles.count) {
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                
                button.backgroundColor = _topBarItemBackgroudColor;
            }
        }
    }
}

- (CGFloat)indicatorHeight {
    if (!_indicatorHeight) {
        _indicatorHeight = 4;
    }
    return _indicatorHeight;
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight {
    _indicatorHeight = indicatorHeight;
    
    if (self.titles && self.titles.count) {
        self.indicatorView.size = CGSizeMake(self.indicatorWidth, _indicatorHeight);
        self.indicatorView.centerX = self.selectedButton.centerX;
        self.indicatorView.top = self.height - _indicatorHeight;
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                button.size = CGSizeMake(self.width/self.titles.count, self.height-_indicatorHeight);
            }
        }
    }
}

- (CGFloat)indicatorWidth {
    if (!_indicatorWidth) {
        _indicatorWidth = 20;
    }
    return _indicatorWidth;
}

- (void)setIndicatorWidth:(CGFloat)indicatorWidth {
    _indicatorWidth = indicatorWidth;
    
    if (self.titles && self.titles.count) {
        self.indicatorView.size = CGSizeMake(_indicatorWidth, self.indicatorHeight);
        self.indicatorView.centerX = self.selectedButton.centerX;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
