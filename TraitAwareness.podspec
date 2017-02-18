Pod::Spec.new do |s|
  s.name             = 'TraitAwareness'
  s.version          = '0.1.0'
  s.summary          = 'UIViewController extension, which adds the ability to set constraints based on the TraitCollection..'

  s.description      = <<-DESC
Including this pod extends UIViewControllers with functions to set constraints for any combination of compact, regular or undefined for vertical and horizontal sizeclasses. The correct constraints can then be activated with a simple call when transitioning to another TraitCollection.
                       DESC

  s.homepage         = 'https://github.com/Lutzifer/TraitAwareness'
  s.screenshots      = 'https://github.com/Lutzifer/TraitAwareness/raw/dev/Demo.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wolfgang Lutz' => 'wlut@num42.de' }
  s.source           = { :git => 'https://github.com/Lutzifer/TraitAwareness.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/WLBORg'

  s.ios.deployment_target = '9.0'

  s.source_files = 'TraitAwareness/Classes/**/*'
end
