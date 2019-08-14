

## Generates input data files for MESSAGE-Basin
## Some scripts need to run sequentially while others could be run in parallel
basin = 'Sufi_chai'
require( tictoc )

# Files ordered accordingly
files = c( 	'delineation',
			'renewable_exclusion_zones',
			'load_factor',
			'capacity_factor_final',
			'powerplants_historical_capacity',
			'fuel_cost',
			'storage_capacity',
			'demands',
			'water_connection',
			'diesel_pumps',
			'canal_transfers',
			'irrigation_transfers',
			'transmission',
			'water_table_depth',
			'freshwater_extraction',
			'water_resources',
			'crop_yields',
			'land_use_maps'
			)

res = lapply( files, function( fl ){
	
	print("##########################################")
	print( paste0( "Working on: ", fl ) )
	print("##########################################")
	
	setwd( Sys.getenv("Sufi_chai_IX_PATH") ) # Local location of indus ix model - MAKE SURE TO ADD TO SYSTEM ENVIRONMENT VARIABLES
	
	tic()
	
	source(  paste0( 'input_data_scripts/', fl, '.r' ) )

	gc()
	
	h = toc()
	
	rr = paste0( as.character( round( unlist( h$toc-h$tic ) ) ), ' sec' )
	
	return( rr ) # return the time it takes to run each data processing script
	
	} )
	
names( res ) = files			
			
      