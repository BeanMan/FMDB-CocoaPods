//
//  Person.h
//  cocoaPod&FMDB
//
//  Created by bean on 2018/6/13.
//  Copyright © 2018年 bean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property(nonatomic,assign) int ID;
@property(nonatomic,copy) NSString * name;
@property(nonatomic,copy) NSString * phone;
@property(nonatomic,assign) int score;



@end
