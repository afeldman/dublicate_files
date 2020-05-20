#!/usr/bin/env ruby

require 'thor'
require 'digest'
require 'os/os'

old_sync = $stdout.sync
$stdout.sync = true

class DublicateFiles < Thor
  desc "find dublicat files", "using this program to find and move dublicate files"

  class_option  :input,
                :aliases => '-i',
                :desc => 'Input the source directory',
                :type => :array,
                :default => ["~/"],
                :required => false

  class_option  :output,
                :aliases => '-o',
                :desc => 'copy dublicates to this output folder',
                :type => :string,
                :default => "/tmp/",
                :required => false


  def start
    files={}
    destination = options[:output]

    options[:input].each { |source| 
      OS.func_file_walk(source) { |file|
        begin
          fileh = Digest::SHA256.hexdigest File.read file
        rescue => err
          next
        end
        if files.key? fileh
          puts "file #{file} already in map copy to #{destination}" 
          fileutils.move file, destination, :verbose => true, :force => true
        else
          files[fileh] = file
        end
      }
    }
  end

  default_task :start
end

DublicateFiles.start(ARGV)
