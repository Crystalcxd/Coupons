//
//  MLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define TOP_VIEW  [[UIApplication sharedApplication]keyWindow].rootViewController.view

#import <QuartzCore/QuartzCore.h>

//#import "WMUserDefault.h"

#import "MLNavigationController.h"

#import "CartoonViewController.h"
#import "AboutViewController.h"

@interface MLNavigationController ()
{
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation MLNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // draw a shadow for navigation view to differ the layers obviously.
    // using this way to draw shadow will lead to the low performace
    // the best alternative way is making a shadow image.
    //
    //self.view.layer.shadowColor = [[UIColor blackColor]CGColor];
    //self.view.layer.shadowOffset = CGSizeMake(5, 5);
    //self.view.layer.shadowRadius = 5;
    //self.view.layer.shadowOpacity = 1;
    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, TOP_VIEW.frame.size.height);
    [TOP_VIEW addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:(BOOL)animated];
    
    if (self.screenShotsList.count == 0) {
        
        UIImage *capturedImage = [self capture];
        
        if (capturedImage) {
            [self.screenShotsList addObject:capturedImage];
        }
    }
}

-(NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSInteger count = self.viewControllers.count;
    
    NSInteger count1 = self.screenShotsList.count;
    int index = 0;
    for (int i = 0; i < count; i++) {
        UIViewController *view = [self.viewControllers objectAtIndex:i];
        if (view == viewController) {
            index = i;
            break;
        }
    }
    
    [self.screenShotsList removeObjectsInRange:NSMakeRange(index+1, count1-index-1)];
    
    return [super popToViewController:viewController animated:animated];
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIImage *capturedImage = [self capture];
    
    if (capturedImage) {
        [self.screenShotsList addObject:capturedImage];
    }

    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    
    return [super popViewControllerAnimated:animated];
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeObjectsInRange:NSMakeRange(1, self.screenShotsList.count-1)];
    return [super popToRootViewControllerAnimated:animated];
}
#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(TOP_VIEW.bounds.size, TOP_VIEW.opaque, 0.0);
    [TOP_VIEW.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    
    x = x>320?320:x;
    x = x<0?0:x;
    
    CGRect frame = TOP_VIEW.frame;
    frame.origin.x = x;
    TOP_VIEW.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);

    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    blackMask.alpha = alpha;
    
}

#pragma mark - Gesture Recognizer -
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    UIViewController *viewController = [self.viewControllers lastObject];

    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        NSLog(@"%@",self.viewControllers);
        
        UIViewController *topViewController = [self.viewControllers lastObject];
        if (topViewController != nil && [topViewController respondsToSelector:@selector(beginDissmiss)]) {
            [topViewController performSelector:@selector(beginDissmiss)];
        }
        if (!self.backgroundView)
        {
            CGRect frame = TOP_VIEW.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [TOP_VIEW.superview insertSubview:self.backgroundView belowSubview:TOP_VIEW];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        
        if ([viewController isKindOfClass:[CartoonViewController class]]||[viewController isKindOfClass:[AboutViewController class]]) {
            lastScreenShot = [self.screenShotsList objectAtIndex:1];
        }

        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                if ([viewController isKindOfClass:[CartoonViewController class]]||[viewController isKindOfClass:[AboutViewController class]]) {
                    [self popToViewController:[self.viewControllers objectAtIndex:0] animated:NO];
                }
                else
                    [self popViewControllerAnimated:NO];
                CGRect frame = TOP_VIEW.frame;
                frame.origin.x = 0;
                TOP_VIEW.frame = frame;
                
                _isMoving = NO;
                self.backgroundView.hidden = YES;

            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        UIViewController *topViewController = [self.viewControllers lastObject];
        if (topViewController != nil && [topViewController respondsToSelector:@selector(beginFirst)]) {
            [topViewController performSelector:@selector(beginFirst)];
        }

        return;
    }
    
    // it keeps move with touch
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}


- (UIViewController *)currentViewController
{
    UIViewController *result = nil;
    if ([self.viewControllers count]>0) {
        result = [self.viewControllers lastObject];
    }
    return result;
}

- (BOOL)shouldAutorotate
{
    UIViewController * vc = [self currentViewController];
    if (vc) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UIViewController *temp = [(UINavigationController *)vc topViewController];
            if (temp) {
                return temp.shouldAutorotate;;
            }
            
            return NO;
        }
        
        
        return vc.shouldAutorotate;
    }
    
    return NO;
}


- (NSUInteger)supportedInterfaceOrientations
{
    UIViewController * vc = [self currentViewController];
    if (vc) {
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            UIViewController *temp = [(UINavigationController *)vc topViewController];
            if (temp) {
                return temp.supportedInterfaceOrientations;;
            }
            
            return UIInterfaceOrientationMaskPortrait;
        }
        
        
        return vc.supportedInterfaceOrientations;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    UIViewController * vc = [self currentViewController];
    if (vc) {
        
        return [vc shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)prefersStatusBarHidden
{
    UIViewController * vc = [self currentViewController];
    if (vc) {
       return [vc prefersStatusBarHidden];
    }
    return NO;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return [self.childViewControllers objectAtIndex:0];
}

//- (BOOL)wantsFullScreenLayout
//{
//    UIViewController * vc = [self currentViewController];
//    if (vc) {
//        
//        return [vc wantsFullScreenLayout];
//    }
//    return NO;
//}

@end
