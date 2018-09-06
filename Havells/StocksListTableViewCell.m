//
//  StocksListTableViewCell.m
//  Kotak Wealth Watch App
//
//  Created by Rajeev Ranjan on 05/09/17.
//  Copyright © 2017 Shephertz Technologies. All rights reserved.
//

#import "StocksListTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation StocksListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.nameStr.textColor = [UIColor blackColor];
    
    self.buyButton.backgroundColor = UIColorFromRGB(0x0e61fb);
    [self.buyButton setTintColor:[UIColor whiteColor]];
    [self.buyButton setTitle:@"BUY NOW" forState:UIControlStateNormal];
    self.buyButton.layer.masksToBounds = true;
    self.buyButton.layer.cornerRadius = 5.0;
    
    self.productImage.clipsToBounds = true;
    self.productImage.layer.masksToBounds = true;
    self.productImage.layer.cornerRadius = 5.0;
    self.productImage.layer.borderColor = UIColorFromRGB(0xe31e24).CGColor;
    self.productImage.layer.borderWidth = 1.0f;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
