//
//  HomeDetailCell.m
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCell.h"
#import "HomeDetailCellModel.h"
#import "JJPhotoManeger.h"

@interface HomeDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLB;
@property (weak, nonatomic) IBOutlet UILabel *secondeNameLB;
@property (weak, nonatomic) IBOutlet UILabel *desLB;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;

@end

@implementation HomeDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleClickImageAction:(UIButton *)sender {
    UIImageView *image = nil;
    switch (sender.tag) {
        case 300:
            image = self.image1;
            break;
        case 301:
            image = self.image2;
            break;
        default:
            break;
    }
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    [mg showNetworkPhotoViewer:@[self.image1, self.image2] urlStrArr:nil selecView:image];
    
}

- (void)configureCellWithModel:(HomeDetailCellModel *)model {
    self.timeLB.text = model.time;
    self.firstNameLB.text = model.firstName;
    self.secondeNameLB.text = model.secondName;
    self.desLB.text = model.des;
    self.image1.image = kImage(model.firstImage);
    self.image2.image = kImage(model.secondImage);
    
}

@end
