$:.unshift File.expand_path('../lib', __FILE__)

require 'EPL'

PageClassRegistrar.add(
  'PadPage',
  :controller => 'pad_page',
  :icon => 'page_text',
  :class_display_name => 'pad',
  :class_description => :pad_class_description,
  :class_group => 'text',
  :order => 1
)

self.load_once = false
