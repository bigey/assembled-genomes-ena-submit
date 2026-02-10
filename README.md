
# assembled-genomes-ena-submit

Genome assemblies can be submitted to the European Nucleotide Archive (ENA) using the Webin command line submission interface with `-context genome` option.

Each submission must be associated with a pre-registered study and a sample.

The set of files that are part of the submission are specified using a manifest file.

## mandatory MANIFEST FILE

The manifest file contains metadata about the genome assembly. The file is a tab-separated (TSV) text file with two columns.

The following metadata fields are supported in the manifest file for genome context:

Mandatory columns:

+ STUDY: Study accession - **mandatory**, preregistered study (starts with PRJEB and is called the BioProject accession)
+ SAMPLE: Sample accession - **mandatory**, preregistered sample (starts with SAMN and is called the BioSample accession)
+ ASSEMBLYNAME: Unique assembly name, user-provided - **mandatory**
+ ASSEMBLY_TYPE: "clone" or "isolate" - **mandatory**
+ COVERAGE: The estimated depth of sequencing coverage - **mandatory**
+ PROGRAM: The assembly program - **mandatory**
+ PLATFORM: The sequencing platform, or comma-separated list of platforms - **mandatory**

Optional columns:

+ MOLECULETYPE: "genomic DNA", "genomic RNA" or "viral cRNA" - optional
+ MINGAPLENGTH: Minimum length of consecutive Ns to be considered a gap - optional
+ DESCRIPTION: Free text description of the genome assembly - optional
+ RUN_REF: Comma separated list of run accession(s) - optional
+ AGP: file that describes the assembly of scaffolds from contigs, or of chromosomes from scaffolds - optional

Assembly specifics columns:

+ FASTA: file containing the sequences in FASTA format - **mandatory** for **unannotated** assembly (see below)
+ FLATFILE: file containing the sequences in EMBL flat file format - **mandatory** for **annotated** assembly (see below)
+ CHROMOSOME_LIST: file containing the list of chromosomes - **mandatory** for fully assembled chromosomes (see below)

## FASTA FILE for unannotated assemblies

The FASTA flat file is mandatory for **unannotated** assemblies.  It is obtained by concatenating the individual FASTA files and should be compressed with gzip.

To obtain the FASTA file use this command:

```sh
cat *.fasta | gzip -c > flat-file.fasta.gz
```

Then add this line to the manifest file:

    FASTA<tab>flat-file.fasta.gz

## EMBL FLATFILE for annotated assemblies

The EMBL flat file is mandatory for **annotated** assemblies. It is obtained by concatenating the individual EMBL files and should be compressed with gzip.

To obtain the EMBL flat file use this command:

```sh
cat *.embl | gzip -c > flat-file.embl.gz
```

Then add this line to the manifest file:

    FLATFILE<tab>flat-file.embl.gz

## CHROMOSOME LIST FILE

The chromosome list file is **mandatory** only for fully assembled chromosomes. The file contains the list of chromosomes to be submitted.

It is a tab-separated (TSV) text file up to four columns, and must be compressed with gzip.

Columns:

1. Sequence ID: unique sequence name, in FASTA file this is the ID (">ID") or in EMBL flat file this is the accession ("AC   ID"), e.g. "chromA"
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

The latest version of the Webin-CLI can be downloaded from [GitHub][github]

[github]: https://github.com/enasequence/webin-cli/releases
