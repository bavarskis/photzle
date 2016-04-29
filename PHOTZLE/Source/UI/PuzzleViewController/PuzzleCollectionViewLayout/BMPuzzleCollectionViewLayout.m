//
//  BMPuzzleCollectionViewLayout.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMPuzzleCollectionViewLayout.h"

@interface BMPuzzleCollectionViewLayout() <UIDynamicAnimatorDelegate> {
    
}

@property (nonnull, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonnull, strong) NSArray *attributes;

@end

@implementation BMPuzzleCollectionViewLayout

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.dynamicAnimator.delegate = self;
}

- (void)prepareLayout {
    [super prepareLayout];
    

}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    
    CGFloat contentMinSize = MIN(self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    CGFloat contentMaxSize = MAX(self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    CGFloat offsetX = contentMinSize == self.collectionViewContentSize.width ? 0.0 : (contentMaxSize - contentMinSize) / 2;
    CGFloat offsetY = contentMinSize == self.collectionViewContentSize.width ? (contentMaxSize - contentMinSize) / 2 : 0.0;
    
    NSUInteger cellNum = 0;
    for (int i = 0; i < _numberOfRows; i++) {
        for (int j = 0; j < _numberOfRows; j++) {
            CGRect cellRect = CGRectMake(contentMinSize / _numberOfRows * j + offsetX, contentMinSize / _numberOfRows * i + offsetY, contentMinSize / _numberOfRows, contentMinSize / _numberOfRows);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellNum inSection:0];
            UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            cellAttributes.frame = cellRect;
            [attributes addObject:cellAttributes];
            
            cellNum++;
        }
    }

    self.attributes = attributes;
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return self.collectionView.bounds.size.width != newBound.size.width;
}
                                                         
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)shuffleCollectionViewCellsWithCompletion:(void (^)(void))completion {

}


@end
