//
//  XGQRCodeGenerator.m
//  XGQRCodeGenerator
//
//  Created by Steve on 2022/3/7.
//

#import "XGQRCodeGenerator.h"

@implementation XGQRCodeGenerator

#pragma mark - 生成二维码(不带logo)

+(UIImage *)createQRCodeWithContent:(NSString *)content withSize:(CGFloat)size{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSString *string = content;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *image = [filter outputImage];
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:size];
    
    return qrcode;
}

#pragma mark - 生成二维码(带logo)

+(UIImage *)createQRCodeWithContent:(NSString *)content withSize:(CGFloat)size withLogo:(UIImage *)logo{
    
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSString *string = content;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *image = [filter outputImage];
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:image withSize:size];
    qrcode = [self drawImage:logo inImage:qrcode];
    
    return qrcode;
}


#pragma mark - 将二维码转成高清的格式

+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size{
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - 添加logo

+(UIImage *)drawImage:(UIImage *)newImage inImage:(UIImage *)sourceImage {
    CGSize imageSize;
    imageSize = [sourceImage size];
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    [sourceImage drawAtPoint:CGPointMake(0, 0)];
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathStroke);
    CGRect rect = CGRectMake(imageSize.width / 2 - 25, imageSize.height / 2 - 25, 50, 50);
    CGContextClip(context);
    [newImage drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


@end
