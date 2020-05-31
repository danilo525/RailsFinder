require 'search_in_file'

module MainHelper

  def folderExists(folderPath) # Define a method that verify if folder path is valid
    return Dir.exist?(folderPath)
  end

  # Method representing explore functions ( folder , file , content)

  def loadFiles(folderPath) # Define a method that ret a list of files txt, doc or pdf from a folder path

    @listFiles = [];
    Dir.foreach(folderPath) do |filename|
      if File.extname(filename) == '.txt' || File.extname(filename) == '.doc' ||
         File.extname(filename) == '.docx' || File.extname(filename) == '.pdf' then # for each file in the folder verify if its txt
        @listFiles.push(filename) # push filename in the list
      end
    end

    return @listFiles
  end

  def loadSubFolders(rootPath) # Define a method that ret a list subfolders

    @allFolders = []
    @allFolders.push(rootPath) # add the main folder to the list

    subfolders= Dir.glob rootPath + '/**/*/' # return list of subfolders

    subfolders.each do |dir|
      @allFolders.push(dir) # add subfolders to the list
    end

    return @allFolders # return list with all folders
  end

  def searchForContent(folderPath,filename,word) # Define a method that search the word in the file

    listLine =[]

    found = false
    countLines = 0     # how many lines the word appears
    countWord = 0      # how many times word appears
    linePosition =0    # line that word appears

    begin

      fullpath = folderPath.last() == "/" ? folderPath+filename : folderPath+'/'+filename;
      listFiles = SearchInFile.search( fullpath, word )

      if listFiles.length > 0 # verify if there are files with word

        listFiles.each do |key|

          key.each do |key , value| # loop in the content of the file

            if key.to_s == 'paragraphs'

              value.each do |line|                    # loop in the paragraphs content

                line.split("\n").each do |line|       # loop in the lines
                  linePosition += 1;

                  if line.downcase =~ (/#{word.downcase}/)     # check if line contains word
                    found = true
                    countLines += 1                   # increment countLines

                    listLine.push("*line #{linePosition.to_s.rjust(3)}: #{line}") # push line in the list to be displayed later

                    listWordsOfLine = line.split # create a list with all words of the line

                    listWordsOfLine.each { |_word|
                      if _word.downcase.include? word.downcase.gsub('.','') then   # for each word of the line verify the word searched
                        countWord += 1                                             # increment words found in the line
                      end
                    }
                  end
                end
              end
            end
          end
        end

        return listLine
      end

    rescue
      print "error loading listFiles for folder "
    end
  end

end
