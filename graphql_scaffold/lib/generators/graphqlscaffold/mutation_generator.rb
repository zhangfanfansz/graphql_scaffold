require 'rails/generators/base'
module Graphqlscaffold
  module Generators

    class MutationGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('../templates', __dir__)

      def create_admin_mutation_folders
        admin_mutation_dir_path = 'app/graphql/mutations/admin'
        generator_dir_path = admin_mutation_dir_path + ("/#{@module_name.underscore}" if @module_name.present?).to_s
        @generator_path = generator_dir_path + "/#{file_name}s"

        FileUtils.mkdir_p(admin_mutation_dir_path) unless File.exist?(admin_mutation_dir_path)
        if File.exist?(@generator_path)
          p 'Folder already exist'
        elsif Dir.mkdir(@generator_path)
          p 'Folder created successfully'
        end
      end

      def create_admin_mutation_create_file
        if File.exist?(@generator_path)
          create_file_path = @generator_path + "/create_#{file_name}.rb"
          if File.exist?(create_file_path)
            p 'Create File already exist'
          else
            template 'mutation_create.haml', create_file_path
          end
        end
      end

      def create_admin_mutation_update_file
        if File.exist?(@generator_path)
          update_file_path = @generator_path + "/update_#{file_name}.rb"
          if File.exist?(update_file_path)
            p 'Update File already exist'
          else
            template 'mutation_update.haml', update_file_path
          end
        end
      end

      def create_admin_mutation_delete_file
        if File.exist?(@generator_path)
          delete_file_path = @generator_path + "/delete_#{file_name}.rb"
          if File.exist?(delete_file_path)
            p 'Delete File already exist'
          else
            template 'mutation_delete.haml', delete_file_path
          end
        end
      end

      def create_mutation_type_file
        mutation_type_dir_path = 'app/graphql/types/admin'
        generator_dir_path = mutation_type_dir_path
        generator_path = generator_dir_path + '/mutation_type.rb'

        FileUtils.mkdir_p(mutation_type_dir_path) unless File.exist?(mutation_type_dir_path)
        FileUtils.mkdir_p(generator_dir_path) unless File.exist?(generator_dir_path)

        if File.exist?(generator_path)
          file = File.open(generator_path)
          file_data = file.read
          new_file_data = file_data.insert(-15, "  has_admin_mutation :#{class_name}\n    ")
          File.write(file, new_file_data)
          p 'Write to query_type.rb successfully'
        else
          template 'mutation_type.haml', generator_path
        end
      end

      def create_test_file
        test_dir_path = 'spec/requests/mutations'
        test_file_path = test_dir_path + "/#{file_name}_spec.rb"
        FileUtils.mkdir_p(test_dir_path) unless File.exist?(test_dir_path)
        template 'mutation_test.haml', test_file_path
      end
    end
  end
end