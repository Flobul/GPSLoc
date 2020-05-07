#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface CLLocationManager ()
+ (void)setAuthorizationStatus:(BOOL)status forBundleIdentifier:(NSString *)bundleIdentifier;
- (instancetype)initWithEffectiveBundleIdentifier:(NSString *)bundleIdentifier;
@end

static CLLocationManager *locationManager = nil;

@interface GCLocationManagerDelegate : NSObject <CLLocationManagerDelegate>
+ (instancetype)sharedInstance;

@end

@implementation GCLocationManagerDelegate

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static GCLocationManagerDelegate *sharedInstance = nil;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = [location coordinate];
    printf("%f, %f\n", coordinate.latitude, coordinate.longitude);
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Impossible de localiser : %@", error);
}

@end

int main(int argc, char **argv, char **envp)
{
    
    if (@available(iOS 13, *)) {
        [CLLocationManager setAuthorizationStatus:YES forBundleIdentifier:@"com.apple.findmy"];
        locationManager = [[CLLocationManager alloc] initWithEffectiveBundleIdentifier:@"com.apple.findmy"];
    } else {
        [CLLocationManager setAuthorizationStatus:YES forBundleIdentifier:@"com.apple.mobileme.fmip1"];
        locationManager = [[CLLocationManager alloc] initWithEffectiveBundleIdentifier:@"com.apple.mobileme.fmip1"];
    }
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager setDelegate:[GCLocationManagerDelegate sharedInstance]];
    [locationManager startUpdatingLocation];
    CFRunLoopRun();
    return 0;
}
 
