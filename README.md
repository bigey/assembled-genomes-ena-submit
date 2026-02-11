
# assembled-genomes-ena-submit

Genome assemblies can be submitted to the European Nucleotide Archive (ENA) using the Webin command line submission interface with `-context genome` option.

## Prerequisites

1. You must have a valid Webin account (login: Webin-xxxxxx).
2. Each submission must be associated with a pre-registered study (PRJEBxxxxxx BioProject accession) and a sample (SAMEAxxxxxx BioSample accession).
3. Consider registering a [locus tag](https://ena-docs.readthedocs.io/en/latest/faq/locus_tags.html) prefix if you are submitting an annotated assembly.
3. The set of files that are required for a submission are specified using a manifest file (see below).

## MANIFEST file, **mandatory**

The manifest file contains metadata about the genome assembly. The file is a tab-separated (TSV) text file with two columns.

The following metadata fields are supported in the manifest file for genome context:

Mandatory columns:

+ STUDY: Study accession - **mandatory**, preregistered study (starts with PRJEBxxxxxx and is called the BioProject accession)
+ SAMPLE: Sample accession - **mandatory**, preregistered sample (starts with SAMEAxxxxxx and is called the BioSample accession)
+ ASSEMBLYNAME: Unique assembly name, user-provided - **mandatory**
+ ASSEMBLY_TYPE: "clone" or "isolate" - **mandatory**
+ COVERAGE: The estimated depth of sequencing coverage - **mandatory**
+ PROGRAM: The assembly program - **mandatory**
+ PLATFORM: The sequencing platform, or comma-separated list of platforms - **mandatory**

Optional columns:

+ MOLECULETYPE: "genomic DNA", "genomic RNA" or "viral cRNA" - **optional**
+ MINGAPLENGTH: Minimum length of consecutive Ns to be considered a gap - **optional**
+ DESCRIPTION: Free text description of the genome assembly - **optional**
+ RUN_REF: Comma separated list of run accession(s) - **optional**
+ AGP: file that describes the assembly of scaffolds from contigs, or of chromosomes from scaffolds - **optional**

Assembly specifics columns:

+ FASTA: file containing the sequences in FASTA format - **mandatory** for **unannotated** assembly (see below)
+ FLATFILE: file containing the sequences in EMBL flat file format - **mandatory** for **annotated** assembly (see below)
+ CHROMOSOME_LIST: file containing the list of chromosomes - **mandatory** for fully assembled chromosomes (see below)

## FASTA flat file for unannotated assemblies

The FASTA flat file is mandatory for **unannotated** assemblies.  It is obtained by concatenating the individual FASTA files and should be compressed with gzip.

To obtain the FASTA file use this command:

```sh
cat *.fasta | gzip -c > flat-file.fasta.gz
```

Then add this line to the manifest file:

    FASTA<tab>flat-file.fasta.gz

## EMBL flat file for annotated assemblies

The EMBL flat file is mandatory for **annotated** assemblies. It is obtained by concatenating the individual EMBL files and should be compressed with gzip.

To obtain the EMBL flat file use this command:

```sh
cat *.embl | gzip -c > flat-file.embl.gz
```

Then add this line to the manifest file:

    FLATFILE<tab>flat-file.embl.gz

## CHROMOSOME list file

The chromosome list file is **mandatory** only for fully assembled chromosomes. The file contains the list of chromosomes to be submitted.

It is a tab-separated (TSV) text file up to four columns, and must be compressed with gzip.

Columns:

1. Sequence ID: unique sequence name, in FASTA file this is the sequence ID (e.g. ">ID"), in EMBL file this is the accession (e.g. "AC   xxxx")
2. Chromosome name: the name of the chromosome, e.g. "A"
3. Chromosome topology: [linear, circular] and type [chromosome, plasmid, or other]: e.g. "linear-chromosome"
4. Chromosome location (optional column): e.g. "Mitochondrion"

Compress the file with gzip:

```sh
gzip chromosome-list.tsv
```

Then add this line to the manifest file:

    CHROMOSOME_LIST<tab>chromosome-list.tsv.gz

## Obtain the executable Java JAR file

The latest version of the Webin command line submission interface (Webin-CLI) can be downloaded from [GitHub][github]

[github]: https://github.com/enasequence/webin-cli/releases

To validate your submission files, run the following command:

```sh
java -jar webin-cli-x.y.z.jar -username Webin-XXXXX -password YYYYYYY -context genome -manifest manifest.tsv -validate
```

If all is ok, run the following command:

```sh
java -jar webin-cli-x.y.z.jar -username Webin-XXXXX -password YYYYYYY -context genome -manifest manifest.tsv -submit
```

## Script to submit the assembly

The script `annotated-sequences-submit.sh` can be used to submit the assembly to the testing or submission server. First, complete the manifest file (TSV) and create the flat files with the required information (see above). A credential file containing the login (Webin-XXXXX) and password is required.

The script performs the following steps:

1. Validates the submission files.
2. Submits the assembly to the testing or submission server based on the value of the `TEST` variable.

Edit the parameters at the beginning of the script to set the `TEST` variable, `CREDENTIAL` file, and `MANIFEST` file:

```sh
# TEST/SUBMIT YOUR DATA
# One of the following:
# "true": submit to testing server, 
# "false": real data submission
TEST="true"

# CREDENTIAL FILE
# File containing the credentials. 
# One line containing: 
# username password
CREDENTIAL=".credential"

# MANIFEST FILE
# The manifest file contains metadata about the genome assembly.
# The file is a tab-separated text file with two columns.
MANIFEST="manifest.tsv"
```

Then, run the script with the following command:

```sh
./annotated-sequences-submit.sh
```



