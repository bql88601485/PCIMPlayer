//
//  NSMutableArray+Shuffling.m
//  PCIMPlayer
//
//  Created by bai on 15/12/14.
//  Copyright © 2015年 PCIMPlayer. All rights reserved.
//

#import "NSMutableArray+Shuffling.h"

@implementation NSMutableArray (Shuffling)

- (void)shuffle
{
    NSInteger count = [self count];
    for (int i = 0; i < count; ++i) {
        int n = (arc4random() % (count - i)) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
