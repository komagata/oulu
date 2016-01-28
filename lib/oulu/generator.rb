require 'oulu/version'
require "fileutils"
require 'thor'

module Oulu
  class Generator < Thor
    map ['-v', '--version'] => :version

    desc 'install', 'Install Oulu into your project'
    method_options :path => :string, :force => :boolean
    def install
      if oulu_files_already_exist? && !options[:force]
        puts "Oulu files already installed, doing nothing."
      else
        install_files
        puts "Oulu files installed to #{install_path}/"
      end
    end

    desc 'update', 'Update Oulu'
    method_options :path => :string
    def update
      if oulu_files_already_exist?
        remove_oulu_directory
        install_files
        puts "Oulu files updated."
      else
        puts "No existing oulu installation. Doing nothing."
      end
    end

    desc 'version', 'Show Oulu version'
    def version
      say "Oulu #{Oulu::VERSION}"
    end

    private

    def oulu_files_already_exist?
      install_path.exist?
    end

    def install_path
      @install_path ||= if options[:path]
          Pathname.new(File.join(options[:path], 'oulu'))
        else
          Pathname.new('oulu')
        end
    end

    def install_files
      make_install_directory
      copy_in_scss_files
    end

    def remove_oulu_directory
      FileUtils.rm_rf("oulu")
    end

    def make_install_directory
      FileUtils.mkdir_p(install_path)
    end

    def copy_in_scss_files
      FileUtils.cp_r(all_stylesheets, install_path)
    end

    def all_stylesheets
      Dir["#{stylesheets_directory}/*"]
    end

    def stylesheets_directory
      File.join(top_level_directory, "app", "assets", "stylesheets")
    end

    def top_level_directory
      File.dirname(File.dirname(File.dirname(__FILE__)))
    end
  end
end