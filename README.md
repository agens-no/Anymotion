![Screenshot](logo_looped.gif)

Anymotion provides one unified API for animating UIKit, CoreAnimation, POP and your library of choice

- **powerful oneliners**
- **grouping and chaining animations**
- **cancellable animations with callbacks for clean up**

### Installation

##### Pods
```
pod 'Anymotion'
```

##### Carthage
```
github "agensdev/anymotion"
```

#####Import in swift

```
import Anymotion
```

##### Import in Objective-C

```
#import <Anymotion/Anymotion.h>
```

### Basics

#### Powerful oneliners

Using a chainable builder pattern we can pack a good deal of configuration in one line
```objc
ANYAnimation *goRight = [[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:right] animationFor:view];
ANYAnimation *fadeOut = [[[[ANYCABasic new] toValue:@0] duration:1] animationFor:view.layer keyPath:@"opacity"];
```
Note: These animations won't start unless you say `start` like this
```objc
[goRight start];
[fadeOut start];
```
Making you able to define your animations once and then start and cancel them at your leisure.

#### Grouping

Start these animations simultaneously

```objc
ANYAnimation *goRight = ...;
ANYAnimation *fadeOut = ...;
ANYAnimation *group = [ANYAnimation group:@[goRight, fadeOut]];
[group start];
```

#### Chaining

When one animation completes then start another
```objc
ANYAnimation *goRight = ...;
ANYAnimation *goLeft = ...;
ANYAnimation *group = [goRight then:goLeft];
[group start];
```

Chain and repeat indefinitely
```objc
ANYAnimation *goRight = ...;
ANYAnimation *goLeft = ...;
ANYAnimation *group = [[goRight then:goLeft] repeat];
[group start];
```

#### Start... and cancel

```objc
ANYAnimation *anim = ...;
ANYActivity *runningAnimation = [anim start];
...
[runningAnimation cancel];
```

#### Set up and clean up

```objc
ANYAnimation *pulsatingDot = ...;
[[pulsatingDot before:^{
  view.hidden = NO;
}] after:^{
  view.hidden = YES;
}];
[pulsatingDot start];
```

#### Callbacks

```objc
ANYAnimation *anim = ...;
[[anim onCompletion:^{
  NSLog(@"Animation completed");
} onError:^{
  NSLog(@"Animation was cancelled");
}] start];
```


## Who's behind this?

Made with love by [Agens.no](http://agens.no/), a company situated in Oslo, Norway.

[<img src="http://static.agens.no/images/agens_logo_w_slogan_avenir_medium.png" width="340" />](http://agens.no/)
