# Woordenboek
An example of a FreePascal database application using SQLite. The app is designed to be a dictionary of a specified language (being called there "Conlang").

# NOTES
- The CSV files in HebrewWords/ are sample CSV files that are compatible with the program.
- The compatible CSV contains entries in each row (every row ends with a char of new line), and each entry is divided by tabs to 3 parts - `original`, `translation` and `notes`.
- The CSV files like above are almost fully compatible with the program, but you should avoid an ' char (apostrophe, I use \` instead) – also you should avoid `<` and `>`, if you want to export/import using XML.
- The Windows users will require a file sqlite3.dll placed along the executable, designed for the PC processor architecture (x86, x64 etc.)
- The Linux users will reuire sqlite installed on their PCs.