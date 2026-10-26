#import <Foundation/Foundation.h>

__attribute__((constructor))
static void MyLibInit(void) {
    NSLog(@"MyLib a été chargée.");
}
