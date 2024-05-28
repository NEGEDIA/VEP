nextflow.enable.dsl = 2

input_ch = Channel.fromPath( params.input )

process VEP {
    debug true
    tag "$sample_id"
    container ''
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf(".html")       > 0) "fastqc/TrimQC/$filename"
       else if (filename.indexOf(".zip")        > 0) "fastqc/TrimQC/zip/$filename"
       else if (filename.indexOf(".fastq.gz")   > 0) "SOAPnuke/$filename"
       else if (filename.indexOf("txt")         > 0) "SOAPnuke/txt/$filename"
       else null
    }

}

workflow NEGEDIA {

}

workflow {
    NEEGDIA()
}