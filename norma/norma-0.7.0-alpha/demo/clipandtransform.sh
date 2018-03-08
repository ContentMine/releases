#!/bin/bash

export NORMA_JAR="../norma-0.7.0-alpha-jar-with-dependencies.jar"
export NORMA="java -jar $NORMA_JAR" 

if [ ! -f ${NORMA_JAR} ]; then
    printf "Norma not found!\n";
		exit 1;
fi

export RESULTS_DIR=CorpusResults
export PROJ_PREFIX=TCDemo
if [ ! -f ${RESULTS_DIR} ]; then
	mkdir ${RESULTS_DIR}
fi

## Example:
## http://eppi.ioe.ac.uk/pdfs4crowd/16515705.pdf
## Multiple tables in same paper

export PAPER_NO=16515705
export PROJECT=${RESULTS_DIR}/${PROJ_PREFIX}_P${PAPER_NO}
rm -rf ${PROJECT}
# Make a temporary directory to hold results of extracting from paper
mkdir ${PROJECT}
cp corpus_cochranecrowd/${PAPER_NO}.pdf ${PROJECT} 
# Create the ContentMine CTree directory structure for results from this PDF
${NORMA} --project ${PROJECT} --fileFilter ".*/(.*)\\.pdf" --makeProject "(\\1)/fulltext.pdf" 
# Convert the PDF to SVG using ContentMine conversion tailored to further extraction
printf "\nConvert PDF pages to ContentMine SVG:\n";
${NORMA} --project ${PROJECT} --input fulltext.pdf --outputDir ${PROJECT} --transform pdf2svg

# Use data provided by crowd to clip out each table in the paper
#
printf "\nClip out tables using crowd data:\n";
# Note: Table numbers are not derived from the table contents they are just unique serial numbers within each paper

# H1516291135139
${NORMA} --project ${PROJECT} --cropbox x0 17.5 y0 26 width 178.5 height 97.5 ydown units mm --pageNumbers 5 --output tables/table1516291135139/table.svg

# H1516291144796

${NORMA} --project ${PROJECT} --cropbox x0 16 y0 218.5 width 180.5 height 41 ydown units mm --pageNumbers 5 --output tables/table1516291144796/table.svg

# All tables in paper are now in the CTree as SVG, used as intermediate format

printf "\nTransform tables from SVG to HTML:\n";

# Transform tables in SVG to HTML5 extracting individual numerical values and
# semantic table structure
${NORMA} --project ${PROJECT} --fileFilter "^.*tables/table(\\d+)/table(_\\d+)?\\.svg" --outputDir ${PROJECT} --transform svgtable2html 

printf "\nTransform tables from SVG to CSV:\n";

# Transform tables in SVG to CSV extracting individual numerical values
${NORMA} --project ${PROJECT} --fileFilter "^.*tables/table(\\d+)/table(_\\d+)?\\.svg" --outputDir ${PROJECT} --transform svgtable2csv 

## End single paper

### End all papers

printf "\n";

exit 0;

