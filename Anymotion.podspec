Pod::Spec.new do |s|

    s.name          = "Anymotion"
    s.version       = "0.1"
    s.summary       = "Anymotion provides one unified API for animating UIKit, CoreAnimation, POP and your library of choice."
    s.homepage      = "https://github.com/agensdev/anymotion/"
    s.license       = {
    	:type => 'MIT',
    	:file => 'LICENSE'
    	}
    s.platform      = :ios, '8.0'
    s.requires_arc  = true
    s.authors       = {
      "Håvard Fossli" => "hfossli@agens.no"
    	"Mats Hauge" => "mats@agens.no"
    	}
    s.source        = {
        :git => "git@github.com:agensdev/anymotion.git",
        :tag => s.version.to_s
        }
    s.frameworks    = 'CoreGraphics', 'UIKit', 'QuartzCore'
    s.source_files  = 'Source/**/*.{h,m,mm,hpp,cpp,c}'

    s.dependency      'pop', '~> 1.0'

end
