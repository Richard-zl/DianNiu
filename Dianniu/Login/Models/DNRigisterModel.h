//
//  DNRigisterModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/24.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

@interface DNRigisterModel : DNWebServiceBaseModel
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *pwd;
@end
