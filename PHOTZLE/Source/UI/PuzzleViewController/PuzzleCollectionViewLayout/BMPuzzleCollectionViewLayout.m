//
//  BMPuzzleCollectionViewLayout.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMPuzzleCollectionViewLayout.h"

@interface BMPuzzleCollectionViewLayout() {
}

@end

@implementation BMPuzzleCollectionViewLayout

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
    for (int i = 0; i < _numberOfCells; i++) {
        for (int j = 0; j < _numberOfCells; j++) {
            CGRect cellRect = CGRectMake(contentMinSize / _numberOfCells * j + offsetX, contentMinSize / _numberOfCells * i + offsetY, contentMinSize / _numberOfCells, contentMinSize / _numberOfCells);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellNum inSection:0];
            UICollectionViewLayoutAttributes *cellAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            cellAttributes.frame = cellRect;
            [attributes addObject:cellAttributes];
            
            cellNum++;
        }
    }
    
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


@end
