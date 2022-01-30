
#########################################
# >>+-,.[ Brainfuck Interpreter ].,-+<< #
#########################################


def readFile(filename)
	if(File.exist?(filename))
		fileToParse = File.new(filename, "r")
		data = fileToParse.read()

		# Remove all character that aren't ">", "<", "+", "-", "[", "]", "." or ","
		data = data.gsub(/[^\>\<\+\-\.\,\[\] ]/i, '').gsub(/\s+/, "")

		fileToParse.close
		return data

	else
		return "File \'#{filename}\' not found"
	end
end



def parseCode(code)

	bracketStack = Array.new
	bracketMap = Hash.new
	for i in 0..(code.length)
		if code[i] == "["
			bracketStack.push(i)
		elsif code[i] == "]"
			openBracket = bracketStack.pop()
			bracketMap[openBracket] = i 
			bracketMap[i] = openBracket 
		end	
	end

	cellArray = Array.new.push(0)
	curCellPosition = 0

	curCommand = 0
	
	while curCommand < code.length do

		case code[curCommand]
		when ">"
			curCellPosition += 1
			if curCellPosition == cellArray.length
				cellArray.push(0)
			end
			
		when "<"
			if curCellPosition == 0
				cellArray.unshift(0)
			else
				curCellPosition -= 1
			end
			
		when "+"
			cellArray[curCellPosition] = (cellArray[curCellPosition]+1)%256
			
		when "-"
			cellArray[curCellPosition] = (cellArray[curCellPosition]-1)%256
		
		when "["
			if cellArray[curCellPosition] == 0
				curCommand = bracketMap[curCommand] 
			end

		when "]" 
			if cellArray[curCellPosition] != 0
				curCommand = bracketMap[curCommand] 
			end

		when "."
			print cellArray[curCellPosition].chr
			
		when ","
			char = STDIN.getc
			cellArray[curCellPosition] = char.ord

		else
			puts "Error: Invalid command detected"
			exit -1 
		end
	
		curCommand += 1	
	end
end

# --- Main --- # 
if __FILE__ == $PROGRAM_NAME
	if ARGV.length != 1
		puts "Usage: #{$PROGRAM_NAME} filename"
	else
		code = readFile(ARGV[0])		
		parseCode(code)		
	end
end
