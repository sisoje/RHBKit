#ifndef RHB_SNIPPETS_H_
#define RHB_SNIPPETS_H_

// singleton example: RHB_SINGLETON(sharedInstance)
#define RHB_SINGLETON(NAME) +(instancetype)NAME {static dispatch_once_t pred;static id sharedObject;dispatch_once(&pred,^{sharedObject=[self new];});return sharedObject;}

/* defer construct like:
 RHB_DEFER {
   bla bla code...
 }];
*/
#define RHB_DEFER id _defer __unused = [[Deiniter alloc] init:^

#endif //RHB_SNIPPETS_H_
