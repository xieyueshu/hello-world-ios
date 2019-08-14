//
//  FKSayHi.m
//  HelloWorld
//
//  Created by yueshu on 2019/6/18.
//  Copyright © 2019年 yueshu. All rights reserved.
//

#import "FKSayHi.h"

@implementation FKSayHi

    - (id) initWithDate:(NSDate *)date
    {
        self = [super init];
        if(self){
            self->_curDate = date;
        }
        return self;
    }
    - (NSString*) sayHi:(NSString *)name
    {
        return [NSString stringWithFormat:@"%@,您好，现在时间是%@", name, self.curDate];
    }
    
@end
