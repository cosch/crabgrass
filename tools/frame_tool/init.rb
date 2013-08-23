$:.unshift File.expand_path('../lib', __FILE__)


PageClassRegistrar.add(
  'FramePage',
  :controller => 'frame_page',
  :icon => 'page_article',
  :class_display_name => :frame_class_display,
  :class_description => :frame_class_description,
  :class_group => 'media',
  :order => 5
)

self.load_once = false

