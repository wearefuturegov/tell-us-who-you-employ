namespace :db do

  desc "Outputs any invalid data records"
  task :invalid_records => :environment do
    puts "\n** Testing record validating in #{Rails.env.capitalize} environment**\n"
    [Service, Employee].each do |model|
      puts "#{model} records (#{model.count})"
      next if model.count == 0
      invalid = model.all.reject(&:valid?)
      if invalid.size.zero?
        puts "  all valid" and next
      else
        puts "  Some valid (#{model.count - invalid.size}), some invalid (#{invalid.size})"
      end
      invalid.each do |record|
        puts "  #{record.id}\tinvalid\t(#{record.errors.full_messages.to_sentence})"
      end
    end
  end

end