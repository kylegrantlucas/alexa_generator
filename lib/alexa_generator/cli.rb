require 'thor'
require 'active_support/core_ext/string'

module AlexaGenerator
  class HammerOfTheGods < Thor
    desc "hello NAME", "This will greet you"
    long_desc <<-HELLO_WORLD

    `hello NAME` will print out a message to the person of your choosing.

    Brian Kernighan actually wrote the first "Hello, World!" program 
    as part of the documentation for the BCPL programming language 
    developed by Martin Richards. BCPL was used while C was being 
    developed at Bell Labs a few years before the publication of 
    Kernighan and Ritchie's C book in 1972.

    http://stackoverflow.com/a/12785204
    HELLO_WORLD
    def new( name )
      name = name[6..-1] if name[0..5] == "alexa_"
      gemname = "alexa_#{name}"
      if system "bundler gem #{gemname}"
        files_to_modify = ["lib/#{gemname}.rb", "#{gemname}.gemspec"]

        files_to_modify.each do |filename|
          file = File.read("./#{gemname}/#{filename}")
          split_filename = filename.split('.')
          split_filename[0] = "#{split_filename[0]}_new"
          temp_filename = split_filename.join('.')

          File.open("./#{gemname}/#{temp_filename}", 'w') do |new_file|
            file.split("\n").each_with_index do |line, index|
              line_number = index+1
              if filename == "lib/#{gemname}.rb"
                if line_number == 2
                  new_file << "require 'sinatra/base'\n"
                  new_file << "require 'alexa_objects'\n\n"
                elsif line_number == 3
                  new_file << "module Siantra\n"
                  new_file << "  module #{name.camelize}\n"
                  new_file << "    def self.registered(app)\n"
                  new_file << "      app.post '/#{gemname}' do\n"
                  new_file << "      end\n"
                  new_file << "    end\n"
                  new_file << "  end\n\n"
                  new_file << "  register #{name.camelize}\n"
                  new_file << "end\n"
                elsif line_number == 4
                elsif line_number == 5
                else
                  new_file << line
                  new_file << "\n"
                end
              elsif filename == "#{gemname}.gemspec"
                if line_number == 24
                  new_file << "  spec.add_dependency 'sinatra'\n"
                  new_file << "  spec.add_dependency 'alexa_objects'\n\n"
                elsif line_number == 28
                  new_file << "#{line[0...-1]}, \"skills_config\"]\n"
                elsif line_number.between?(17, 23)  
                else
                  new_file << line
                  new_file << "\n"
                end
              end
            end
          end

          puts "Updated #{filename}" if system("rm ./#{gemname}/#{filename}") && system("mv ./#{gemname}/#{temp_filename} ./#{gemname}/#{filename}")   
        end

        puts "Created ./#{gemname}/skills_config" if system "mkdir ./#{gemname}/skills_config"

        ["sample_utterances", "intent_schema", "custom_slots"].each do |skill_file|
          puts "Created ./#{gemname}/skills_config/#{skill_file}.txt" if system "touch ./#{gemname}/skills_config/#{skill_file}.txt"

          file = File.open("./#{gemname}/lib/#{gemname}/#{skill_file}.rb", 'w') do |file|
            file << "module Sinatra\n"
            file << "  module #{name.camelize}\n"
            file << "    def self.#{skill_file}\n"
            file << "      File.read(File.expand_path('../../../skills_config/#{skill_file}.txt', __FILE__))\n"
            file << "    end\n"
            file << "  end\n"
            file << "end\n"
          end

          puts "Created ./#{gemname}/lib/#{gemname}/#{skill_file}.rb" if file
        end
      end
    end
  end
end