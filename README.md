````
# Copybook Compare

This project is a REXX script that compares two files (`file1.txt` and `file2.txt`) to find lines containing the keyword `PIC`. It extracts the values after `PIC`, compares them, and writes the results to separate files for matched and unmatched lines.

## Files

- `copybookcompare.rex`: The main REXX script that performs the comparison.
- `file1.txt`: The first input file.
- `file2.txt`: The second input file.
- `matched.txt`: The output file for matched lines.
- `unmatched.txt`: The output file for unmatched lines.
- `README.md`: This README file.

## How It Works

1. **Read Input Files**: The script reads `file1.txt` and `file2.txt` and extracts lines containing the keyword `PIC`.
2. **Extract and Normalize Values**: It extracts and normalizes the values after `PIC` from both files.
3. **Compare Values**: The script compares the extracted values.
4. **Write Results**:
   - Matched lines are written to `matched.txt`.
   - Unmatched lines are written to `unmatched.txt`.
5. **Add Headers and Footers**: Headers and footers are added to the output files, including the total number of matched and unmatched lines.

## Usage

To run the script, use a REXX interpreter:

```sh
rexx

copybookcompare.rex


````

## Functions

- `readFile1(fileName, lines1)`: Reads `file1.txt` and extracts lines containing `PIC`.
- `readFile2(fileName, lines2)`: Reads `file2.txt` and extracts lines containing `PIC`.
- `extractAndNormalizePICValues1(lines1, lines1Count, values1)`: Extracts and normalizes values after `PIC` from `file1.txt`.
- `extractAndNormalizePICValues2(lines2, lines2Count, values2)`: Extracts and normalizes values after `PIC` from `file2.txt`.
- `addHeader(fileName, header)`: Adds a header to the specified output file.
- `addFooter(fileName, footer)`: Adds a footer to the specified output file.
- `compareAndWrite(values1Count)`: Compares the extracted values and writes matched and unmatched lines to the respective output files.

## Output

- `matched.txt`: Contains matched lines from both files with headers and footers.
- `unmatched.txt`: Contains unmatched lines from both files with headers and footers.

## Example

Here is an example of how the output files might look:

### matched.txt

```
File 1 Variable                                                                           File 2 Variable
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
... (matched lines)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total Matched Lines: X
```

### unmatched.txt

```
File 1 Variable                                                                         File 2 Variable
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
... (unmatched lines)
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total Unmatched Lines: Y
```

## License

This project is licensed under the MIT License.

```

```
