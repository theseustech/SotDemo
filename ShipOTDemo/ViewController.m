#import "ViewController.h"
#import "ShipOTDemo-Swift.h"
#import "/Users/sotsdk-1.0/libs/SotWebService.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize versionkey;
@synthesize input1;
@synthesize outcome;
@synthesize save_info_filepath;
@synthesize save_info;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    save_info_filepath = [documentsDirectory stringByAppendingString:@"/sotdemosave.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:save_info_filepath])
    {
        save_info = [NSMutableDictionary dictionaryWithContentsOfFile:save_info_filepath];
        NSString* saved_version_key = save_info[@"versionkey"];
        if(saved_version_key)
            [versionkey setText:saved_version_key];
    }
    else
    {
        save_info = [[NSMutableDictionary alloc] init];
    }
}

- (IBAction)SotUpdate:(id)sender
{
    NSString* version_key_str = [versionkey text];
    [save_info setValue:version_key_str forKey:@"versionkey"];
    [save_info writeToFile:save_info_filepath atomically:YES];
    
#ifdef DEBUG // use free version
    [SotWebService ApplyBundleShip];
#else
#ifdef SOT_ENTERPRISE
    NSBundle* MainBundle = [NSBundle mainBundle];
    NSString *ShipPath = [MainBundle pathForResource:@"shipinfo" ofType:@"sot"];
    if(!ShipPath)
    {
        NSLog(@"err");
        return;
    }
    NSURL *fileUrl = [NSURL fileURLWithPath:ShipPath];
    if(!fileUrl)
        return;
    NSData *fileData = [NSData dataWithContentsOfURL:fileUrl];
    if(!fileData)
        return;
    char *fileBytes = (char *)[fileData bytes];
    NSUInteger length = [fileData length];
    if ([SotWebService ApplyShipByData:fileBytes length:length])
    {
        NSLog(@"apply ship success");
    }
#else // use web version
    NSString* msg = [NSString stringWithFormat:@"versionkey: %@", version_key_str];
    NSLog(@"%@", msg);
    [SotWebService Sync:version_key_str is_dev:false cb:^(SotDownloadScriptStatus status)
    {
        if(status == SotScriptStatusSuccess)
        {
            NSLog(@"SotScriptStatusSuccess");
        }
        else
        {
            NSLog(@"SotScriptStatusFailure");
        }
    }];
#endif
#endif
}

- (IBAction)RunDemoCode:(id)sender
{
    NSString* input1_str = [input1 text];
    TestSwift* swift_ins = [[TestSwift alloc] init];
    input1_str = [swift_ins test:input1_str];
    NSString* outcome_str = [NSString stringWithFormat:@"hello SOT:%@", input1_str];
    [outcome setText:outcome_str];
}
@end
