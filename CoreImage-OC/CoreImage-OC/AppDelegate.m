//
//  AppDelegate.m
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:UIScreen.mainScreen.bounds];
    [self.window makeKeyAndVisible];
    
    ViewController *mianVC = [[ViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mianVC];
    nav.navigationBar.translucent = NO;
    self.window.rootViewController = nav;
    
    return YES;
}

@end
