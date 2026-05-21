$pdf_mode = 1;          # build PDF with pdflatex
$bibtex_use = 2;        # run bibtex as needed
$out_dir = 'build';     # keep aux files out of the source tree
$pdflatex = 'pdflatex -interaction=nonstopmode -synctex=1 -file-line-error %O %S';
@default_files = ('main.tex');
