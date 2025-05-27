# Git and Make Workflow Demo Guide
*For demonstrating version control and automation to research assistants*

---

## Section 1: Installing Git on Mac

### Step 1.1: Check if Git is Already Installed
```bash
git --version
```
**Explain:** Git often comes pre-installed with macOS development tools.

### Step 1.2: If Git is Not Installed
**Xcode Command Line Tools (Recommended)**
```bash
xcode-select --install
```

### Step 1.3: Verify Installation
```bash
git --version
```
**Expected output:** Something like `git version 2.39.0`

### Step 1.4: Configure Git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@university.edu"
```
**Key point:** Use their university email for academic benefits later.

---

## Section 2: GitHub Account and Student Pack

### Step 2.1: Create GitHub Account
1. Go to https://github.com
2. Use university email address
3. Choose a professional username

### Step 2.2: GitHub Education Benefits
1. Go to https://education.github.com/pack
2. Click "Get student benefits"
3. Fill out application with:
   - University email
   - School name
   - Proof of enrollment (photo of student ID or enrollment verification)
4. Submit application

**Timeline note:** Approval can take 1-7 days. Benefits include private repositories, GitHub Copilot, and various development tools.

---

## Section 3: Creating a Repository on GitHub

### Step 3.1: Create New Repository
1. Click the "+" icon in top-right corner
2. Select "New repository"
3. Repository settings:
   - **Name:** Use descriptive names like "project-title" or "paper-name-2024"
   - **Description:** Brief project description
   - **Public vs Private:** Explain difference; recommend private for ongoing research
   - **Initialize with README:** Check this box
   - **Add .gitignore:** We'll do this manually later
   - **License:** Discuss briefly (MIT for code, consider data licensing separately)

### Step 3.2: Repository Structure Best Practices
Explain the typical academic project structure:
```
project-name/
├── README.md
├── data/
│   ├── raw/
│   └── clean/
├── code/
│   ├── 01_clean_data.R
│   ├── 02_analysis.R
│   └── 03_figures.R
├── output/
│   ├── figures/
│   └── tables/
├── paper/
│   ├── main.tex
│   └── references.bib
└── Makefile
```

---

## Section 4: Cloning Repository Locally

### Step 4.1: Get Repository URL
1. Click green "Code" button on GitHub
2. Copy HTTPS URL (not SSH for beginners)

### Step 4.2: Choose Local Directory
```bash
cd ~/Documents  # or wherever they organize projects
mkdir research-projects  # if doesn't exist
cd research-projects
```

### Step 4.3: Clone Repository
```bash
git clone https://github.com/username/repository-name.git
cd repository-name
```

### Step 4.4: Explore Directory
```bash
ls -la
```
**Explain:** 
- The `.git` folder (hidden) contains version control information
- `README.md` is what displays on GitHub homepage
- This is now a "local repository" connected to the "remote repository" on GitHub

---

## Section 5: Organization and .gitignore Setup

### Step 5.1: Create Project Structure
```bash
mkdir data data/raw data/clean code output output/figures output/tables paper
```

### Step 5.2: Understanding What NOT to Track
**Explain the principle:** Track inputs and instructions, not outputs.

**Track these files:**
- Source code (.R, .py, .do, .m)
- LaTeX files (.tex, .bib)
- Documentation (.md, .txt)
- Configuration files
- Raw data (sometimes - discuss data sensitivity)

**DON'T track these files:**
- Generated outputs (.pdf, .png, .jpg)
- Processed datasets (.csv, .dta derived from raw data)
- Log files (.log)
- Temporary files
- Large binary files
- Sensitive data

### Step 5.3: Create .gitignore File
```bash
touch .gitignore
```

Edit `.gitignore` with the following content:
```
# Output files
*.pdf
*.png
*.jpg
*.jpeg
*.eps
*.ps

# Data files (processed)
data/clean/
output/

# LaTeX auxiliary files
*.aux
*.bbl
*.blg
*.fdb_latexmk
*.fls
*.log
*.out
*.synctex.gz
*.toc

# R/Stata specific
.Rhistory
.RData
*.dta

# System files
.DS_Store
Thumbs.db

# IDE files
.vscode/
.idea/
```

### Step 5.4: Test .gitignore
```bash
echo "This is a test output" > output/test.pdf
git status
```
**Expected result:** The .pdf file should NOT appear in untracked files.

---

## Section 6: Hands-on Git Exercises

### Exercise 6.0: Fork demo repo and import data
Fork the demo repository on GitHub: `williamsca/workflow-demo`. Clone it to a local directory; then, create a Stata script called `program/script.do` that imports the building permits dataset: `data/building_permits.csv`.

### Exercise 6.1: First Commit
```bash
git status
```
**Explain:** Red files are "untracked" or "modified"

```bash
git add program/script.do
git status
```
**Explain:** Green files are "staged" for commit

```bash
git commit -m "Importing building permits dataset"
```
**Explain:** Commit message should be descriptive but concise

### Exercise 6.2: Push to GitHub
```bash
git push origin main
```
**Check on GitHub:** Refresh repository page to see changes

### Exercise 6.3: Make Changes and Track Them
Edit `paper.tex` to add content:

```latex
\section{Introduction}
This section will contain the introduction to my research.
```

```bash
git status
git diff paper.tex
```
**Explain:** `git diff` shows exactly what changed

```bash
git add paper.tex
git commit -m "Add introduction section to paper"
git push origin main
```

### Exercise 6.4: Understanding the Workflow
**Reinforce the cycle:**
1. `git status` - check what's changed
2. `git add <files>` - stage changes for commit
3. `git commit -m "message"` - save changes locally
4. `git push origin main` - send changes to GitHub

### Exercise 6.5: Create and Ignore Output Files
```bash
echo "Generated figure" > results/figures/scatter.png
echo "Results table" > results/tables/regression.tex
git status
```
**Point out:** These files don't appear because of .gitignore

---

## Section 7: Installing and Using Make

### Step 7.0: Check that Stata runs from the terminal
```
stata -b
```

If this fails: Add path to ~/.zshrc or ~/.bash_profile

```bash
# Add this line to ~/.zshrc or ~/.bash_profile
export PATH="/Applications/Stata/StataSE.app/Contents/MacOS:$PATH"
```

### Step 7.1: Check if Make is Installed
```bash
make --version
```
**If not installed on Mac:**
```bash
xcode-select --install
```

### Step 7.2: Understanding Make Concepts
**Explain:**
- Make automates your research pipeline
- Specifies dependencies between files
- Only rebuilds what's necessary when inputs change
- Saves time and ensures reproducibility

### Step 7.3: Makefile
Review Makefile; explain:
```makefile
%.pdf: %.tex
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*
```
**Explain:** This rule compiles LaTeX files into PDFs, running BibTeX for references. Wildcards (`$*`) represent the base name of the file; `%.tex` matches any `.tex` file. Add dependencies after the colon.

### Step 7.4: Create a plot
Update `/program/script.do` to plot total permits for Virginia by year. Save as `results/figures/permits-year-va.png`. Do *not* run the script yet.

Add plot to `paper.tex` and `slides.tex`:

```latex
\begin{figure}[h]
  \centering
  \includegraphics[width=0.8\textwidth]{results/figures/permits-year-va.png}
  \caption{Total building permits in Virginia by year}
  \label{fig:permits-year-va}
\end{figure}
```

### Step 7.5: Update Makefile
Add the following rule to the Makefile:
```makefile
%.pdf: %.tex results/figures/permits-year-va.png

results/figures/permits-year-va.png: program/script.do
   mkdir -p results/figures
   stata -b do program/script.do
```

**Explain:** This rule specifies that `permits-year-va.png` depends on the R script and that all `.tex` files depend on the generated plot.

### Step 7.6: Test Make Commands
```bash
make paper
```

**Check:** `results/figures/plot.png` should be created
**Check:** `paper/draft.pdf` should be created

```bash
make clean
make all
```
**Explain:** Clean removes outputs, then rebuilds everything

### Step 7.7: Demonstrate Make's Intelligence

Change `program/script.do` so that it plots permits for single-family homes only. Then run ```make paper```

**Check:** `results/figures/permits-year-va.png` and `paper/draft.pdf` should be updated

---

## Troubleshooting Common Issues

### Git Issues
- **Permission denied:** Check HTTPS vs SSH URLs
- **Merge conflicts:** Explain they'll learn this later; for now, coordinate with team
- **File too large:** Discuss Git LFS if needed for large datasets

### Make Issues
- **"No rule to make target":** Check file paths and spelling
- **Indentation errors:** Makefiles require tabs, not spaces
- **Command not found:** Ensure R/LaTeX/etc. are installed and in PATH

### General Tips
- Use `git status` frequently to stay oriented
- Commit early and often with descriptive messages
- Test Makefile incrementally
- Keep file and folder names simple (no spaces, special characters)

---

## Wrap-up Discussion Points

1. **Why version control matters:** Backup, collaboration, tracking changes
2. **When to commit:** Logical units of work, working code/text
3. **Collaboration workflow:** They'll learn branching/merging later
4. **Make benefits:** Reproducibility, efficiency, clear dependencies
5. **Next steps:** Practice with real project, explore GitHub features

## Resources for Further Learning
- [Git documentation](https://git-scm.com/doc)
- [GitHub Education resources](https://education.github.com/teachers)
- [Make tutorial](https://makefiletutorial.com/)
- Your institution's research computing resources