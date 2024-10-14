/* Example string */
string = 'This is a sample string'

/* Find the position of the first space */
spacePos = pos(' ', string)

/* Extract the substring up to the first space */
if spacePos > 0 then
  substring = substr(string, 1, spacePos - 1)
else
  substring = string

say 'Original string: ' string
say 'Substring up to first space: ' substring
