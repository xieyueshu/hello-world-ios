//
//  FKSayHi.h
//  HelloWorld
//
//  Created by yueshu on 2019/6/18.
//  Copyright © 2019年 yueshu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FKSayHi : NSObject
    
    @property (nonatomic,copy) NSDate * curDate;
    - (id) initWithDate:(NSDate*) date;
    - (NSString*) sayHi:(NSString*)name;

@end

NS_ASSUME_NONNULL_END
