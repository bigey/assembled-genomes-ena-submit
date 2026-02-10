set -e

#================================================================================
# PARAMETERS 
#================================================================================

# TEST/SUBMIT YOUR DATA
# One of the following:
# "true": submit to testing server, 
# "false": real data submission
TEST="true"

# CREDENTIAL FILE
# File containing the credentials. 
# One line containing: 
# username password
CREDENDIAL=.credential

# MANIFEST FILE
# The manifest file contains metadata about the genome assembly.
# The file is a tab-separated text file with two columns.
MANIFEST="manifest.tsv"

#===============================================================================
# DO NOT MODIFY BELOW THIS LINE
#===============================================================================

# CHECKING ENVIRONMENT
# Check if the required tools are installed
if ! command -v java &> /dev/null; then
    echo "Java is not installed. Please install Java to run this script."
    exit 1
fi
if ! command -v gzip &> /dev/null; then
    echo "gzip is not installed. Please install gzip to run this script."
    exit 1
fi
if [ ! -f webin-cli-*.jar ]; then
    echo "Webin-CLI JAR file is not installed. Please install it to run this script."
    echo "Download it from https://github.com/enasequence/webin-cli/releases"
    exit 1
else
    echo "Webin-CLI command line submission interface found."
    WEBIN_CLI=$(ls webin-cli-*.jar)
    echo "Using Webin-CLI: $WEBIN_CLI"
fi

# CHECKING INPUT FILES
# Check if the credential file exists
if [ ! -f "$CREDENDIAL" ]; then
    echo "Credential file '$CREDENDIAL' not found!"
    exit 1
else
    echo "Credential file '$CREDENDIAL' found."
fi

# Check if the manifest file exists 
if [ ! -f "$MANIFEST" ]; then
    echo "ERROR: Manifest file '$MANIFEST' not found!"
    exit 1
else
    echo "Manifest file '$MANIFEST' found."
    
    # Check if all mandatory fields are present in the manifest file
    MANDATORY_FIELDS=("STUDY" "SAMPLE" "ASSEMBLYNAME" "ASSEMBLY_TYPE" "COVERAGE" "PROGRAM" "PLATFORM")
    for field in "${MANDATORY_FIELDS[@]}"; do
        if ! grep -q "^$field" "$MANIFEST"; then
            echo "ERROR: mandatory field '$field' is missing in the manifest file!"
            exit 1
        fi
    done
    echo "All mandatory fields are present in the manifest file."
fi

# Check whether it is an unannotated or annotated genome
# This is an unannotated genome
if grep -q "^FASTA" "$MANIFEST"; then
    FASTA=$(grep "^FASTA" "$MANIFEST" | cut -f2)
    
    if [ ! -f "$FASTA" ]; then
        echo "ERROR: flatfasta file '$FASTA' not found!"
        exit 1
    fi
    
    echo "flat fasta file '$FASTA' found."
    
    if grep -q "^FLATFILE" "$MANIFEST"; then
        echo "ERROR: this is an unannotated genome!"
        echo "ERROR: no FLATFILE entry should be present in manifest file!"
        exit 1
    fi
else
    # This is an annotated genome
    # Check the presence of an embl flat file
    if grep -q "^FLATFILE" "$MANIFEST"; then
        FLATFILE=$(grep "^FLATFILE" "$MANIFEST" | cut -f2)
        if [ ! -f "$FLATFILE" ]; then
            echo "ERROR: embl flat file '$FLATFILE' not found!"
            exit 1
        else
            echo "embl flat file '$FLATFILE' found."
        fi
    else
        echo "ERROR: mandatory field 'FLATFILE' is missing in the manifest file!"
        exit 1
    fi
fi

# Check the presence of a chromosome file
if grep -q "^CHROMOSOME_LIST" "$MANIFEST"; then
    CHROMOSOME_FILE=$(grep "^CHROMOSOME_LIST" "$MANIFEST" | cut -f2)
    if [ ! -f "$CHROMOSOME_FILE" ]; then
        echo "ERROR: chromosome file '$CHROMOSOME_FILE' not found!"
        exit 1
    else
        echo "Chromosome file '$CHROMOSOME_FILE' found."
    fi
fi

# IMPORT CREDENTIALS
read user pass < $CREDENDIAL

#===============================================================================
# ENA SUBMISSION 
#===============================================================================

if [ "$TEST" = true ]; then
    echo "Running in test mode. No files will be submitted."
    # Simulate the submission process without actually submitting files
    java -jar $WEBIN_CLI -context genome -manifest $MANIFEST -username $user -password $pass -validate 
    echo "Test mode completed. No files were submitted."
    exit 0
else
    echo "Running in production mode. Files will be submitted."
    # Validate and submit the files
    java -jar $WEBIN_CLI -context genome -manifest $MANIFEST -username $user -password $pass -submit
    echo "Submission completed."
fi
