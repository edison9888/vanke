//
//  ImageCacher.m
//  AAPinChe
//
//  Created by Reese on 13-4-3.
//  Copyright (c) 2013年 Himalayas Technology&Science Company CO.,LTD-重庆喜玛拉雅科技有限公司. All rights reserved.
//  单例类

#import "ImageCacher.h"
#import "BMKPinAnnotationView.h"
#import "UIImage+PImageCategory.h"

@implementation ImageCacher

static ImageCacher *defaultCacher=nil;
-(id)init
{
    if (defaultCacher) {
        return defaultCacher;
    }else
    {
        self =[super init];
        [self setFlip];
        return self;
    }
}

+(ImageCacher*)defaultCacher
{
    if (!defaultCacher) {

        defaultCacher=[[super allocWithZone:nil]init];
    }
    return defaultCacher;
    
}

+ (id)allocWithZone:(NSZone *)zone
{
    
    return [self defaultCacher];
}


-(void) setFade
{
    _type=kCATransitionFade;
    
}

-(void) setCube
{
   _type=@"cube";
}

-(void) setFlip
{
   _type= @"oglFlip";
}

//- (NSUInteger)retainCount
//{
//    return NSUIntegerMax;
//}

//合并图片
-(UIImage *)mergerImage:(UIImage *)firstImage secodImage:(UIImage *)secondImage{
    
    CGSize imageSize = CGSizeMake(79, 73);
    UIGraphicsBeginImageContext(imageSize);
    
    [firstImage drawInRect:CGRectMake(0, 0, firstImage.size.width, firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(4, 8, secondImage.size.width, secondImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

-(void)cacheImage:(NSDictionary*)aDic
{
    NSURL *aURL=[aDic objectForKey:@"url"];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSData *data=[NSData dataWithContentsOfURL:aURL] ;
    UIImage *image=[UIImage imageWithData:data];
    NSLog(@"image.size.width: %f, image.size.height: %f", image.size.width, image.size.height);
    
    UIImage *avatarImage = [UIImage scaleImage:image scaleToSize:CGSizeMake(38, 38)];
    NSLog(@"avatarImage.size.width: %f, avatarImage.size.height: %f", avatarImage.size.width, avatarImage.size.height);
    
//    UIImage *defaultImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"lbs_user_tip" ofType:@"png"]];
//    NSLog(@"defaultImage.size.width: %f, defaultImage.size.height: %f", defaultImage.size.width, defaultImage.size.height);
//    
//    image = [self mergerImage:defaultImage secodImage:avatarImage];
//    NSLog(@"image.size.width: %f, image.size.height: %f", image.size.width, image.size.height);
    
    if (image==nil) {
        return;
    }
    CGSize origImageSize= [image size];
    
    CGRect newRect;
    newRect.origin= CGPointZero;
    //拉伸到多大
//    newRect.size.width=80;
//    newRect.size.height=80;
    newRect.size.width = [[aDic objectForKey:@"imageWidth"] floatValue];
    newRect.size.height = [[aDic objectForKey:@"imageHeight"] floatValue];
    
    //缩放倍数
    float ratio = MIN(newRect.size.width/origImageSize.width, newRect.size.height/origImageSize.height);

    UIGraphicsBeginImageContext(newRect.size);

    CGRect projectRect;
    projectRect.size.width =ratio * origImageSize.width;
    projectRect.size.height=ratio * origImageSize.height;
    projectRect.origin.x= (newRect.size.width -projectRect.size.width)/2.0;
    projectRect.origin.y= (newRect.size.height-projectRect.size.height)/2.0;

    [image drawInRect:projectRect];
    

    UIImage *small = UIGraphicsGetImageFromCurrentImageContext();
   
    //压缩比例
    NSData *smallData=UIImageJPEGRepresentation(small, 0.5);
    
    if (smallData) {
        [fileManager createFileAtPath:pathForURL(aURL) contents:smallData attributes:nil];
    }
    
    UIView *imageView=[aDic objectForKey:@"imageView"];
    UIView *btnView = [aDic objectForKey:@"btnView"];
    UIView *bmkPin = [aDic objectForKey:@"BMKPin"];
    
    //判断view是否还存在 如果tablecell已经移出屏幕会被回收 那么什么都不用做，下次滚到该cell 缓存已存在 不需要执行此方法
    if (imageView!=nil) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transtion setType:_type];
        [transtion setSubtype:kCATransitionFromRight];
        
        [imageView.layer addAnimation:transtion forKey:@"transtionKey"];
        
        [(UIImageView*)imageView setImage:small];
    }else if(btnView!=nil){
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transtion setType:_type];
        [transtion setSubtype:kCATransitionFromRight];
        
        [btnView.layer addAnimation:transtion forKey:@"transtionKey"];
        
        [(UIButton*)btnView setImage:small forState:UIControlStateNormal];
    }else if(bmkPin)
    {
        [(BMKPinAnnotationView*)bmkPin setImage:small];
    }
    UIGraphicsEndImageContext();
}


@end
