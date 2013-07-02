Gem::Specification.new do |s|
   s.name         = 'lineify'
   s.version      = '0.0.0'
   s.date         = Time.now.strftime('%Y-%m-%d')
   s.summary      = 'lineify'
   s.description  = 'Compress text-based objects down into one line per object.'
   s.authors      = ["James Pearson"]
   s.email        =  'james@ifixit.com'
   s.files        += Dir.glob 'lib/*'
   s.license      = 'dwtyw'
end
