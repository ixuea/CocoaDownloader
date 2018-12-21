//
//  ListController.h
//  iOSDemo
//
//  Created by smile on 2018/12/20.
//  Copyright © 2018 ixuea(http://a.ixuea.com/y). All rights reserved.
//

#import "BaseTitleController.h"
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListController : BaseTitleController<UITableViewDelegate,UITableViewDataSource>
@property NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
