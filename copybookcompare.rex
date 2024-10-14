/*REXX*/
/* Read both files, extract the lines which have 'PIC' into separate arrays.
   Read both arrays and extract the value after 'PIC' and compare them.
   All same and matched lines from both files will be written to a new file.
   All unmatched lines will be written to another file.
   The results file will have a header which includes total number of matched or unmatched.
*/

inputFile1 = 'file1.txt'
inputFile2 = 'file2.txt'
matchedFile = 'matched.txt'
unmatchedFile = 'unmatched.txt'
skippedFile= 'skipped.txt'

matchedCount = 0
unmatchedCount = 0

/* Read files and extract lines with 'PIC' */
lines1Count = readFile1(inputFile1, 'lines1.')
lines2Count = readFile2(inputFile2, 'lines2.') 
/* Extract and normalize values after 'PIC' */
values1Count = extractAndNormalizePICValues1('lines1.', lines1Count, 'values1.')
values2Count = extractAndNormalizePICValues2('lines2.', lines2Count, 'values2.')
/* Write Header to output files */
call addHeader matchedFile, 'File 1 Variable                                                                           File 2 Variable                                                                  '
call addHeader unmatchedFile, 'File 1 Variable                                                                         File 2 Variable                                                                    '
call addHeader matchedFile, '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
call addHeader unmatchedFile, '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

/* Compare values and write to output files */
call compareAndWrite values1Count


/* Add Footer to output files */
call addHeader matchedFile, '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
call addHeader unmatchedFile, '---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
call addFooter matchedFile, 'Total Matched Lines: ' || matchedCount
call addFooter unmatchedFile, 'Total Unmatched Lines: ' || unmatchedCount

exit

/* read file 1 */
readFile1: procedure expose lines1. combinedLine
  parse arg fileName, lines1
  if stream(fileName, 'C', 'QUERY EXISTS') = '' then do
    say 'Error: Unable to open file' fileName
    return 0
  end
  i = 0
  combinedLine = ''
  do while lines(fileName)
    line = linein(fileName)
    if index(line,'*')=7 then do 
    say 'Skipping line with comments: 'line
    call lineout skippedFile, fileName || line
    iterate
    end
    if pos('.', line) > 0 & pos('PIC', line) = 0 then do
      /* say 'Skipping line with period but no PIC clause: ' line */
      iterate
    end
    if pos('PIC', line) > 0 then do
      /* say 'Inside First IF: ' line  */
      if combinedLine \= '' then do
        combinedLine = combinedLine || ' ' || line
        /* say 'Inside Nested IF: combinedLine' */
        i = i + 1
        lines1.i = combinedLine
        /* say 'Inside Nested IF: ' combinedLine */
        combinedLine = ''
      end
      else do
        i = i + 1
        lines1.i = line
      end
    end
    else do
      combinedLine = combinedLine || ' ' || line
      /* say 'Inside else: ' combinedLine */
    end
  end
  if combinedLine \= '' then do
    i = i + 1
    lines1.i = combinedLine
  end
  call stream fileName, 'C', 'CLOSE'
  if i = 0 then
    say 'No lines containing PIC found in' fileName
  else
    say 'Lines containing PIC from' fileName ':' i
return i



/* read file 2*/

readFile2: procedure expose lines2. combinedLine
  parse arg fileName, lines2
  if stream(fileName, 'C', 'QUERY EXISTS') = '' then do
    say 'Error: Unable to open file' fileName
    return 0
  end
  i = 0
  combinedLine = ''
  do while lines(fileName)
    line = linein(fileName)
    if index(line,'*')=7 then do 
    say 'Skipping line with comments: 'line
    call lineout skippedFile, line
    iterate
    end
    if pos('.', line) > 0 & pos('PIC', line) = 0 then do
      /* say 'Skipping line with period but no PIC clause: ' line */
      iterate
    end
    if pos('PIC', line) > 0 then do
      /* say 'Inside First IF: ' line  */
      if combinedLine \= '' then do
        combinedLine = combinedLine || ' ' || line
        /* say 'Inside Nested IF: combinedLine' */
        i = i + 1
        lines2.i = combinedLine
        /* say 'Inside Nested IF: ' combinedLine */
        combinedLine = ''
      end
      else do
        i = i + 1
        lines2.i = line
      end
    end
    else do
      combinedLine = combinedLine || ' ' || line
      /* say 'Inside else: ' combinedLine */
    end
  end
  if combinedLine \= '' then do
    i = i + 1
    lines2.i = combinedLine
  end
  call stream fileName, 'C', 'CLOSE'
  if i = 0 then
    say 'No lines containing PIC found in' fileName
  else
    say 'Lines containing PIC from' fileName ':' i
return i

extractAndNormalizePICValues1: procedure expose lines1. values1.
  parse arg inputStem, inputCount, outputStem
  do i = 1 to inputCount
    line = value(inputStem||i)
    picPos = pos('PIC', line)
    if picPos > 0 then do
      value = substr(line, picPos + 4)
      /* say 'Value:1 before strip:' value */
      /* Find the position of the first space or period */
      spacePos = pos(' ', value)
      periodPos = pos('.', value)
      
      /* Determine which comes first */
      if spacePos = 0 then spacePos = length(value) + 1
      if periodPos = 0 then periodPos = length(value) + 1
      
      /* Get the value up to the first space or period */
      minPos = min(spacePos, periodPos)
      value = substr(value, 1, minPos - 1)
      /* say 'Value:1 before normalize:' value */
      value = normalizePIC(value)
      values1.i = value
    end
  end
return inputCount

extractAndNormalizePICValues2: procedure expose lines2. values2.
  parse arg inputStem, inputCount, outputStem
  do i = 1 to inputCount
    line = value(inputStem||i)
    picPos = pos('PIC', line)
    if picPos > 0 then do
      value = substr(line, picPos + 4)
      /* say 'Value:2 before strip:' value */
      /* Find the position of the first space or period */
      spacePos = pos(' ', value)
      periodPos = pos('.', value)
      
      /* Determine which comes first */
      if spacePos = 0 then spacePos = length(value) + 1
      if periodPos = 0 then periodPos = length(value) + 1
      
      /* Get the value up to the first space or period */
      minPos = min(spacePos, periodPos)
      value = substr(value, 1, minPos - 1)
      /* say 'Value:2 before normalizePIC' value */
      value = normalizePIC(value)
      values2.i = value
    end
  end
return inputCount

normalizePIC: procedure
  parse arg value
  if pos('(', value) > 0 then do
    parse var value prefix '(' count ')' suffix
    count = strip(count)
    if prefix = '9' then
      value = copies('9', count)
    else if prefix = 'X' then
      value = copies('X', count)
  end
return value

compareAndWrite: procedure expose lines1. lines2. values1. values2. matchedFile unmatchedFile matchedCount unmatchedCount
  parse arg count
  do i = 1 to count
    value1 = values1.i
    value2 = values2.i
    /* say value1 ' <> ' value2 */
    /* say 'Comparing:' value1 ' <> ' value2 */
       /* Format lines1 and lines2 to be exactly 80 characters wide */
    formattedLine1 = left(lines1.i, 80)  /* Adjust left alignment */
    formattedLine2 = left(lines2.i, 80)  /* Adjust left alignment */
    if value1 = value2 then do
      call lineout matchedFile, formattedLine1 || ' <> ' || formattedLine2
      matchedCount = matchedCount + 1
    end
    else do
      call lineout unmatchedFile, formattedLine1 || ' <> ' || formattedLine2
      unmatchedCount = unmatchedCount + 1
    end
  end
  say 'Total matched lines:' matchedCount
  say 'Total unmatched lines:' unmatchedCount

return

addFooter: procedure
  parse arg fileName, header
  
  /* Ensure proper line breaks by using a simple call to lineout */
  call lineout fileName, header

return

addHeader: procedure
  parse arg fileName, header
  
  /* Ensure proper line breaks by using a simple call to lineout */
  call lineout fileName, header

return
