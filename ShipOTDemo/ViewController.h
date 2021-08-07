#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property IBOutlet UITextField *versionkey;
@property IBOutlet UITextField *input1;
@property IBOutlet UITextView *outcome;
@property NSString *save_info_filepath;
@property NSMutableDictionary *save_info;

-(IBAction) SotUpdate:(id)sender;
-(IBAction) RunDemoCode:(id)sender;
@end

