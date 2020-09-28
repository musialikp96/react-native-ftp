
#import "RNFtp.h"
#import <FTPKit/FTPKit.h>
#import <React/RCTLog.h>

@implementation RNFtp
static NSString * ipAddress = @"";
static NSString * username = @"";
static NSString * password = @"";
static NSNumber * port;

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE(FTP);

RCT_EXPORT_METHOD(setup:(NSString *)ip port:(nonnull NSNumber *)p) {
    ipAddress = ip;
    port = p;
}

RCT_EXPORT_METHOD(login:
                  (NSString *)u
                  password:(NSString *)p
                  loginWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {

    username = u;
    password = p;

    NSDictionary *dict = @{
        @"client":@{
                @"user":username,
                @"passw":password
        }
    };

    resolve(dict);
}

RCT_EXPORT_METHOD(list:
                  (NSString *)dir
                  loginWithResolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject) {

    FTPClient *client = [FTPClient clientWithHost:ipAddress port:21 username:@"admin@serwer2022694.home.pl" password:@"mOrela8maNgo&"];
    NSArray *contents = [client listContentsAtPath:dir showHiddenFiles:NO];

    NSMutableArray *files = [[NSMutableArray alloc] init];

    if (contents /* Returns nil if an error occured */) {
        // Iterate through handles. Display them in a table, etc.
        for (FTPHandle *handle in contents) {
            NSDictionary *tmp = @{
                @"name": handle.name,
                @"size":[NSNumber numberWithUnsignedLongLong:handle.size],
                @"timestamp":handle.modified
            };
            [files addObject:tmp];
        }
        resolve(files);

    } else {
        reject(@"no_files", @"There were no files",client.lastError);
    }
}

RCT_EXPORT_METHOD(dev:(RCTResponseSenderBlock)callback) {
    callback(@[[NSNull null], port]);
}


@end

