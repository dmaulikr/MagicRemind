//
//  MRStorage.h
//  MagicRemind
//
//  Created by baidu on 15/11/5.
//  Copyright © 2015年 dzpqzb. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MRItem;
@interface MRStorage : NSObject
+ (MRStorage*) shareStorage;
- (MRItem*) itemWithIdentifier:(NSString*)identifier;
@end
