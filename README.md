
# assembled-genomes-ena-submit

Scripts used for the submisssion of assembled genomes to ENA repository

## MANIFEST FILE

The manifest file contains metadata about the genome assembly. The file is a tab-separated text file with two columns (first column -> second column).

The following metadata fields are supported in the manifest file for genome context:

+ STUDY: Study accession - mandatory
+ SAMPLE: Sample accession - mandatory
+ ASSEMBLYNAME: Unique assembly name, user-provided - mandatory
+ ASSEMBLY_TYPE: "clone" or "isolate" - mandatory
+ COVERAGE: The estimated depth of sequencing coverage - mandatory
+ PROGRAM: The assembly program - mandatory
+ PLATFORM: The sequencing platform, or comma-separated list of platforms - mandatory
+ MOLECULETYPE: "genomic DNA", "genomic RNA" or "viral cRNA" - optional
+ MINGAPLENGTH: Minimum length of consecutive Ns to be considered a gap - optional
+ DESCRIPTION: Free text description of the genome assembly - optional
+ RUN_REF: Comma separated list of run accession(s) - optional
+ AGP: file that describes the assembly of scaffolds from contigs, or of chromosomes from scaffolds - optional
+ FLATFILE: file containing the sequences in EMBL flat file format - mandatory for annotated assembly (see below)
+ CHROMOSOME_LIST: file containing the list of chromosomes - mandatory for fully assembled chromosomes (see below)

```{}
MANIFEST="manifest.tsv"
```

## EMBL FLATFILE

The EMBL flat file is mandatory for annotated assemblies.

It is obtained by concatening of the individual EMBL files and should be compressed with gzip.

To obtain the EMBL flat file use this command:

```{sh}
cat *.embl | gzip -c > flat-file.embl.gz
```

Then add this line to the manifest file:

```{}
FLATFILE flat-file.embl.gz
```

## CHROMOSOME LIST FILE

The chromosome list file is optional and is only required for fully assembled chromosomes. The file contains the list of chromosomes to be submitted.

It is a tab-separated text file up to four columns, and must be compressed with gzip.

Columns:

1. Sequence ID: unique sequence name, in FASTA file this is the ID (">ID") or in EMBL flat file this is the accession ("AC   ID"), e.g. "chromA"
2. Chromosome name: the name of the chromosome, e.g. "A"
3. Chromosome topology [linear, circular] and type [chromosome, plasmid, or other]: e.g. "linear-chromosome"
4. Chromosome location (optional): e.g. "Mitochondrion"

Then add this line to the manifest file:

```{}
CHROMOSOME_LIST chromosome-list.tsv.gz
```

## Obtain the executable Java JAR file

The latest version of the Webin-CLI can be downloaded from [GitHub][github]

[github]: https://github.com/enasequence/webin-cli/releases
