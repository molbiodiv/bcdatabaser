[back to the index](./index.md)

  # Web interface
 {:.no_toc}

  * TOC list
 {:toc}

  ## Access
 The webinterface is available at: [bcdatabaser.molecular.eco](https://bcdatabaser.molecular.eco)

  ## Searching for exisiting datasets 
 You might find already created databases for your given research question. 
 The search interface on the left hand side allows a quick scan for previous requests, alongside statistical information.
 [!Searching](https://i.ibb.co/z8j66cd/Bildschirmfoto-2019-10-31-um-14-10-00.png)
 This is possible without logging in with an ORCID.

  ## Creating new databases
 ### ORCID
 The web interface requires authentification using an [ORCID](https://orcid.org) to associate your requests and final datasets with your account. 

  ### Parameters

  Most of the parameters are set to a default in the web-interface. If you need more flexibility, please check the [command line version](./cmd.md).

  **Fixed parameters:**
 * ```--check-tax-names``` If your taxa restriction file contains taxa not supported in the NCBI taxonomy, the tool is unable to search for sequences of this taxon. The web interface automatically halts in this situation, so that you are aware of this situation.
 * ```--sequences-per-taxon=9``` Several taxa, e.g. model taxa, often have several hundreds of sequences deposited, which usually do not carry new information and are redundant. This parameter will select only the 9 longest sequences available, given below length restriction.
 * ```--sequence-length-filter=100:2000``` Most barcoding studies use small or average read length, given technological restrictions (e.g. Sanger, Illumina). With this range this we exclude longer sequences, as e.g. whole genome sequences that could cause trouble by false random assignments.

  **Required parameters:**
 * **Search String:** This string searches for the marker of interest. You can search for multiple arguments using ```"OR"```, be aware though that the first argument will determine the output name. e.g. ```COI OR CO1 OR 'Cytochrome oxidase 1' OR 'Cytochrome oxidase I'```

  **Optional parameters:**
 * **Taxonomic Range:**  Only child taxa of this will be considered (case sensitive), e.g. ```Viridiplantae``` or ```Brassica```
 * **Taxa List:** You can supply a file list with taxa names, with each line a new taxon. The sequence selection will be restricted to these groups. This can contain species names, or also higher taxonomic ranks, e.g.
 ```
 Brassica napus
 Bellis
 Poaceae
 ```

 
  ### Request queue

  Requests are handled in order of their submission, meaning that your job may start immediately or delayed. 
 You can check the status at the bottom of the page
 ![queue](https://i.ibb.co/41zLmYz/Bildschirmfoto-2019-10-31-um-14-15-46.png)

 ![success](https://img.shields.io/badge/job-success-brightgreen.svg) the job was successfully finished, you can find the results on the right side added to previous results.
 ![running](https://img.shields.io/badge/job-running-blue.svg) this job is currently worked on
 ![queue](https://img.shields.io/badge/job-queued-yellow.svg) this job is waiting for other jobs to be completed before it is started
 ![fail](https://img.shields.io/badge/job-fail-red.svg) this job failed. It may be due to several reasons, connection issues or taxa were not found. Pleas check the ```Details``` page and feel free to open an issue in case you can not interpret the error.

  ### Download

  You will find the download, DOI and citation information with your name as database author on [Zenodo](Zenodo.org)

  ![Zenodo](https://i.ibb.co/RgDQ861/Bildschirmfoto-2019-10-31-um-14-13-06.png)
