//
//  BMPuzzleCollectionViewLayout.m
//  PHOTZLE
//
//  Created by Aurimas Bavarskis on 15/01/16.
//  Copyright © 2016 Bavarskis Media. All rights reserved.
//

#import "BMPuzzleCollectionViewLayout.h"
#import "BMPuzzleCollectionViewLayoutAttributes.h"
#import "NSMutableArray+Shuffling.h"

@interface BMPuzzleCollectionViewLayout() <UIDynamicAnimatorDelegate> {
    NSMutableDictionary *_originalIndexCoordinateMapping;
    NSMutableArray *_allCoordinatesArray;
    NSArray *_attributes;
    UIDynamicAnimator *_dynamicAnimator;
}

@end

@implementation BMPuzzleCollectionViewLayout

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _dynamicAnimator = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    _dynamicAnimator.delegate = self;
    [_dynamicAnimator removeAllBehaviors];
    
    _originalIndexCoordinateMapping = [NSMutableDictionary dictionary];
    _allCoordinatesArray = [NSMutableArray array];
}

#pragma mark -
#pragma mark Layout

+ (Class)layoutAttributesClass {
    return [BMPuzzleCollectionViewLayoutAttributes class];
}

- (void)prepareLayout {
    [super prepareLayout];
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (_dynamicAnimator.behaviors.count > 0) {
        return [_dynamicAnimator itemsInRect:rect];
    }
    
    CGFloat contentMinSize = MIN(self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    CGFloat contentMaxSize = MAX(self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    CGFloat offsetX = contentMinSize == self.collectionViewContentSize.width ? 0.0 : (contentMaxSize - contentMinSize) / 2;
    CGFloat offsetY = contentMinSize == self.collectionViewContentSize.width ? (contentMaxSize - contentMinSize) / 2 : 0.0;
    
    NSUInteger cellNum = 0;
    for (int i = 0; i < _numberOfRows; i++) {
        for (int j = 0; j < _numberOfRows; j++) {
            CGRect cellRect = CGRectMake(contentMinSize / _numberOfRows * j + offsetX, contentMinSize / _numberOfRows * i + offsetY, contentMinSize / _numberOfRows, contentMinSize / _numberOfRows);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:cellNum inSection:0];
            BMPuzzleCollectionViewLayoutAttributes *cellAttributes = (BMPuzzleCollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
            cellAttributes.frame = cellRect;
            cellAttributes.tileIndex = cellNum;
            _originalIndexCoordinateMapping[@(cellNum)] = [NSValue valueWithCGPoint:cellAttributes.center];
            _allCoordinatesArray[cellNum] = [NSValue valueWithCGPoint:cellAttributes.center];
            [attributes addObject:cellAttributes];
            
            cellNum++;
        }
    }

    _attributes = attributes;
    return attributes;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    return YES;
}
                                                         
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dynamicAnimator.behaviors.count > 0) {
        return (BMPuzzleCollectionViewLayoutAttributes *)[_dynamicAnimator layoutAttributesForCellAtIndexPath:indexPath];
    }
    BMPuzzleCollectionViewLayoutAttributes *attributes = [BMPuzzleCollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    return attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)shuffleCollectionViewCellsWithCompletion:(void (^)(void))completion {
    [self invalidateLayout];
    if (_dynamicAnimator.behaviors.count == 0) {
        
        [_allCoordinatesArray shuffle];
        [_attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:obj snapToPoint:[_allCoordinatesArray[idx] CGPointValue]];
            snapBehavior.damping = 0.9;
            [_dynamicAnimator addBehavior:snapBehavior];
        }];
    }
}


@end
