
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static UIWindow *timerWindow;
static UIView *timerBar;
static UILabel *timerLabel;
static NSTimer *clockTimer;

static BOOL timerRunning = NO;
static BOOL timerPaused = NO;
static NSTimeInterval elapsedTime = 0;
static NSDate *startDate;

static void UpdateTimer(void) {
    if (timerRunning && !timerPaused && startDate) {
        elapsedTime = -[startDate timeIntervalSinceNow];
    }

    NSInteger minutes = (NSInteger)elapsedTime / 60;
    NSInteger seconds = (NSInteger)elapsedTime % 60;
    NSInteger centiseconds = (NSInteger)(elapsedTime * 100) % 100;

    dispatch_async(dispatch_get_main_queue(), ^{
        timerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld.%02ld",
                           (long)minutes, (long)seconds,
                           (long)centiseconds];

        if (timerRunning && !timerPaused) {
            timerBar.backgroundColor = [UIColor colorWithRed:0.12 green:0.78 blue:0.35 alpha:1.0];
        } else if (timerPaused) {
            timerBar.backgroundColor = [UIColor colorWithRed:0.15 green:0.48 blue:1.0 alpha:1.0];
        } else {
            timerBar.backgroundColor = UIColor.whiteColor;
        }
    });
}

__attribute__((constructor))
static void MyLibInit(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"OClock : bibliothèque chargée.");
    });
}
