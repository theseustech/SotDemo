#import "ViewController.h"
#import "ShipOTDemo-Swift.h"

#ifdef USE_SOT
#import "../sotsdk/libs/SotWebService.h"
#endif

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
    
    NSString* msg = [NSString stringWithFormat:@"versionkey: %@", version_key_str];
    NSLog(@"%@", msg);
    
#ifdef USE_SOT
    SotApplyCachedResult ApplyShipResult = [SotWebService ApplyCachedAndPullShip:version_key_str is_dev:false cb:^(SotDownloadScriptStatus status)
        {
            if(status == SotScriptShipAlreadyNewest)
            {
                NSLog(@"SyncOnly SotScriptShipAlreadyNewest");
            }
            else if(status == SotScriptShipHasSyncNewer)
            {
                NSLog(@"SyncOnly SotScriœœptShipHasSyncNewer");
            }
            else if(status == SotScriptShipDisable)
            {
                NSLog(@"SyncOnly SotScriptShipDisable");
            }
            else
            {
                NSLog(@"SyncOnly SotScriptStatusFailure");
            }
        }];

        if(ApplyShipResult.Success)
        {
            if(ApplyShipResult.ShipMD5)
                NSLog(@"sot success apply cached ship md5:%@", ApplyShipResult.ShipMD5);
        }
#endif
}

- (IBAction)RunDemoCode:(id)sender
{
    NSString* input1_str = [input1 text];
    TestSwift* swift_ins = [[TestSwift alloc] init];
    input1_str = [swift_ins test:input1_str];
    NSString* outcome_str = [NSString stringWithFormat:@"hello SOT test patch11:%@", input1_str];
    [outcome setText:outcome_str];
}
@end
