//
//  DNQ_ATableViewC.h
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNHomeListRequestModel.h"
#import "DNDianniuQ_AViewModel.h"
#import <MJRefresh.h>

@protocol DNHomeRequestDelegate <NSObject>

- (void)refreshRequestWithPage:(NSInteger)page counts:(NSInteger)count type:(DNHomeListType)type finish:(void(^)())finishBlock;

@end

/*问答tableview父类
  两个问答试图只有cell的逻辑不同
  所以子类只需要实现cellForRowAtIndexPath函数单独返回自己应该显示的cell
 */
@interface DNQ_ATableViewC : UITableViewController
@property (nonatomic, strong)NSMutableDictionary *dianniuQ_ADataSource;
@property (nonatomic, assign) DNHomeListType type;
@property (nonatomic, weak) id<DNHomeRequestDelegate> requestdelegate;

- (void)tableViewNeedReload:(NSMutableDictionary <NSString *,DNDianniuQ_AViewModel *> *)dataDict isRefresh:(BOOL)isRefresh;
@end
