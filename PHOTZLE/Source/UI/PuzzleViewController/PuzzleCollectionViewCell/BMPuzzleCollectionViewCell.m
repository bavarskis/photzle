//
//  BMPuzzleCollectionViewCell.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMPuzzleCollectionViewCell.h"

@interface BMPuzzleCollectionViewCell ()

@property UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@end

@implementation BMPuzzleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPressCollectionView:)];
    [self addGestureRecognizer:_longPressGestureRecognizer];

}

- (void)setIndex:(NSInteger)index {
    _index = index;
    _indexLabel.text = [@(self.index) stringValue];
    [self layoutIfNeeded];
}

#pragma mark - User Actions

- (void)didLongPressCollectionView:(UILongPressGestureRecognizer *)sender {
    if ([_delegate respondsToSelector:@selector(didLongPressCollectionViewCell:sender:)]) {
        [_delegate didLongPressCollectionViewCell:self sender:sender];
    }
}

@end
