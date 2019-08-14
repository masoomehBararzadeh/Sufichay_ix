# Multiple run script
# source( paste( Sys.getenv("INDUS_IX_PATH"), 'multiple_scenario.r', sep = '/' ) )
# ## NEW RUN
# rm( list = ls( ) )
# 
# # SSP being analyzed
# SSP = 'SSP2'
# 
# # Climate model analyzed
# climate_model = 'ensemble'
# climate_scenario = 'rcp60'
# 
# ENV_FLOWS = T       # Environmental flows
# IND_TREAT = T       # Indus Treaty
# SDG6 = F            # SDG6
# EMISS = F          # GhG Emission
# SDG7 = F        # SDG7: solar/wind targets + phase out of oc
# SDG2 = F        # SDG2 Food and land
# GROUNDWAT = T       # groundwater extraction bounds
# RELAX_LAND = T      # relax land availability constraint (x100 land)
# END_FOOD_IMPORT = F
# END_FOOD_EXPORT = F
# 
# 
# policy_option = paste0('_EF.',substr(ENV_FLOWS, 1,1),'_IT.',substr(IND_TREAT, 1,1),'_EM.',substr(EMISS, 1,1),
#                        '_S6.',substr(SDG6, 1,1),'_S7.',substr(SDG7, 1,1),'_S2.',substr(SDG2, 1,1))
# 
# scname = paste0('baseline',policy_option)
# 
# source( paste( indus_ix_path, 'basin_msggdx.r', sep = '/' ) ) 

################################
######## multiple run ##########
################################
require( raster )
require(dplyr)
require(tidyr)
indus_ix_path = Sys.getenv("INDUS_IX_PATH")

# in first column write the scenario names
policy_settings.df = data.frame(scen_name = c('baseline0','env_flow_5%','env_flow_10%', 'env_flow_20%', 'env_flow_30%')
                                ,stringsAsFactors = F) %>% 
  mutate( SSP =              c('SSP2','SSP2','SSP2','SSP2','SSP2'),
          climate_model =    c('ensemble','ensemble','ensemble','ensemble','ensemble'),
          climate_scenario = c('rcp60','rcp60','rcp60','rcp60','rcp60'),
          REDUCE_RUNOFF =    c( T, T, T, T, T ),
          ENV_FLOWS =        c( F, F, F, F, F ),
          IND_TREAT =        c( T, T, T, T, T ),    
          SDG6 =             c( F, F, F, F, F ),            # SDG6 
          EMISS =            c( F, F, F, F, F ),          # GhG Emission 
          SDG7 =             c( F, F, F, F, F ),        # SDG7: solar/wind targets + phase out of oc 
          SDG2 =             c( F, F, F, F, F ),        # SDG2 Food and land 
          GROUNDWAT =        c( F, T, T, T, T ),       # groundwater extraction bounds 
          RELAX_LAND =       c( F, F, F, F, F ),      # relax land availability constraint (x100 land) 
          END_FOOD_IMPORT =  c( F, F, F, F, F ), 
          END_FOOD_EXPORT =  c( F, F, F, F, F ),
          FIX_ELEC_IMPORT =  c( F, T, T, T, T ),
          SURFACE_ALLOCATION =c(F, T, T, T, T ),
          LIMIT_IO         = c( F, F, F, F, F ),
          SMART_IRR_WATER = c('0' ,'0' ,'0','0' ,'0' ),
          RAINFED_LAND   =  c('20' ,'20' ,'20','20' ,'20'),
          ENV_FLOWS1 =       c( '0','1.05', '1.1', '1.2', '1.3'),
          NOT_PLANNED_HYDRO = c(F, F, F, F, F  ),
          FULL_COOPERATION = c(F, F, F, F, F)
  ) %>% 
  gather(key,value,2:length(.))

# policy_settings.df = policy_settings.df %>% filter(scen_name == 'multiple_SDG')
# sc = (unique(policy_settings.df$scen_name ))[1]
for( sc in (unique(policy_settings.df$scen_name )) ) { 
  rm(list=setdiff(ls(), c("policy_settings.df",'sc','indus_ix_path') ) )
  
  # assign 
  for( nnn in ( policy_settings.df$key ) ){ 
    if (!is.na(as.logical((policy_settings.df %>% filter(scen_name == sc, key == nnn))$value ) ) ) {
      assign( nnn, as.logical((policy_settings.df %>% filter(scen_name == sc, key == nnn))$value ) ) }
    else {assign( nnn, as.character((policy_settings.df %>% filter(scen_name == sc, key == nnn))$value ) ) }
  } 
  
  
  # to be saved in the data gdx name
  policy_option = paste0('_EF.',substr(ENV_FLOWS, 1,1),'_IT.',substr(IND_TREAT, 1,1),'_EM.',substr(EMISS, 1,1), 
                         '_S6.',substr(SDG6, 1,1),'_S7.',substr(SDG7, 1,1),'_S2.',substr(SDG2, 1,1),'_EF1.',substr(ENV_FLOWS1, 1,1)) 
  baseline = 'baseline0'
  data_gdx = paste0(sc,policy_option)
  shiny_mode = F
  Beta_water = 1
  source( paste( indus_ix_path, 'basin_msggdx.r', sep = '/' ) ) 
  
}


