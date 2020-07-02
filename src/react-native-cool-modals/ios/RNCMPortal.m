//
//  Portal.m
//  Rainbow
//
//  Created by Michał Osadnik on 01/07/2020.
//  Copyright © 2020 Rainbow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>
#import <React/RCTView.h>
#import "AppDelegate.h"


@interface WindowPortalManager : RCTViewManager

@end



@interface PortalView : RCTView

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic) BOOL blockTouches;

@end

@interface CustomUIWindow : UIWindow

@property (nonatomic, weak) PortalView* portalView;
@property (nonatomic) BOOL profileForNotifications;

@end


@implementation WindowPortalManager

RCT_EXPORT_MODULE()
RCT_EXPORT_VIEW_PROPERTY(blockTouches, BOOL)


- (UIView *)view
{
  return [[PortalView alloc] init];
}

@end

@implementation CustomUIWindow
- (instancetype)init {
  if (self = [super init]) {
    self.profileForNotifications = NO;
  }
  return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  if (self.portalView.blockTouches) {
    return [super hitTest:point withEvent:event];
  }
  return nil;
}

@end

@implementation PortalView
- (instancetype)init {
  if (self = [super init]) {
    self.window = [[CustomUIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UIViewController alloc] init];
    [self.window setWindowLevel:((AppDelegate* )UIApplication.sharedApplication.delegate).window.windowLevel + 1];
    [self.window makeKeyAndVisible];
    self.window.rootViewController.view = [[UIView alloc] init];
    ((CustomUIWindow *) self.window).portalView = self;
  }
  return self;
}

-(void)addSubview:(UIView *)view {
  [self.window.rootViewController.view addSubview:view];
}

-(void)removeFromSuperview {
  [self.window.rootViewController.view removeReactSubview:self.reactSubviews[0]];
  [super removeFromSuperview];
  
}

-(void)removeReactSubview:(UIView *)subview {
  [self.window.rootViewController.view removeReactSubview:subview];
  [super removeReactSubview:subview];
}
@end