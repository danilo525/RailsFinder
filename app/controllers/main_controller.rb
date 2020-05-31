require_relative '../helpers/main_helper.rb'

class MainController < ApplicationController

  include MainHelper

  def index

  end

  def search

    @folderExist = folderExists(params[:path]) # load var if path exists

    if(@folderExist == true && params[:word] != "") # verify if path exists and word was informed
      
      allFolders = loadSubFolders(params[:path]) # load root folder informed and all subfolders

      @countFiles = 0
      listFiles = []

      allFolders.each do |dir|
        files = loadFiles(dir);
        if(files.length > 0) then # file list greater than 0 show list of files
          files.each do |item|
            content = searchForContent(dir, item, params[:word])
            if content
              @countFiles += 1
              file = {:fileName => item,:filePath=> dir,:fileContent=>content}
              listFiles.push(file)
            end
          end
        end
      end

      @listFiles = listFiles
    end

  end

end
