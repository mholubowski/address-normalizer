## Deletes AddressSets and all dependencies which are 2 hours or olders
task :cleanup => :environment do
  puts 'cleaning up AddressSets...'
  AddressSet.destroy_all(["updated_at < ?", Time.now - 2.hours])
  puts "Done!"
end
