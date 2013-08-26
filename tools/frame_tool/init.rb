$:.unshift File.expand_path('../lib', __FILE__)


PageClassRegistrar.add(
  'FramePage',
  :controller => 'frame_page',
  :icon => 'page_article',
  :class_group => 'media',
  :order => 5
)

self.load_once = false
