guard "foodcritic", cookbook_paths: '.', :cli => '-t ~FC048', all_on_start: false do
  watch(%r{attributes/.+\.rb$})
  watch(%r{providers/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
  watch(%r{resources/.+\.rb$})
end

guard 'rubocop', all_on_start: false do
  watch(/attributes\/.+\.rb$/)
  watch(/providers\/.+\.rb$/)
  watch(/recipes\/.+\.rb$/)
  watch(/resources\/.+\.rb$/)
  watch('metadata.rb')
end
