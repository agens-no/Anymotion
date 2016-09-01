# <img src="/Meta/logo.png?raw=true" height="42" alt="Anymotion" />

Anymotion provides one unified API for animations with support for UIKit, CoreAnimation, POP and your library of choice

### Installation

```
pod 'Anymotion'
```

##### Import in swift

```
import Anymotion
```

##### Import in Objective-C

```
#import <Anymotion/Anymotion.h>
```

### Basics

Powerful oneliners using a chainable builder pattern
```objc
POPBasicAnimation *alpha0 = [[[[POPBasicFactory propertyNamed:kPOPViewAlpha] duration:3] toValue:@0] build];
POPBasicAnimation *alpha1 = [[[[POPBasicFactory propertyNamed:kPOPViewAlpha] duration:3] toValue:@1] build];
POPBasicAnimation *frame0 = [[[[POPBasicFactory propertyNamed:kPOPViewFrame] duration:5] toValue:[NSValue valueWithCGRect:CGRectMake(100.0, 300.0, 50.0, 50.0)]] build];
POPBasicAnimation *frame1 = [[[[POPBasicFactory propertyNamed:kPOPViewFrame] duration:5] toValue:[NSValue valueWithCGRect:CGRectMake(100.0, 0.0, 50.0, 50.0)]] build];
```

Group animations together
```objc
AGAnimation *group = [AGAnimation group:@[
                                          [alpha0 animation:view0],
                                          [frame0 animation:view0],
                                          [alpha1 animation:view1],
                                          [frame1 animation:view1],
                                          ]];

[group start];
```

## Who's behind this?

Made with love by Agens.no, a company situated in Oslo, Norway.

[<img src="http://static.agens.no/images/agens_logo_w_slogan_avenir_medium.png" width="340" />](http://agens.no/)
