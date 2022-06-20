require 'rails/generators/base'

module Graphqlscaffold
  module Generators
    class TypeGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __dir__)

      def create_type_file
        if system("rails g graphql:object #{file_name}")

          src_file = "app/graphql/types/#{file_name}_type.rb"
          dst_dir = 'app/graphql/types/admin'
          if File.exist? ("app/graphql/types/#{file_name}_type.rb")
            FileUtils.mv(src_file, dst_dir)
            file = File.open("#{dst_dir}/#{file_name}_type.rb")
            file_data = file.read
            new_file_data = file_data.insert(21, 'Admin::')
            File.write(file, new_file_data)
          else
            p "can not find #{file_name}_type file to move"
          end
        else
          p "can not create #{file_name}_type file"
        end
      end

      def create_filter_file
        @module_name = options[:module]

        filter_dir_path = 'app/graphql/types/inputs/admin'
        generator_dir_path = filter_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
        generator_path = generator_dir_path + "/#{file_name}_filter.rb"

        FileUtils.mkdir_p(filter_dir_path) unless File.exist?(filter_dir_path)
        FileUtils.mkdir_p(generator_dir_path) unless File.exist?(generator_dir_path)

        template 'admin_filter.haml', generator_path
      end

      def create_query_type_file
        query_type_dir_path = 'app/graphql/types/admin'
        generator_dir_path = query_type_dir_path
        generator_path = generator_dir_path + '/query_type.rb'

        FileUtils.mkdir_p(query_type_dir_path) unless File.exist?(query_type_dir_path)
        FileUtils.mkdir_p(generator_dir_path) unless File.exist?(generator_dir_path)

        if File.exist?(generator_path)
          file = File.open(generator_path)
          file_data = file.read
          new_file_data = file_data.insert(-15, "   has_admin_fields :#{class_name}\n   ")
          File.write(file, new_file_data)
          p 'Write to query_type.rb successfully'
        else
          template 'query_type.haml', generator_path
        end
      end

      def create_base_object_file
        base_object_dir_path = 'app/graphql/types'
        generator_dir_path = base_object_dir_path
        generator_path = generator_dir_path.concat('/base_object.rb')

        FileUtils.mkdir_p(base_object_dir_path) unless File.exist?(base_object_dir_path)
        FileUtils.mkdir_p(generator_dir_path) unless File.exist?(generator_dir_path)

        template 'base_object.haml', generator_path
      end

      def create_test_file
        test_dir_path = 'spec/requests/queries'
        test_file_path = test_dir_path + "/#{file_name}_spec.rb"
        FileUtils.mkdir_p(test_dir_path) unless File.exist?(test_dir_path)
        template 'query_test.haml', test_file_path
      end
    end
  end
end
