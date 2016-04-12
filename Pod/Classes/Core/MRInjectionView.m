//
//  MRInjectionView.m
//  MagicRemind
//
//  Created by baidu on 15/11/5.
//  Copyright © 2015年 dzpqzb. All rights reserved.
//

#import "MRInjectionView.h"
#import <objc/runtime.h>
#import "MRContentView.h"
#import "MRItem.h"
#import "MRSimpleContentView.h"

static void* kMRUIBridge = &kMRUIBridge;
static void* kMRUIContentView = &kMRUIContentView;
static void* kMRXbadgeMargin  = &kMRXbadgeMargin;
static void* kMRYBadgeMargin = &kMRYBadgeMargin;
static void* kMRTapGesture = &kMRTapGesture;
@interface MRInjectionView ()
@property (nonatomic, strong) UITapGestureRecognizer* tapGesture;
@end

@implementation MRInjectionView

- (void) setTapGesture:(UITapGestureRecognizer *)tapGesture
{
    objc_setAssociatedObject(self, kMRTapGesture, tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UITapGestureRecognizer*) tapGesture
{
    return objc_getAssociatedObject(self, kMRTapGesture);
}

- (void) setMagicRemindBridge:(MRUIBridge *)magicRemindBridge
{
    objc_setAssociatedObject(self, kMRUIBridge, magicRemindBridge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MRUIBridge*) magicRemindBridge
{
    return objc_getAssociatedObject(self, kMRUIBridge);
}

- (int) MR_contentViewTag
{
    NSNumber* tag = objc_getAssociatedObject(self, kMRUIContentView);
    if (!tag) {
        return 83743;
    }
    return [tag intValue];
}

- (void) setMR_contentViewTag:(int)MR_contentViewTag
{
    objc_setAssociatedObject(self, kMRUIContentView, @(MR_contentViewTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat) xBadgeMargin
{
    return [objc_getAssociatedObject(self, kMRXbadgeMargin) floatValue];
}

- (void) setXBadgeMargin:(CGFloat)xBadgeMargin
{
    objc_setAssociatedObject(self, kMRXbadgeMargin, @(xBadgeMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat) yBadgeMargin
{
    return [objc_getAssociatedObject(self, kMRYBadgeMargin) floatValue];
}

- (void) setYBadgeMargin:(CGFloat)xBadgeMargin
{
    objc_setAssociatedObject(self, kMRYBadgeMargin, @(xBadgeMargin), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (MRContentView*) MR_contentView:(Class)cla
{
    
    MRContentView* contentView;
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[MRContentView class]]) {
            if ([view isKindOfClass:cla]) {
                contentView = view;
            } else {
                [view removeFromSuperview];
            }
        }
    }
    if (!contentView) {
        contentView = [cla new];
    }
    [self addSubview:contentView];
    [self bringSubviewToFront:contentView];
    return contentView;
}

- (void) __handleMagicRemindTap:(UITapGestureRecognizer*)tap
{
    if (tap.state == UIGestureRecognizerStateRecognized) {
        MRUIBridge* bridge= self.magicRemindBridge;
        if (bridge) {
            [bridge hidden];
        }
    }

}

- (void) enableTapClearRemind
{
    if (!self.tapGesture) {
        UITapGestureRecognizer* tapGestur = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleMagicRemindTap:)];
        tapGestur.numberOfTapsRequired = 1;
        tapGestur.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tapGestur];
        self.userInteractionEnabled = YES;
        self.tapGesture = tapGestur;
    }
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    MRUIBridge* bridge = self.magicRemindBridge;
    if (!bridge) {
        return;
    }
    MRItem* item = [bridge magicRemindItem];
    if (!item) {
        return;
    }
    
    if (!item.show ||  item.layoutItems.count == 0) {
        for (UIView* view  in self.subviews) {
            if ([view isKindOfClass:[MRContentView class]]) {
                [view removeFromSuperview];
            }
        }
    } else {
        if (item.layoutItems.count == 1) {
            MRContentView* contentView = [self MR_contentView:[MRSimpleContentView class]];
            CGRect rect = self.bounds;
            rect.origin.x = self.xBadgeMargin * self.bounds.size.width;
            rect.origin.y = self.yBadgeMargin * self.bounds.size.height;
            contentView.frame = rect;
            [contentView layoutMRItem:item];
        }
    }
}

@end
