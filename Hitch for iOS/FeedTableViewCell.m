//
//  FeedTableViewCell.m
//  Hitch for iOS
//
//  Created by Robert Crosby on 11/18/16.
//  Copyright © 2016 Robert Crosby. All rights reserved.
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

- (void)awakeFromNib {
    [References cardshadow:_card];
    [References cornerRadius:_card radius:5.0f];
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
