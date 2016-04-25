require "#{Rails.root}/app/helpers/generators_helper"
include GeneratorsHelper

namespace :generate do

  desc "generate csharp code for definitions"
  task csharp: :environment do
    template = Rails.root.join("app/views/generators/csharp.html.erb").read
    Definition.all.each do |defi|
      namespace, class_name = defi.name.split('.')
      properties = defi.properties
      result = ERB.new(template).result(binding)
      puts result
      break
    end
  end

end
