nextflow.enable.dsl = 2

input_ch = Channel.fromPath( params.input )
idx_ch   = Channel.fromPath( params.idx )

process VEP {
    debug true
    tag "Bicienzo"
    container 'europe-west1-docker.pkg.dev/ngdx-nextflow/wes/vep:rxxx'
    publishDir "$params.outdir" , mode: 'copy',
    saveAs: {filename ->
            if (filename.indexOf(".maf")       > 0) "MAF/$filename"
    }

    input:
    path(vcf)
    path(idx_ch)

    output:
    path("*maf")


    script:
    def vcf2maf = "/opt/vcf2maf/vcf2maf_mod.pl"
    def vep = "/opt/ensembl-vep/"
    """
    perl $vcf2maf \
        --input-vcf $vcf \
        --output-maf Bicienzo.maf \
        --vep-path $vep \
        --ncbi-build GRCh38 \
        --tumor-id Bicienzo \
        --vcf-tumor-id Bicienzo \
        --ref-fasta ${idx_ch}/*.fna
    """

}

workflow NEGEDIA {

    VEP( input_ch, idx_ch )

}

workflow {
    NEGEDIA()
}