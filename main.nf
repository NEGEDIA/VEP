nextflow.enable.dsl = 2

input_ch = Channel.fromPath( params.input )

process VEP {
    debug true
    tag "$sample_id"
    container 'gcr.io/ngdx-cloud-resources/wes:vepdata'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf(".maf")       > 0) "MAF/$filename"
    }

    input:
    path(vcf)

    output:
    path("*maf")


    script:
    """
    perl $vcf2maf --input-vcf !{idSample}_DNAhaplotyper2.vcf --output-maf !{idSample}.maf --vep-path $vep --ncbi-build $build --tumor-id !{idSample} --vcf-tumor-id !{idSample} --ref-fasta !{genome}/*.fna
    """

}

workflow NEGEDIA {

    VEP( input_ch )

}

workflow {
    NEEGDIA()
}