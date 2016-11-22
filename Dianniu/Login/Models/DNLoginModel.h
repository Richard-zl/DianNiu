//
//  DNLoginModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNPhone.h"

@interface DNLoginModel : DNWebServiceBaseModel
@property (nonatomic, copy) NSString *mobileNum;
@property (nonatomic, copy) NSString *pwd;



@end
