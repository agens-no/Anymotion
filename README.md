![Screenshot](/Meta/Readme/logo.gif)

Anymotion provides one unified API for animating UIKit, CoreAnimation, POP and your library of choice

- **powerful oneliners**
- **grouping and chaining animations**
- **cancellable animations with callbacks for clean up**
- **swift api**

## Installation


<details>
<summary>Via CocoaPods</summary>

If you're using CocoaPods, you can simply add to your `Podfile`:

```ruby
pod "Anymotion", :git => 'https://github.com/agens-no/Anymotion.git', :branch => 'master'
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

Using a chainable builder pattern we can pack a good deal of configuration in one line

```objc
let goRight = ANYPOPSpring(kPOPLayerPositionX).toValue(100).springSpeed(5).animation(for: view.layer)
let fadeOut = ANYCABasic(#keyPath(CALayer.opacity)).toValue(0).duration(1).animation(for: view.layer)
```

Note: These animations won't start unless you say `start` like this

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
goRight.start()
fadeOut.start()</pre></div></td>
    <td>
      <img src="/Meta/Readme/basics.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

Instead of starting each one individually you can group them
<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
goRight.groupWith(fadeOut).start()</pre></div></td>
    <td>
      <img src="/Meta/Readme/basics.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

Calling `start` actually returns an `ANYActivity` empowering you to stop the animation at any time.

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
let activity = goRight.groupWith(fadeOut).start()
...
activity.cancel()</pre></div></td>
    <td>
      <img src="/Meta/Readme/start_and_cancel.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

## Live Examples

Compile and run the iOS-Example project to watch some beautiful examples!

 <img width="32.9%" src="/Meta/Readme/button.gif?raw=true" alt="GIF" />
 <img width="32.9%" src="/Meta/Readme/pan.gif?raw=true" alt="GIF" />
 <img width="32.9%" src="/Meta/Readme/list.gif?raw=true" alt="GIF" />

## Frameworks integrations

#### POP

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
let spring = ANYPOPSpring(kPOPLayerPositionX)
               .toValue(100)
               .springSpeed(5)
               .animation(for: view.layer)</pre></div>
    <td>
      <img src="/Meta/Readme/spring.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
let basic = ANYPOPBasic(kPOPLayerPositionX)
               .toValue(100)
               .duration(2)
               .animation(for: view.layer)</pre></div>
    <td>
      <img src="/Meta/Readme/basic.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
let decay = ANYPOPDecay(kPOPLayerPositionX)
               .velocity(10)
               .animation(for: view.layer)</pre></div>
    <td>
      <img src="/Meta/Readme/decay.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

#### Core Animation

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
let basic = ANYCABasic(#keyPath(CALayer.position))
               .toValue(CGPoint(x: 100, y: 0))
               .duration(2)
               .animation(for: view.layer)</pre></div>
    <td>
      <img src="/Meta/Readme/basic.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>


#### UIKit

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
let uikit = ANYUIView.animation(duration: 2) {
    view.center.x = 100
}</pre></div></td>
    <td>
      <img src="/Meta/Readme/basic.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>


## Operators

#### Grouping

Start animations simultaneously

<table>
  <tr>
    <td width="400px"><div class="highlight"><pre>
ANYAnimation *goRight = ...;
ANYAnimation *fadeOut = ...;
ANYAnimation *group = [ANYAnimation group:@[goRight, fadeOut]];
[group start];</pre></div></td>
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
[group start];</pre></div></td>
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
[group start];</pre></div></td>
    <td>
      <img src="/Meta/Readme/chain_and_repeat.gif?raw=true" alt="GIF" />
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
[pulsatingDot start];</pre></div></td>
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
}] start];</pre></div></td>
    <td>
      <img src="/Meta/Readme/callbacks.gif?raw=true" alt="GIF" />
    </td>
  </tr>
</table>

## Feedback

We would 😍 to hear your opinion about this library. Wether you [like it](https://github.com/agens-no/Anymotion/issues/20) or [don't](https://github.com/agens-no/Anymotion/issues/19). Please file an issue if there's something you would like like improved, so we can fix it!

If you use Anymotion and are happy with it consider sending out a tweet mentioning [@agens](https://twitter.com/agens). This library is made by love by [Mats Hauge](https://github.com/matshau), who's passionate about animations, and [Håvard Fossli](https://twitter.com/hfossli), who cares deeply about architecture.

[<img src="http://static.agens.no/images/agens_logo_w_slogan_avenir_medium.png" width="340" />](http://agens.no/)
