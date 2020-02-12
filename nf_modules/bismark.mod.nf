nextflow.preview.dsl=2

params.bismark_args = ''

// We need to replace single quotes in the arguments so that they are not getting passed in as a single string
bismark_args = params.bismark_args.replaceAll(/'/,"")
println ("[BISMARK MODULE, replaced] ARGS ARE: " + bismark_args)

process BISMARK {
	label 'bigMem'
	label 'multiCore'
		
    input:
	    tuple val(name), path(reads)

	output:
	    path "*bam",        emit: bam
		path "*stats.txt",  emit: stats 
		path "*report.txt", emit: report

    script:
	cores = 8
	readString = ""

	// Options we add are
	bismark_options = bismark_args
	bismark_options = bismark_options + ""
	
	if (reads instanceof List) {
		readString = "-1 "+reads[0]+" -2 "+reads[1]
	}
	else {
		readString = "-U "+reads
	}

	index = " --genome " + params.genome["bismark"]
	bismark_name = name + "_" + params.genome["name"]

	"""
	module load bismark
	bismark ${index} ${bismark_options} ${readString}  2>${bismark_name}_bismark_stats.txt
	"""

}