//
//  BMPuzzleCollectionViewLayout.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMPuzzleCollectionViewLayout.h"

@interface BMPuzzleCollectionViewLayout()

@end

@implementation BMPuzzleCollectionViewLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    
    NSUInteger cellNum = 0;
    for (int i = 0; i < _numberVerticalCells; i++) {
        for (int j = 0; j < _numberHorizontalCells; j++) {
            CGRect cellRect = CGRectMake(j * (self.collectionView.frame.size.width / _numberHorizontalCells), i * (self.collectionView.frame.size.height / _numberVerticalCells), self.collectionView.frame.size.width / _numberHorizontalCells, self.collectionView.frame.size.height / _numberVerticalCells);
            
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


@end
