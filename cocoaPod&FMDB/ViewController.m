//
//  ViewController.m
//  cocoaPod&FMDB
//
//  Created by bean on 2018/6/13.
//  Copyright © 2018年 bean. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
#import "Person.h"

@interface ViewController (){
    FMDatabase *db;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSArray * titleArr = @[@"创建db",@"增",@"删",@"改",@"查",@"删除db"];
    for (int i = 0; i<titleArr.count; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100, 100+i*60, 200, 50);
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor redColor];
        btn.tag = i+1;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }

}


- (void)click:(UIButton*)btn {

    switch (btn.tag) {
        case 1://创建db
        {
            //1.创建database路径
            NSString *docuPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *dbPath = [docuPath stringByAppendingPathComponent:@"test.db"];
            NSLog(@"!!!dbPath = %@",dbPath);
            //2.创建对应路径下数据库
            db = [FMDatabase databaseWithPath:dbPath];
            //3.在数据库中进行增删改查操作时，需要判断数据库是否open，如果open失败，可能是权限或者资源不足，数据库操作完成通常使用close关闭数据库
            [db open];
            if (![db open]) {
                NSLog(@"db open fail");
                return;
            }
            //4.数据库中创建表（可创建多张）
            NSString *sql = @"create table if not exists t_student ('ID' INTEGER PRIMARY KEY AUTOINCREMENT,'name' TEXT NOT NULL, 'phone' TEXT NOT NULL,'score' INTEGER NOT NULL)";
            //5.执行更新操作 此处database直接操作，不考虑多线程问题，多线程问题，用FMDatabaseQueue 每次数据库操作之后都会返回bool数值，YES，表示success，NO，表示fail,可以通过 @see lastError @see lastErrorCode @see lastErrorMessage
            BOOL result = [db executeUpdate:sql];
            if (result) {
                NSLog(@"create table success");
            }
            [db close];
        }
            break;
        case 2://增
        {
            if ([db open]) {
                BOOL result = [db executeUpdate:@"insert into t_student (ID,name, phone, score) values (?,?,?,?)",[NSNumber numberWithInteger:1],@"xiaoming",@"13166668888",[NSNumber numberWithInteger:19]];
                if (result) {
                    NSLog(@"插入成功");
                }
                [db close];
            }
        }
            break;
        case 3://删
        {
            if ([db open]) {
                BOOL result = [db executeUpdate:@"delete from t_student where name = ?",@"xiaoming"];
                if (result) {
                    NSLog(@"删除成功");
                }
                [db close];
            }
        }
            break;
        case 4://改
        {
            if ([db open]) {
                BOOL result = [db executeUpdate:@"update t_student set phone = ? where name = ?",@"110",@"xiaoming"];
                if (result) {
                    NSLog(@"修改成功");
                }
                [db close];
            }
        }
            break;
        case 5://查
        {
            if ([db open]) {
                //查询多条数据
                FMResultSet * res = [db executeQuery:@"select name, score,phone from t_student"];
                while ([res next]) {
                    Person * person = [[Person alloc]init];
                    person.name = [res stringForColumn:@"name"];
                    person.phone = [res stringForColumn:@"phone"];
                    person.score = [res intForColumn:@"score"];
                    NSLog(@"姓名：%@----得分：%d+++++手机：%@",person.name,person.score,person.phone);
                }
                [db close];
            }
            //查询一条数据
//            NSLog(@"年龄为25的人：%@",[_myDb stringForQuery:@"select name from personTable where age = ?",@25]);
            
        }
            break;
        case 6://删除db
        {
            
        }
            
        default:
            break;
    }
    

}


@end
