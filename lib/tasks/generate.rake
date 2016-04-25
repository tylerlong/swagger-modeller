require 'fileutils'
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
      result = result.gsub(/^\s+$/, '')
      puts result

      dir_name = "./tmp/generated/#{namespace}"
      unless File.directory?(dir_name)
        FileUtils.mkdir_p(dir_name)
      end
      file_name = "#{dir_name}/#{class_name}.cs"
      File.write(file_name, result)
    end
  end

end
