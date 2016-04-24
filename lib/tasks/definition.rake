namespace :definition do

  desc "validate the correctness of definitions"
  task validate: :environment do
    Definition.all.each do |defi|
      defi.properties.each do |prop|
        type = prop.type
        if type == 'array'
          type = prop.format
        end
        if ['integer', 'string', 'boolean'].include? type
          next
        end
        best_match = defi.name.split('.')[0] + '.' + type
        if Definition.find_by_name(best_match)
          next
        end
        common_match = "Common.#{type}"
        if Definition.find_by_name(common_match)
          next
        end
        puts "#{prop.id}. #{prop.name} : #{type}"
      end
    end
  end

end
