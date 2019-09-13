
# Run from the R console using:
# source( paste( Sys.getenv("Sufi_chai_IX_PATH"), 'basin_msggdx.r', sep = '/' ) )

##### INITIALIZE #####

options( java.parameters = "-Xmx16g" )

print( 'Initializing functions and data' )

#rm( list = ls( ) )
graphics.off( )
require( raster )
require( dplyr )
require( tidyr )
require( rgdal )
require( tictoc )
require( maptools )
require( rgeos )


#### Initialization / Model setup #####

tic()

# Location of input data
setwd( 'C:/Users/bararzadeh/Documents/Github/Sufichay_ix' )

# Use ixmp? Takes time to upload - can choose option to debug w/o ixmp
use_ixmp = FALSE

# Local location of sufi_chai ix model - MAKE SURE TO ADD TO SYSTEM ENVIRONMENT VARIABLES
Sufichay_ix_path = 'C:/Users/bararzadeh/Documents'

# Location of GAMS - need to add to system environemtn variables but can't change from remote desktop :(
gams_path = 'C:/GAMS/win64/24.9'

# Basin analyzed
basin = 'Sufichay'
# 
# # SSP being analyzed
# SSP = 'SSP2'
# 
# # Climate model analyzed
# climate_model = 'ensemble'
# climate_scenario = 'rcp60'

# Time steps
year = c( seq( 1990, 2010, by = 10  ), 2015, seq( 2020, 2060, by = 10 ) ) 
time =  as.character( ( seq(1, 12, by = 1 ) ) ) # monthly time steps
year_all = year
baseyear = 2016 # last historical year
lastyear = last(year_all)

# load data inputs
source( paste(  Sufichay_ix_path,'Sufichay_ix-master', 'basin_msggdx_load_inputs.r', sep = '/' ), verbose = FALSE ) 

# load technology parameters using 'basin_msggdx_technologies.r' and add to formatted list
source( paste( Sufichay_ix_path, 'basin_msggdx_technologies.r', sep = '/' ) ) 

# Set the technologies to add to the GDX - ! needs to match what's defined in 'basin_msggdx_technologies.r' !
technology.set = c( 
					'geothermal_cl',
					'solar_pv_1',
					'solar_pv_2',
					'solar_pv_3',
					'wind_1',
					'wind_2',
					'wind_3',
					'hydro_old',
					'hydro_river',
					'hydro_canal',
					'electricity_distribution_urban',
					'electricity_distribution_rural',
					'electricity_distribution_sufi_chaitry',
					'electricity_distribution_irrigation',
					'electricity_short_strg', 
					routes_names,
					exp_routes_names,
					'gw_extract',
					'renew_gw_extract',
					'urban_sw_diversion',
					'urban_gw_diversion',
					'urban_piped_distribution',
					'urban_unimproved_distribution',
					'urban_wastewater_collection',
					'urban_wastewater_release',
					'urban_wastewater_treatment',
					'urban_wastewater_recycling',
					'urban_wastewater_irrigation',
					'rural_sw_diversion',
					'rural_gw_diversion',
					'rural_piped_distribution',
					'rural_unimproved_distribution',
					'rural_wastewater_release',
					'rural_wastewater_treatment',
					'rural_wastewater_recycling',
					'rural_wastewater_collection',
					'irrigation_sw_diversion',
					'irrigation_gw_diversion',
					'smart_irrigation_sw_diversion',
					'smart_irrigation_gw_diversion',
					'energy_sw_diversion',
					'energy_gw_diversion',
					'environmental_flow',
					'surface2ground',
					'ground2surface',
					river_names,
					canal_names,
					crop_tech_names,
					rainfed_crop_names,
					irr_tech_names,
					'fallow_crop',
					'solid_biom',
					'ethanol_prod',
					'ethanol_genset',
					'ethanol_agri_genset',
					'irri_diesel_genset',
					'agri_diesel_genset',
					'agri_pv'
					)				
				
# Generate data frames for the parameters and sets to pass to ixmp			
source( paste( Sufichay_ix_path, 'basin_msggdx_setpardef.r', sep = '/' ) )		
		
# Additional policies
source( paste( Sufichay_ix_path, 'basin_msggdx_policies.r', sep = '/' ) )	
		
toc() # finished loading data		

#### SOLVE  ######

# name of scenario
#scname = 'test'

# if using ixmp, upload data and solve

	print( 'Output to GDX with gdxrrw' )

tic()
source( paste( Sufichay_ix_path, 'basin_msggdx_gdxrrw.r', sep = '/' ) )
toc()	

tic()
source( paste( Sufichay_ix_path, 'basin_msggdx_solve.r', sep = '/' ) )
toc()
	
	print( paste0( sc, ' ---> scenario finished' ) )
#### RUN DIAGNOSTICS
tic()
print( 'Running diagnostics' )
source( paste( Sufichay_ix_path, 'basin_msggdx_diagnostics.r', sep = '/' ) )
toc()
#### FIN #####

print( 'Scenario finished' )

