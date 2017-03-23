//
//  TTPickerView.h
//  TeamTiger
//
//  Created by xxcao on 16/8/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTPickerView;

typedef void(^TTPickerViewBlock)(TTPickerView *view, id selObj);

typedef void(^TTTapBlock)(TTPickerView *view);

@interface TTPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIPickerView *picker;

@property(nonatomic,strong)NSMutableArray *dataSources;

@property(nonatomic,copy)TTPickerViewBlock pickerBlock;

@property(nonatomic,copy)TTTapBlock tapBlock;

- (instancetype)initWithDatas:(NSArray *)datas SelectBlock:(TTPickerViewBlock)block TapBlock:(TTTapBlock)tapBlock;

@end
