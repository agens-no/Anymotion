![Screenshot](logo_looped.gif)

Anymotion provides one unified API for animating UIKit, CoreAnimation, POP and your library of choice

- **powerful oneliners**
- **grouping and chaining animations**
- **cancellable animations with callbacks for clean up**

### Installation


<details>
<summary>Via CocoaPods</summary>

If you're using CocoaPods, you can simply add to your `Podfile`:

```ruby
pod "Anymotion"
```

This will download the `Anymotion` and dependencies in `Pods/` during your next `pod install` exection. You may have to say `pod repo update` first.

##### Import in swift
```swift
import Anymotion
```

##### Import in Objective-C
```objc
#import <Anymotion/Anymotion.h>
```

</details>

<details>
<summary>Via Carthage</summary>

To install SwiftGen via [Carthage](https://github.com/Carthage/Carthage) add to your Cartfile:

```ruby
github "agensdev/anymotion"
```

##### Import in swift
```swift
import Anymotion
```

##### Import in Objective-C
```objc
#import <Anymotion/Anymotion.h>
```

</details>



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
Thus making you able to define your animations once and then start and cancel them at your leisure.

#### POP 
```objc
ANYAnimation *decay = [[[ANYPOPDecay propertyNamed:kPOPViewAlpha] velocity:@(-10)] animationFor:view];
ANYAnimation *basic = [[[[ANYPOPBasic propertyNamed:kPOPViewAlpha] toValue:@0] duration:0.5] animationFor:view];
ANYAnimation *spring = [[[ANYPOPSpring propertyNamed:kPOPViewAlpha] toValue:@0] animationFor:view];
```

#### Core Animation
```objc
ANYAnimation *basic = [[[[ANYCABasic new] toValue:@0] duration:0.5] animationFor:view.layer keyPath:@"opacity"];
ANYAnimation *keyframe = [[[[ANYCAKeyFrame new] values:@[@0, @1]] duration:0.5] animationFor:view.layer keyPath:@"opacity"];
```

#### UIKit
```objc
ANYAnimation *anim = [ANYUIView animationWithDuration:0.5 block:^{
    view.alpha = 0.0;
}];
```

#### Grouping

Start animations simultaneously

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

#### Repeat
```objc
ANYAnimation *goRight = ...;
ANYAnimation *goLeft = ...;
ANYAnimation *group = [[goRight then:goLeft] repeat];
[group start];
```

#### Start... and cancel

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *anim = ...;
ANYActivity *runningAnimation = [anim start];
...
[runningAnimation cancel];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/start_and_cancel.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### Set up and clean up

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *pulsatingDot = ...;
[[pulsatingDot before:^{
   view.hidden = NO;
}] after:^{
   view.hidden = YES;
}];
[pulsatingDot start];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/setup_and_clean_up.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### Callbacks

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *anim = ...;
[[anim onCompletion:^{
    NSLog(@"Animation completed");
} onError:^{
    NSLog(@"Animation was cancelled");
}] start];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/callbacks.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>



## Who's behind this?

Made with love by [Agens.no](http://agens.no/), a company situated in Oslo, Norway.

[<img src="http://static.agens.no/images/agens_logo_w_slogan_avenir_medium.png" width="340" />](http://agens.no/)
