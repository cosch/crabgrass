$:.unshift File.expand_path('../lib', __FILE__)


PageClassRegistrar.add(
  'FramePage',
  :controller => 'frame_page',
  :icon => 'page_text',
  :class_display_name => 'Externe Url',
  :class_description => :frame_class_description,
  :class_group => 'text',
  :order => 5
)

self.load_once = false

