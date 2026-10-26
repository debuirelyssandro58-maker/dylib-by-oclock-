
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static UIWindow *timerWindow;
static UIView *timerBar;
static UILabel *timerLabel;
static UIButton *startButton;
static UIButton *pauseButton;
static UIButton *resetButton;
static NSTimer *clockTimer;

static BOOL timerRunning = NO;
static BOOL timerPaused = NO;
static NSTimeInterval elapsedTime = 0;
static NSTimeInterval pauseTime = 0;
static NSDate *startDate;

static UIColor *runningColor;
static UIColor *pausedColor;
static UIColor *stoppedColor;

static NSString *FormatTime(NSTimeInterval time) {
    NSInteger centiseconds = (NSInteger)(time * 100) % 100;
    NSInteger seconds = (NSInteger)time % 60;
    NSInteger minutes = (NSInteger)time / 60;

    return [NSString stringWithFormat:@"%02ld:%02ld.%02ld",
            (long)minutes, (long)seconds, (long)centiseconds];
}

static void UpdateTimer(void) {
    if (!timerLabel || !timerBar) return;

    if (timerRunning && !timerPaused && startDate) {
        elapsedTime = pauseTime +
            [[NSDate date] timeIntervalSinceDate:startDate];
    }

    timerLabel.text = FormatTime(elapsedTime);

    if (timerRunning && !timerPaused) {
        timerBar.backgroundColor = runningColor;
    } else if (timerPaused) {
        timerBar.backgroundColor = pausedColor;
    } else {
        timerBar.backgroundColor = stoppedColor;
    }
}

static void StartTimer(void) {
    if (timerRunning && !timerPaused) return;

    if (timerPaused) {
        startDate = [NSDate date];
        timerPaused = NO;
    } else {
        elapsedTime = 0;
        pauseTime = 0;
        startDate = [NSDate date];
        timerRunning = YES;
    }

    UpdateTimer();
}

static void PauseTimer(void) {
    if (!timerRunning || timerPaused) return;

    elapsedTime = pauseTime +
        [[NSDate date] timeIntervalSinceDate:startDate];
    pauseTime = elapsedTime;
    timerPaused = YES;

    UpdateTimer();
}

static void ResetTimer(void) {
    timerRunning = NO;
    timerPaused = NO;
    elapsedTime = 0;
    pauseTime = 0;
    startDate = nil;

    UpdateTimer();
}

static UIButton *MakeButton(NSString *title,
                             UIColor *background,
                             CGRect frame,
                             id target,
                             SEL action) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColor.whiteColor
                 forState:UIControlStateNormal];
    button.backgroundColor = background;
    button.layer.cornerRadius = 8;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button addTarget:target
               action:action
     forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@interface OClockController : UIViewController
@end

@implementation OClockController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.clearColor;

    runningColor = [UIColor colorWithRed:0.12
                                   green:0.78
                                    blue:0.35
                                   alpha:1.0];

    pausedColor = [UIColor colorWithRed:0.15
                                 green:0.48
                                  blue:1.0
                                 alpha:1.0];

    stoppedColor = UIColor.whiteColor;

    timerBar = [[UIView alloc] initWithFrame:
                CGRectMake(12, 12, 336, 116)];
    timerBar.backgroundColor = stoppedColor;
    timerBar.layer.cornerRadius = 12;
    timerBar.layer.borderWidth = 1;
    timerBar.layer.borderColor = UIColor.darkGrayColor.CGColor;
    timerBar.clipsToBounds = YES;
    [self.view addSubview:timerBar];

    UILabel *title = [[UILabel alloc] initWithFrame:
                      CGRectMake(12, 5, 312, 22)];
    title.text = @"O'CLOCK";
    title.textColor = UIColor.blackColor;
    title.font = [UIFont boldSystemFontOfSize:14];
    title.textAlignment = NSTextAlignmentCenter;
    [timerBar addSubview:title];

    timerLabel = [[UILabel alloc] initWithFrame:
                  CGRectMake(8, 28, 320, 36)];
    timerLabel.text = @"00:00.00";
    timerLabel.textColor = UIColor.blackColor;
    timerLabel.font = [UIFont monospacedDigitSystemFontOfSize:27
                                                      weight:UIFontWeightBold];
    timerLabel.textAlignment = NSTextAlignmentCenter;
    [timerBar addSubview:timerLabel];

    startButton = MakeButton(
        @"▶ Start", runningColor,
        CGRectMake(8, 73, 100, 34),
        self, @selector(startPressed));

    pauseButton = MakeButton(
        @"Ⅱ Pause", pausedColor,
        CGRectMake(116, 73, 100, 34),
        self, @selector(pausePressed));

    resetButton = MakeButton(
        @"↻ Reset", [UIColor darkGrayColor],
        CGRectMake(224, 73, 104, 34),
        self, @selector(resetPressed));

    [timerBar addSubview:startButton];
    [timerBar addSubview:pauseButton];
    [timerBar addSubview:resetButton];

    clockTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:self
                                                selector:@selector(tick)
                                                userInfo:nil
                                                 repeats:YES];

    [self tick];
}

- (void)tick {
    UpdateTimer();
}

- (void)startPressed {
    StartTimer();
}

- (void)pausePressed {
    PauseTimer();
}

- (void)resetPressed {
    ResetTimer();
}

@end

__attribute__((constructor))
static void MyLibInit(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"OClock: bibliothèque chargée.");
    });
}

