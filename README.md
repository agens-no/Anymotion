![Screenshot](logo_looped.gif)

Anymotion provides one unified API for animating UIKit, CoreAnimation, POP and your library of choice

- **powerful oneliners**
- **grouping and chaining animations**
- **cancellable animations with callbacks for clean up**

## Installation


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



## Basics

#### Powerful oneliners

Using a chainable builder pattern we can pack a good deal of configuration in one line

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *goRight = [[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:right] animationFor:view];
ANYAnimation *fadeOut = [[[[ANYCABasic new] toValue:@0] duration:1] animationFor:view.layer keyPath:@"opacity"];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/basics.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

Note: These animations won't start unless you say `start` like this

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
[goRight start];
[fadeOut start];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/basics.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

Instead of starting each one individually you can group them 
<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
[[goRight groupWith:fadeOut] start];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/basics.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

Calling `start` actually returns an `ANYActivity` empowering you with the option of stopping the animation at any time.

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYActivity *activity = [[goRight groupWith:fadeOut] start];
...
[activity cancel];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/start_and_cancel.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### POP
<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
NSValue *toValue = [NSValue valueWithCGPoint:CGPointMake(view.center.x + 200.0, view.center.y)];
NSValue *velocity = [NSValue valueWithCGPoint:CGPointMake(-50.0, 0.0)];
ANYAnimation *decay = [[[[ANYPOPDecay propertyNamed:kPOPViewCenter] toValue:toValue] velocity:velocity] animationFor:view];
ANYAnimation *basic = [[[[ANYPOPBasic propertyNamed:kPOPViewCenter] toValue:toValue] duration:0.5] animationFor:view];
ANYAnimation *spring = [[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValue:toValue] animationFor:view];    </pre></div></td>
    <td>
      <img src="/Meta/Readme/pop.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### Core Animation
<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
NSValue *left = [NSValue valueWithCGPoint:CGPointMake(100.0, 100.0)];
NSValue *right = [NSValue valueWithCGPoint:CGPointMake(200.0, 100.0)];
ANYAnimation *basic = [[[[ANYCABasic new] toValue:@0] duration:2.0] animationFor:view.layer keyPath:@"opacity"];
ANYAnimation *keyframe = [[[[ANYCAKeyFrame new] values:@[left, right, left, right]] duration:1.0] animationFor:view.layer keyPath:@"position"];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/core_animation.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### UIKit

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *anim = [ANYUIView animationWithDuration:0.5 block:^{
  view.alpha = 0.0;
}];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/uikit.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### Grouping

Start animations simultaneously

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *goRight = ...;
ANYAnimation *fadeOut = ...;
ANYAnimation *group = [ANYAnimation group:@[goRight, fadeOut]];
[group start];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/group.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### Chaining

When one animation completes then start another

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *goRight = ...;
ANYAnimation *goLeft = ...;
ANYAnimation *group = [goRight then:goLeft];
[group start];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/chain.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### Repeat

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *goRight = ...;
ANYAnimation *goLeft = ...;
ANYAnimation *group = [[goRight then:goLeft] repeat];
[group start];
    </pre></div></td>
    <td>
      <img src="/Meta/Readme/chain_and_repeat.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

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
