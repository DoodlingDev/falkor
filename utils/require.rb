module Falkor
  module Utils
    class Require
      def self.recursive_from(path)
        list = GTK.list_files(path)
        list.each do |filename|
          file_metadata = GTK.stat_file("#{path}/#{filename}")
          if file_metadata[:file_type] == :regular
            next if filename.start_with?(".")
            next if filename == "main.rb"
            next if filename == "require.rb"
            next unless filename.end_with?(".rb")

            require "#{path}/#{filename}"
          elsif file_metadata[:file_type] == :directory
            recursive_from "#{path}/#{filename}"
          end
        end
      end
    end
  end
end
