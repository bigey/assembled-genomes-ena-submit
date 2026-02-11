# A Quick Guide to Submitting Genome Assemblies to ENA Using the Webin CLI

This document is a quick guide that provides instructions on how to submit genome assemblies to the European Nucleotide Archive (ENA) using the Webin command line submission interface with. For complete information, please refer to the [ENA documentation](https://ena-docs.readthedocs.io/en/latest/submit/assembly.html).

## Prerequisites

1. You must have a valid Webin account (login:`Webin-xxxxxx`).
2. Each submission must be associated with a pre-registered study (`PRJEBxxxxxx` BioProject accession) and a sample (`SAMEAxxxxxx` BioSample accession).
3. If you are submitting an **annotated** assembly, consider registering a [locus tag](https://ena-docs.readthedocs.io/en/latest/faq/locus_tags.html) prefix.

Then prepare the following files:

## Manifest file, **mandatory**

This is the main file that contains all the metadata about the genome assembly. The file is a tab-separated (TSV) text file with two columns. A template is available in this repository.

The following metadata fields are supported in the manifest file for genome context:

Mandatory fields:
`
+ `STUDY`: Study accession - **mandatory**, preregistered study (starts with `PRJEBxxxxxx` and is called the BioProject accession)
+ `SAMPLE`: Sample accession - **mandatory**, preregistered sample (starts with `SAMEAxxxxxx` and is called the BioSample accession)
+ `ASSEMBLYNAME`: Unique assembly name, user-provided - **mandatory**
+ `ASSEMBLY_TYPE`: "clone" (cloned DNA fragments, not directly from a whole organism) or "isolate" (cultured organism derived from a single strain/colony) - **mandatory**
+ `COVERAGE`: The estimated depth of sequencing coverage - **mandatory**
+ `PROGRAM`: The assembly program - **mandatory**
+ `PLATFORM`: The sequencing platform, or comma-separated list of platforms - **mandatory**

Optional fields:

+ `MOLECULETYPE`: "genomic DNA", "genomic RNA" or "viral cRNA" - **optional**
+ `MINGAPLENGTH`: Minimum length of consecutive Ns to be considered a gap in scaffolds - **optional**
+ `DESCRIPTION`: Free text description of the genome assembly - **optional**
+ `RUN_REF`: Comma separated list of run accession(s) - **optional**
+ `AGP`: file that describes the assembly of scaffolds from contigs, or of chromosomes from scaffolds - **optional**

Assembly specifics fields:

+ `FASTA`: file containing the sequences in FASTA format - **mandatory** for **unannotated** assembly (see below)
+ `FLATFILE`: file containing the sequences in EMBL flat file format - **mandatory** for **annotated** assembly (see below)
+ `CHROMOSOME_LIST`: file containing the list of chromosomes - **mandatory** for fully assembled chromosomes (see below)

In principle, the FASTA and FLATFILE metadata are mutually exclusive.

## FASTA file for **unannotated** assemblies

The FASTA flat file is mandatory for **unannotated** assemblies.  It is obtained by concatenating the individual FASTA files and should be compressed with gzip.

To obtain the FASTA file use this command:

```sh
cat *.fasta | gzip -c > flat-file.fasta.gz
```

Then add this line to the manifest file:

    FASTA<tab>flat-file.fasta.gz

## EMBL file for **annotated** assemblies

The EMBL flat file is mandatory for **annotated** assemblies. It is obtained by concatenating the individual EMBL files and should be compressed with gzip.

To obtain the EMBL flat file use this command:

```sh
cat *.embl | gzip -c > flat-file.embl.gz
```

Then add this line to the manifest file:

    FLATFILE<tab>flat-file.embl.gz

## Chromosome file for fully assembled **chromosomes**

The chromosome file is required for fully assembled **chromosomes**.

The file contains the list of chromosomes (one per line) to be submitted in a tab-separated (TSV) format containing three or four columns. A template is available in this repository. This file must be compressed with gzip.


Columns:

1. Sequence ID: unique sequence name, in FASTA file this is the sequence ID (e.g. ">ID"), in EMBL file this is the accession (e.g. "AC   xxxx")
2. Chromosome name: the name of the chromosome, e.g. "A"
3. Chromosome topology and type: [linear, circular] and type [chromosome, plasmid, or other]: e.g. "linear-chromosome" or "circular-chromosome"
4. Chromosome location (optional fourth column): e.g. "Mitochondrion"

Compress the file with gzip:

```sh
gzip chromosome-list.tsv
```

Then add this line to the manifest file:

    CHROMOSOME_LIST<tab>chromosome-list.tsv.gz

## Obtain the executable Webin Java file

The latest version of the Webin command line submission interface (Webin-CLI) can be downloaded from [GitHub](https://github.com/enasequence/webin-cli/releases)

## Submitting the assembly

When you are ready, submit your files using your login credentials (login:`Webin-XXXXX` and password:`YYYYYYY`).

Run the following command to validate your submission files:

```sh
java -jar webin-cli-x.y.z.jar -username Webin-XXXXX -password YYYYYYY -context genome -manifest manifest.tsv -validate
```

If all is ok, submit your assembly:

```sh
java -jar webin-cli-x.y.z.jar -username Webin-XXXXX -password YYYYYYY -context genome -manifest manifest.tsv -submit
```

## Additional script to submit the assembly

The script `annotated-sequences-submit.sh` can be used to submit the assembly to the testing or submission server. First, complete the manifest file (TSV) and create the flat files with the required information (see above). A credential file containing your login (`Webin-XXXXX`) and password (`YYYYYYY`) separated by a space is required.

The script performs the following steps:

1. Validates the submission files.
2. Submits the assembly to the submission server.

Edit the parameters at the beginning of the script to set the `PRODUCTION`, `CREDENTIAL`, and `MANIFEST` variables:

```sh
# Submit or test?
# One of the following:
# "true": real data submission,
# "false": submit to testing server, validation only
SUBMISSION="false"

# CREDENTIAL FILE
# File containing the credentials. 
# One line containing: 
# username password, separated by a space
CREDENTIAL=".credential"

# MANIFEST FILE
# The manifest file that contains the metadata about the genome assembly.
# The file is a tab-separated (TSV) text file with two columns.
MANIFEST="manifest.tsv"
```

Then, run the script with the following command:

```sh
./annotated-sequences-submit.sh
```

## How to report issues?

We welcome you to report any [issues](https://github.com/bigey/assembled-genomes-ena-submit/issues) in this document or script.

## Citing

If you use this document or script in your research, please cite:

BibTeX

```bibtex
@misc{bigey2026,
  author       = {Bigey, Frédéric},
  title        = {A Quick Guide to Submitting Genome Assemblies to ENA Using the Webin CLI},
  year         = {2026},
  howpublished = {\url{https://github.com/bigey/assembled-genomes-ena-submit}},
  note         = {accessed 2026-02-11}
}
```
Biblatex

```biblatex
@software{bigey2026,
  author       = {Bigey, Frédéric},
  title        = {A Quick Guide to Submitting Genome Assemblies to ENA Using the Webin CLI},
  year         = {2026},
  version      = {v1.2.0},
  url          = {https://github.com/bigey/assembled-genomes-ena-submit},
  note         = {accessed 2026-02-11}
}
```
