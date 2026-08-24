//
//  HUDBackdropLabel.h
//  TrollSpeed
//
//  Created by Lessica on 2024/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HUDBackdropLabel : UILabel
- (void)setColorInvertEnabled:(BOOL)colorInvertEnabled;
- (void)setBackdropBlurRadius:(CGFloat)blurRadius contrastAmount:(CGFloat)contrastAmount;
@end

NS_ASSUME_NONNULL_END
