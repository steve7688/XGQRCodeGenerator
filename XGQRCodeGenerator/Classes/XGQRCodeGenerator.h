//
//  XGQRCodeGenerator.h
//  XGQRCodeGenerator
//
//  Created by Steve on 2022/3/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGQRCodeGenerator : NSObject

/// 不带logo
+(UIImage *)createQRCodeWithContent:(NSString *)content withSize:(CGFloat)size;

/// 带logo
+(UIImage *)createQRCodeWithContent:(NSString *)content withSize:(CGFloat)size withLogo:(UIImage *)logo;

@end

NS_ASSUME_NONNULL_END
