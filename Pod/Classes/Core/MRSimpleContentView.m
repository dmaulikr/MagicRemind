//
//  MRSimpleContentView.m
//  Pods
//
//  Created by baidu on 16/4/11.
//
//

#import "MRSimpleContentView.h"
#import "MRLayoutItem.h"
#import "MRItem.h"
#import "MRLayoutTextItem.h"
#import "CustomBadge.h"
@interface MRSimpleContentView ()
@property (nonatomic, strong) CustomBadge* badgeView;
@property (nonatomic, strong) MRItem* item;
@end

@implementation MRSimpleContentView
- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return self;
    }
    _badgeView = [CustomBadge customBadgeWithString:@"0"];
    [self addSubview:_badgeView];
    return self;

}
- (void) layoutMRItem:(MRItem *)item
{
    _item = item;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    MRLayoutItem* layoutItem = _item.layoutItems.lastObject;
    if ([layoutItem isKindOfClass:[MRLayoutTextItem class]]) {
        MRLayoutTextItem* textItem = (MRLayoutTextItem*)layoutItem;
        _badgeView.badgeText = textItem.text;
        _badgeView.frame = CGRectMake(100, 140, 40, 40);
        [_badgeView autoBadgeSizeWithString:textItem.text];
    }

}
@end
