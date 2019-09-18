### UNITS
# Costs are in million USD2010 per year
# Water flows in million cubic meters per day (MCM/day)
# power flows in MW 
# land in Mha (million hectares)
# yields are in kton
# Note that most parameters are defined as rates as opposed to absolute volumes
# This avoids some of the headache associated with unequal timesteps (i.e., months)

# Power plant cost and performance data from Parkinson et al. (2016) - Impacts of groundwater constraints on Saudi Arabia's low-carbon electricity supply strategy
# Additional power plant technologies not included in Parkinson et al. (2016) are estimated from Black & Veatch (2012) "Cost and performance data for Power generation"
# Emission factors in metric tons per day per MW are default IPCC numbers or matched to MESSAGE IAM
# Fuel usage rates are estimated from the power plant heat rate
# flexibility rates for electricity technologies from Sullivan et al. (2013)
#Heating system_conventional
vtgs = year_all
nds = bcus
Heater =  list ( nodes = nds,
                        years = year_all,
                        times = time,
                        vintages = vtgs,	
                        types = c('heat'),
                        modes = c( 1),
                        lifetime = lft,
                                                                      mode = 1, 
                                                                      commodity = 'natural_gas',
                                                                      level='secondary_energy',
                                                                      value =  0.000166 ) ,
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                        ),
                       output= left_join(   expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   mode = 1, 
                                                   commodity = 'Heat', 
                                                   level = 'rural_final',
                                                   value = 1 ) ,
                                     vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),

                                            
                                            
                                            # data.frame( node,vintage,year_all,mode,emission) 
                                            emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                                  vintage = vtgs,
                                                                                                  mode = 1, 
                                                                                                  emission = 'CO2', 
                                                                                                  value = round( 1.86e-6 , digits = 5 ) ) ,
                                                                                     vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                          
                                                                          
                                                                          left_join( expand.grid( node = nds,
                                                                                                  vintage = vtgs,
                                                                                                  mode = 1, 
                                                                                                  emission = 'water_consumption', 
                                                                                                  value = 0 ) ,
                                                                                     vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                          
                                                                         
                                            # data.frame(node,vintage,year_all,time)
                                            capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                        vintage = vtgs,
                                                                                        value = 0.73) ,
                                                                          vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                            
                                            # data.frame( vintages, value )
                                            construction_time = expand.grid( 	node = nds,
                                                                              vintage = vtgs,
                                                                              value = 1	),
                                            
                                            # data.frame( vintages, value )
                                            technical_lifetime = expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               value = lft	),
                                            
                                            # data.frame( vintages, value )
                                            inv_cost = expand.grid( node = nds,
                                                                    vintage = vtgs,
                                                                    
                                                                    time = time,
                                                                    value = 0	),
                                            
                                            vtg_year_time ) %>% 
                          dplyr::select( node, vintage, year_all, mode, time, value ),
                        
                        # data.frame( node, vintages, year_all, value )
                        fix_cost = left_join( 	expand.grid( 	node = nds,
                                                             vintage = vtgs,
                                                             value = 0	),
                                               vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                        
                        # data.frame( node, vintage, year_all, mode, time, value ) 
                                                                                        time = time,
                 # data.frame( node, vintage, year_all, mode, time, value ) 
                 var_cost = bind_rows( 	
                                                   left_join( expand.grid( node = nds,
                                                     vintage = vtgs,
                                                     mode = 1 ),
                                        vtg_year_time ), 
                             fossil_fuel_cost_var %>% 
                               filter(commodity == "gas") %>% 
                               dplyr::select( year_all, value ) %>% 
                               mutate( value = 0.0075 )
                 ) %>% dplyr::select( node,  vintage, year_all, mode, time, value ) 
                 
                 )	
                                              # data.frame(node,vintage,year_all,value)
                                              min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                                                vintage = vtgs,
                                                                                                value = 0.7	),
                                                                                  vtg_year ) %>% dplyr::select( node, vintage, year_all, value )
                                              
                                              # data.frame(node,year_all,value)
                                              historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "Heating system_conventional",]
                                              
                                              # bound_new_capacity_up(node,inv_tec,year)
                                              bound_new_capacity_up = expand.grid( 	node = nds, year_all = c(2020,2030), value = 0.12	)
                                              
                                              # data.frame(node,inv_tec,year)
                                              growth_new_capacity_up = expand.grid( 	node = nds, year_all = c(2030,2040,2050,2060), value = 0.12	)
                     #Heating system_Hermetic
                                              vtgs = year_all
                                              nds = bcus
                                              Heater =  list ( nodes = nds,
                                                               years = year_all,
                                                               times = time,
                                                               vintages = vtgs,	
                                                               types = c('heat'),
                                                               modes = c( 1),
                                                               lifetime = lft,
                                                               
                                                               input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                                             vintage = vtgs,
                                                                                                             mode = 1, 
                                                                                                             commodity = 'natural_gas',
                                                                                                             level='secondary_energy',
                                                                                                             value =  0.000111 ) ,
                                                                                               vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                                                     dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                                               ),
                                                               left_join(   expand.grid( 	node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          commodity = 'Heat', 
                                                                                          level = 'rural_final',
                                                                                          value = 1 ) ,
                                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                                 dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                                               
                                                               
                                                               
                                                               # data.frame( node,vintage,year_all,mode,emission) 
                                                               emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                                                     vintage = vtgs,
                                                                                                                     mode = 1, 
                                                                                                                     emission = 'CO2', 
                                                                                                                     value = round( 1.86e-6 , digits = 5 ) ) ,
                                                                                                        vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                                             
                                                                                             
                                                                                             left_join( expand.grid( node = nds,
                                                                                                                     vintage = vtgs,
                                                                                                                     mode = 1, 
                                                                                                                     emission = 'water_consumption', 
                                                                                                                     value = 0 ) ,
                                                                                                        vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                                             
                                                                                             
                                                                                             # data.frame(node,vintage,year_all,time)
                                                                                             capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                                                                         vintage = vtgs,
                                                                                                                                         value = 0.73) ,
                                                                                                                           vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                                                                             
                                                                                             # data.frame( vintages, value )
                                                                                             construction_time = expand.grid( 	node = nds,
                                                                                                                               vintage = vtgs,
                                                                                                                               value = 1	),
                                                                                             
                                                                                             # data.frame( vintages, value )
                                                                                             technical_lifetime = expand.grid( 	node = nds,
                                                                                                                                vintage = vtgs,
                                                                                                                                value = lft	),
                                                                                             
                                                                                             # data.frame( vintages, value )
                                                                                             inv_cost = expand.grid( node = nds,
                                                                                                                     vintage = vtgs,
                                                                                                                     
                                                                                                                     time = time,
                                                                                                                     value = 3.6e-5	),
                                                                                             
                                                                                             vtg_year_time ) %>% 
                                                                 dplyr::select( node, vintage, year_all, mode, time, value ),
                                                               
                                                               # data.frame( node, vintages, year_all, value )
                                                               fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                                                    vintage = vtgs,
                                                                                                    value = 0	),
                                                                                      vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                                                               
                                                               # data.frame( node, vintage, year_all, mode, time, value ) 
                                                               time = time,
                                                               # data.frame( node, vintage, year_all, mode, time, value ) 
                                                               var_cost = bind_rows( 	
                                                                 left_join( expand.grid( node = nds,
                                                                                         vintage = vtgs,
                                                                                         mode = 1 ),
                                                                            vtg_year_time ), 
                                                                 fossil_fuel_cost_var %>% 
                                                                   filter(commodity == "gas") %>% 
                                                                   dplyr::select( year_all, value ) %>% 
                                                                   mutate( value = 0.0075 )
                                                               ) %>% dplyr::select( node,  vintage, year_all, mode, time, value ) 
                                                               
                                              )	
                                              # data.frame(node,vintage,year_all,value)
                                              min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                                                vintage = vtgs,
                                                                                                value = 0.7	),
                                                                                  vtg_year ) %>% dplyr::select( node, vintage, year_all, value )
                                              
                                              # data.frame(node,year_all,value)
                                              historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "Heating system_Hermetic",]
                                              
                                              # bound_new_capacity_up(node,inv_tec,year)
                                              bound_new_capacity_up = expand.grid( 	node = nds, year_all = c(2020,2030), value = 0.12	)
                                              
                                              # data.frame(node,inv_tec,year)
                                              growth_new_capacity_up = expand.grid( 	node = nds, year_all = c(2030,2040,2050,2060), value = 0.12	)
# geothermal with closed loop cooling
vtgs = year_all
nds = bcus
geothermal_cl =  list( nodes = nds,
                        years = year_all,
                        times = time,
                        vintages = vtgs,	
                        types = c('power'),
                        modes = c( 1,2),
                        lifetime = lft,
                        
                        input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'freshwater', 
                                                                      level = 'energy_secondary',
                                                                      value =  2.4e-10 ) ,
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                            ),
                        left_join(   expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   mode = 1, 
                                                   commodity = 'electricity', 
                                                   level = 'energy_secondary',
                                                   value = 0.25 ) ,
                                     vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                        left_join(   expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   mode = 2, 
                                                   commodity = 'freshwater', 
                                                   level = 'energy_secondary',
                                                   value =  2.4e-10 ) ,
                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                        left_join(   expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   mode = 2, 
                                                   commodity = 'electricity', 
                                                   level = 'energy_secondary',
                                                   value = 0.25 ) ,
                                     vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                        left_join(   expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   mode = 2, 
                                                   commodity = 'electricity', 
                                                   level = 'wastewater_rural_final',
                                                   value = 0.039 ) ,
                                     vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                        
                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'electricity', 
                                                                      level = 'rural_final',
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                            left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 2, 
                                                                      commodity = 'electricity', 
                                                                      level = 'rural_final',
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                            
                                                                left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 2, 
                                                                      commodity = 'fertilizer', 
                                                                      level = 'agriculture_final',
                                                                      value = 0.00030 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                            
                                           
                                            
                                            left_join(   expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = 2, 
                                                                       commodity = 'flexibility', 
                                                                       level = 'energy_secondary',
                                                                       value =1 ) ,
                                                         vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )				
                                            
                        ),	
                        
                        # data.frame( node,vintage,year_all,mode,emission) 
                        emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                              vintage = vtgs,
                                                                              mode = 1, 
                                                                              emission = 'CO2', 
                                                                              value = round( 0 , digits = 5 ) ) ,
                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                      
                                                      left_join( expand.grid( node = nds,
                                                                              vintage = vtgs,
                                                                              mode = 2, 
                                                                              emission = 'CO2', 
                                                                              value = round( 0 , digits = 5 ) ) ,
                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),	
                                                      
                                                      left_join( expand.grid( node = nds,
                                                                              vintage = vtgs,
                                                                              mode = 1, 
                                                                              emission = 'water_consumption', 
                                                                              value = 0.00004 ) ,
                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                      
                                                      left_join( expand.grid( node = nds,
                                                                              vintage = vtgs,
                                                                              mode = 2, 
                                                                              emission = 'water_consumption', 
                                                                              value = round( 0.00013, digits = 5 ) ) ,
                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                      
                        ),										
                        
                        # data.frame(node,vintage,year_all,time)
                        capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 0.9 ) ,
                                                      vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                        
                        # data.frame( vintages, value )
                        construction_time = expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          value = 1	),
                        
                        # data.frame( vintages, value )
                        technical_lifetime = expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = lft	),
                        
                        # data.frame( vintages, value )
                        inv_cost = expand.grid( node = nds,
                                                vintage = vtgs,
                                             
                                                time = time,
                                                value = 0.4	),
                      
                                    vtg_year_time ) %>% 
                          dplyr::select( node, vintage, year_all, mode, time, value ),
                        
                        # data.frame( node, vintages, year_all, value )
                        fix_cost = left_join( 	expand.grid( 	node = nds,
                                                             vintage = vtgs,
                                                             value = 0.004	),
                                               vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                        
                        # data.frame( node, vintage, year_all, mode, time, value ) 
                        var_cost = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                      
                                                                         time = time,
                                                                         value = 0.00713	),
                                                           vtg_year_time ) %>% 
                                                 dplyr::select( node, vintage, year_all, mode, time, value ) ,
                   
                        # data.frame(node,vintage,year_all,value)
                        min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 0.9	),
                                                            vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                        
                        # data.frame(node,year_all,value)
                        historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "geothermal_cl",],
                        
                        # bound_new_capacity_up(node,inv_tec,year)
                        bound_new_capacity_up = expand.grid( 	node = nds, year_all = c(2020,2030), value = 0.12	),
                        
                        # data.frame(node,inv_tec,year)
                        growth_new_capacity_up = expand.grid( 	node = nds, year_all = c(2030,2040,2050,2060), value = 0.12	),

# solar PV (utility-scale)
vtgs = year_all,
nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "solar_1"])),
solar_pv_1 = list ( node = nds,
                    years = year_all,
                    times = time,
                    vintages = vtgs,	
                    types = c('power'),
                    modes = c( 1 ),
                    lifetime = lft,
                    
                    input = NULL,
                    
                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'electricity', 
                                                                  level = 'energy_secondary',
                                                                  value = 1 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                        
                                    # data.frame( node,vintage,year_all,mode,emission) 
                    emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          emission = 'CO2', 
                                                                          value = round( 0 , digits = 5 ) ) ,
                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                  
                                                  left_join( expand.grid( node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          emission = 'water_consumption', 
                                                                          value = 0 ) ,
                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                  
                                                  left_join( expand.grid( node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          emission = 'solar_credit', 
                                                                          value = -1 ) ,
                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                  
                    ),										
                    
                    # data.frame(node,vintage,year_all,time)
                    capacity_factor = left_join( 	capacity_factor_sw.df[capacity_factor_sw.df$tec == "solar_1",],
                                                  vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                    
                    # data.frame( vintages, value )
                    construction_time = expand.grid( 	node = nds,
                                                      vintage = vtgs,
                                                      value = 0.5	),
                    
                    # data.frame( vintages, value )
                    technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                       value = lft	),
                    
                    # data.frame( vintages, value )
                    inv_cost = expand.grid( node = nds,
                                            vintage = vtgs,
                                            value = 1	),
                    
                    # data.frame( node, vintages, year_all, value )
                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = 0	),
                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                    
                    # data.frame( node, vintage, year_all, mode, time, value ) 
                    var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                     vintage = vtgs,
                                                                     mode = 1,
                                                                     value = 0	),
                                                       vtg_year_time ) %>% 
                                             dplyr::select( node, vintage, year_all, mode, time, value )
                                           
                    ),							
                    
                    
                    # data.frame(node,vintage,year_all,value)
                    min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 0	),
                                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                    
                    # data.frame(node,year_all,value)
                    historical_new_capacity = hist_new_cap.df[ hist_new_cap.df$tec == "solar_pv_1", ],
                    
                    # bound_total_capacity_up(node,inv_tec,year)
                    bound_total_capacity_up = max_potential_sw.df %>% 
                      filter( tec == 'solar_1' ) %>% 
                      expand( data.frame( node, value  ), year_all ) %>%
                      dplyr::select( node, year_all, value )
                    
),

nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "solar_2"])),
solar_pv_2 = list( node = nds,
                   years = year_all,
                   times = time,
                   vintages = vtgs,	
                   types = c('power'),
                   modes = c( 1 ),
                   lifetime = lft,
                   
                   input = NULL,
                   
                   output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 mode = 1, 
                                                                 commodity = 'electricity', 
                                                                 level = 'energy_secondary',
                                                                 value = 1 ) ,
                                                   vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                       
                                       # data.frame( node,vintage,year_all,mode,emission) 
                                       emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                             vintage = vtgs,
                                                                                             mode = 1, 
                                                                                             emission = 'CO2', 
                                                                                             value = round( 0 , digits = 5 ) ) ,
                                                                                vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                     
                                                                     left_join( expand.grid( node = nds,
                                                                                             vintage = vtgs,
                                                                                             mode = 1, 
                                                                                             emission = 'water_consumption', 
                                                                                             value = 0 ) ,
                                                                                vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                     
                                                                     left_join( expand.grid( node = nds,
                                                                                             vintage = vtgs,
                                                                                             mode = 1, 
                                                                                             emission = 'solar_credit', 
                                                                                             value = -1 ) ,
                                                                                vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                                     
                                       ),										
                                       
                                       # data.frame(node,vintage,year_all,time)
                                       capacity_factor = left_join( 	capacity_factor_sw.df[capacity_factor_sw.df$tec == "solar_2",],
                                                                     vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                       
                                       # data.frame( vintages, value )
                                       construction_time = expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 0.5	),
                                       
                                       # data.frame( vintages, value )
                                       technical_lifetime = expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = lft	),
                                       
                                       # data.frame( vintages, value )
                                       inv_cost = expand.grid( node = nds,
                                                               vintage = vtgs,
                                                               value = 1	),
                                       
                                       # data.frame( node, vintages, year_all, value )
                                       fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            value = 0	),
                                                              vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                       
                                       # data.frame( node, vintage, year_all, mode, time, value ) 
                                       var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                        vintage = vtgs,
                                                                                        mode = 1,
                                                                                        value = 0	),
                                                                          vtg_year_time ) %>% 
                                                                dplyr::select( node, vintage, year_all, mode, time, value )
                                                              
                                       ),							
                                       
                                       
                                       # data.frame(node,vintage,year_all,value)
                                       min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                                         vintage = vtgs,
                                                                                         value = 0	),
                                                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                                       
                                       # data.frame(node,year_all,value)
                                       historical_new_capacity = hist_new_cap.df[ hist_new_cap.df$tec == "solar_pv_2", ],
                                       
                                       # bound_total_capacity_up(node,inv_tec,year)
                                       bound_total_capacity_up = max_potential_sw.df %>% 
                                         filter( tec == 'solar_1' ) %>% 
                                         expand( data.frame( node, value  ), year_all ) %>%
                                         dplyr::select( node, year_all, value )
                                       
                   ),
                   
                   solar_pv_3 = list( node = nds,
                                      years = year_all,
                                      times = time,
                                      vintages = vtgs,	
                                      types = c('power'),
                                      modes = c( 1 ),
                                      lifetime = lft,
                                      
                                      input = NULL,
                                      
                                      output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                    vintage = vtgs,
                                                                                    mode = 1, 
                                                                                    commodity = 'electricity', 
                                                                                    level = 'energy_secondary',
                                                                                    value = 1 ) ,
                                                                      vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                            dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                          
                                                          # data.frame( node,vintage,year_all,mode,emission) 
                                                          emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                                                vintage = vtgs,
                                                                                                                mode = 1, 
                                                                                                                emission = 'CO2', 
                                                                                                                value = round( 0 , digits = 5 ) ) ,
                                                                                                   vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                                        
                                                                                        left_join( expand.grid( node = nds,
                                                                                                                vintage = vtgs,
                                                                                                                mode = 1, 
                                                                                                                emission = 'water_consumption', 
                                                                                                                value = 0 ) ,
                                                                                                   vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                                        
                                                                                        left_join( expand.grid( node = nds,
                                                                                                                vintage = vtgs,
                                                                                                                mode = 1, 
                                                                                                                emission = 'solar_credit', 
                                                                                                                value = -1 ) ,
                                                                                                   vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                                                        
                                                          ),										
                                                          
                                                          # data.frame(node,vintage,year_all,time)
                                                          capacity_factor = left_join( 	capacity_factor_sw.df[capacity_factor_sw.df$tec == "solar_3",],
                                                                                        vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                                          
                                                          # data.frame( vintages, value )
                                                          construction_time = expand.grid( 	node = nds,
                                                                                            vintage = vtgs,
                                                                                            value = 0.5	),
                                                          
                                                          # data.frame( vintages, value )
                                                          technical_lifetime = expand.grid( 	node = nds,
                                                                                             vintage = vtgs,
                                                                                             value = lft	),
                                                          
                                                          # data.frame( vintages, value )
                                                          inv_cost = expand.grid( node = nds,
                                                                                  vintage = vtgs,
                                                                                  value = 1	),
                                                          
                                                          # data.frame( node, vintages, year_all, value )
                                                          fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                                               vintage = vtgs,
                                                                                               value = 0	),
                                                                                 vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                                          
                                                          # data.frame( node, vintage, year_all, mode, time, value ) 
                                                          var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                                           vintage = vtgs,
                                                                                                           mode = 1,
                                                                                                           value = 0	),
                                                                                             vtg_year_time ) %>% 
                                                                                   dplyr::select( node, vintage, year_all, mode, time, value )
                                                                                 
                                                          ),							
                                                          
                                                          
                                                          # data.frame(node,vintage,year_all,value)
                                                          min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                                                            vintage = vtgs,
                                                                                                            value = 0	),
                                                                                              vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                                                          
                                                          # data.frame(node,year_all,value)
                                                          historical_new_capacity = hist_new_cap.df[ hist_new_cap.df$tec == "solar_pv_3", ],
                                                          
                                                          # bound_total_capacity_up(node,inv_tec,year)
                                                          bound_total_capacity_up = max_potential_sw.df %>% 
                                                            filter( tec == 'solar_3' ) %>% 
                                                            expand( data.frame( node, value  ), year_all ) %>%
                                                            dplyr::select( node, year_all, value )
                                                          
                                      ),
                                      

# Wind (utility-scale)
vtgs = year_all,
nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "wind_1"])),
wind_1 = list( 	nodes = nds,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('power'),
                modes = c( 1 ),
                lifetime = lft,
                
                input = NULL,
                
                output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'electricity', 
                                                              level = 'energy_secondary',
                                                              value = 1 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                                # data.frame( node,vintage,year_all,mode,emission) 
                emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      emission = 'CO2', 
                                                                      value = round( 0 , digits = 5 ) ) ,
                                                         vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                              
                                              left_join( expand.grid( node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      emission = 'water_consumption', 
                                                                      value = 0 ) ,
                                                         vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                              
                                              left_join( expand.grid( node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      emission = 'wind_credit', 
                                                                      value = -1 ) ,
                                                         vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                              
                ),										
                
                # data.frame(node,vintage,year_all,time)
                capacity_factor = left_join( 	capacity_factor_sw.df[capacity_factor_sw.df$tec == "wind_1",],
                                              vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                
                # data.frame( vintages, value )
                construction_time = expand.grid( 	node = nds,
                                                  vintage = vtgs,
                                                  value = 1),
                
                # data.frame( vintages, value )
                technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = lft	),
                
                # data.frame( vintages, value )
                inv_cost = expand.grid( node = nds,
                                        vintage = vtgs,
                                        value = 2.2	),
                
                # data.frame( node, vintages, year_all, value )
                fix_cost = left_join( 	expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = 0.008	),
                                       vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                
                # data.frame( node, vintage, year_all, mode, time, value ) 
                var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 mode = 1,
                                                                 time = time,
                                                                 value = 0.000	),
                                                   vtg_year_time ) %>% 
                                         dplyr::select( node, vintage, year_all, mode, time, value )
                                       
                ),							
                
                
                # data.frame(node,vintage,year_all,value)
                min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 0	),
                                                    vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                
                # data.frame(node,year_all,value)
                historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "wind_1",],
                
                # bound_total_capacity_up(node,inv_tec,year)
                bound_total_capacity_up = max_potential_sw.df %>% 
                  filter( tec == 'wind_1' ) %>% 
                  expand( data.frame( node, value  ), year_all ) %>%
                  dplyr::select( node, year_all, value )
                
),

nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "wind_2"])),
wind_2 = list( 	nodes = nds,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('power'),
                modes = c( 1 ),
                lifetime = lft,
                
                input = NULL,
                
                output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'electricity', 
                                                              level = 'energy_secondary',
                                                              value = 1 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    # data.frame( node,vintage,year_all,mode,emission) 
                                    emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'CO2', 
                                                                                          value = round( 0 , digits = 5 ) ) ,
                                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                  
                                                                  left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'water_consumption', 
                                                                                          value = 0 ) ,
                                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                  
                                                                  left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'wind_credit', 
                                                                                          value = -1 ) ,
                                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                                  
                                    ),										
                                    
                                    # data.frame(node,vintage,year_all,time)
                                    capacity_factor = left_join( 	capacity_factor_sw.df[capacity_factor_sw.df$tec == "wind_2",],
                                                                  vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                    
                                    # data.frame( vintages, value )
                                    construction_time = expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 1),
                                    
                                    # data.frame( vintages, value )
                                    technical_lifetime = expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = lft	),
                                    
                                    # data.frame( vintages, value )
                                    inv_cost = expand.grid( node = nds,
                                                            vintage = vtgs,
                                                            value = 2.2	),
                                    
                                    # data.frame( node, vintages, year_all, value )
                                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 0.008	),
                                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                    
                                    # data.frame( node, vintage, year_all, mode, time, value ) 
                                    var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1,
                                                                                     time = time,
                                                                                     value = 0.000	),
                                                                       vtg_year_time ) %>% 
                                                             dplyr::select( node, vintage, year_all, mode, time, value )
                                                           
                                    ),							
                                    
                                    
                                    # data.frame(node,vintage,year_all,value)
                                    min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                                      vintage = vtgs,
                                                                                      value = 0	),
                                                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                                    
                                    # data.frame(node,year_all,value)
                                    historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "wind_2",],
                                    
                                    # bound_total_capacity_up(node,inv_tec,year)
                                    bound_total_capacity_up = max_potential_sw.df %>% 
                                      filter( tec == 'wind_1' ) %>% 
                                      expand( data.frame( node, value  ), year_all ) %>%
                                      dplyr::select( node, year_all, value )
                                    
                ),
nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "wind_3"])),
wind_3 = list( 	nodes = nds,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('power'),
                modes = c( 1 ),
                lifetime = lft,
                
                input = NULL,
                
                output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'electricity', 
                                                              level = 'energy_secondary',
                                                              value = 1 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    # data.frame( node,vintage,year_all,mode,emission) 
                                    emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'CO2', 
                                                                                          value = round( 0 , digits = 5 ) ) ,
                                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                  
                                                                  left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'water_consumption', 
                                                                                          value = 0 ) ,
                                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                                  
                                                                  left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'wind_credit', 
                                                                                          value = -1 ) ,
                                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                                  
                                    ),										
                                    
                                    # data.frame(node,vintage,year_all,time)
                                    capacity_factor = left_join( 	capacity_factor_sw.df[capacity_factor_sw.df$tec == "wind_3",],
                                                                  vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                    
                                    # data.frame( vintages, value )
                                    construction_time = expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 1),
                                    
                                    # data.frame( vintages, value )
                                    technical_lifetime = expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = lft	),
                                    
                                    # data.frame( vintages, value )
                                    inv_cost = expand.grid( node = nds,
                                                            vintage = vtgs,
                                                            value = 2.2	),
                                    
                                    # data.frame( node, vintages, year_all, value )
                                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 0.008	),
                                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                    
                                    # data.frame( node, vintage, year_all, mode, time, value ) 
                                    var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1,
                                                                                     time = time,
                                                                                     value = 0.000	),
                                                                       vtg_year_time ) %>% 
                                                             dplyr::select( node, vintage, year_all, mode, time, value )
                                                           
                                    ),							
                                    
                                    
                                    # data.frame(node,vintage,year_all,value)
                                    min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                                      vintage = vtgs,
                                                                                      value = 0	),
                                                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                                    
                                    # data.frame(node,year_all,value)
                                    historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "wind_3",],
                                    
                                    # bound_total_capacity_up(node,inv_tec,year)
                                    bound_total_capacity_up = max_potential_sw.df %>% 
                                      filter( tec == 'wind_3' ) %>% 
                                      expand( data.frame( node, value  ), year_all ) %>%
                                      dplyr::select( node, year_all, value )
                                    
                ),
                #electricity from natural Grid
                vtgs = year_all,
                nds = bcus,
                list( 	nodes = nds,
                       years = year_all,
                       times = time,
                       vintages = vtgs,	
                       types = c('power'),
                       modes = c( 1 ),
                       lifetime = lft,
                       input = NULL,
                       
                       
                      output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                     vintage = vtgs,
                                                                     mode = 1, 
                                                                     commodity = 'electricity', 
                                                                     level = 'rural_final',
                                                                     value = 1 ) ,
                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                           
                       ),	
                       
                       # data.frame( node,vintage,year_all,mode,emission) 
                       emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                             vintage = vtgs,
                                                                             mode = 1, 
                                                                             emission = 'CO2', 
                                                                             value = round( 0 , digits = 5 ) ) ,
                                                                vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                                     
                       ),										
                       
                       # data.frame( value ) or data,frame( node, year_all, time, value )
                       capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                   vintage = vtgs,
                                                                   value = 1
                                                                   ::select( node,  vintage, year_all, time, value ),
                                                                   
                                                                   # data.frame( vintages, value )
                                                                   construction_time = expand.grid( 	node = nds,
                                                                                                     vintage = vtgs,
                                                                                                     value = 1	),
                                                                   
                                                                   # data.frame( vintages, value )
                                                                   technical_lifetime = expand.grid( 	node = nds,
                                                                                                      vintage = vtgs,
                                                                                                      value = lft	),
                                                                   
                                                                   # data.frame( vintages, value )
                                                                   inv_cost = expand.grid( node = nds,
                                                                                           vintage = vtgs,
                                                                                           value = 0	),
                                                                   
                                                                   # data.frame( node, vintages, year_all, value )
                                                                   fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                                                        vintage = vtgs,
                                                                                                        value = 0	),
                                                                                          vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                                                   
                                                                   # data.frame( node, vintage, year_all, mode, time, value ) 
                                                                   var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                                                    vintage = vtgs,
                                                                                                                    mode = c(1),
                                                                                                                    time = time,
                                                                                                                    value = 0.0071	),
                                                                                                      vtg_year_time ) %>% 
                                                                                            dplyr::select( node, vintage, year_all, mode, time, value ) 
                                                                                          
                                                                   ),
                                                                   
                                                                   historical_new_capacity = tmp %>% 
                                                                     bind_rows(tmp %>% mutate(year_all = 2016))						
                                                                   
                       ),
                # electricity_grid_rural - generation to end-use within the same spatial unit
                vtgs = year_all,
                nds = bcus,
                                list( 	nodes = nds,
                         years = year_all,
                         times = time,
                         vintages = vtgs,	
                         types = c('power'),
                         modes = c( 1 ),
                         lifetime = lft,
                         
                         input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = c(1), 
                                                                       commodity = 'electricity', 
                                                                       level = 'energy_secondary',
                                                                       value =  1 ) ,
                                                         vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                               dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                                             
                         ),
                         
                         output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = 1, 
                                                                       commodity = 'electricity', 
                                                                       level = 'rural_final',
                                                                       value = 1 ) ,
                                                         vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                               dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                             
                                                                      ),	
                         
                         # data.frame( node,vintage,year_all,mode,emission) 
                         emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                               vintage = vtgs,
                                                                               mode = 1, 
                                                                               emission = 'CO2', 
                                                                               value = round( 0 , digits = 5 ) ) ,
                                                                  vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                                       
                         ),										
                         
                         # data.frame( value ) or data,frame( node, year_all, time, value )
                         capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                     vintage = vtgs,
                                                                     value = 1
                                                                     ::select( node,  vintage, year_all, time, value ),
                         
                         # data.frame( vintages, value )
                         construction_time = expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = 1	),
                         
                         # data.frame( vintages, value )
                         technical_lifetime = expand.grid( 	node = nds,
                                                            vintage = vtgs,
                                                            value = lft	),
                         
                         # data.frame( vintages, value )
                         inv_cost = expand.grid( node = nds,
                                                 vintage = vtgs,
                                                 value = 0	),
                         
                         # data.frame( node, vintages, year_all, value )
                         fix_cost = left_join( 	expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 0	),
                                                vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                         
                         # data.frame( node, vintage, year_all, mode, time, value ) 
                         var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c(1),
                                                                          time = time,
                                                                          value = 0	),
                                                            vtg_year_time ) %>% 
                                                  dplyr::select( node, vintage, year_all, mode, time, value ) 
                                                
                         ),
                         
                         historical_new_capacity = tmp %>% 
                           bind_rows(tmp %>% mutate(year_all = 2016))						
                         
                  ),
                
# electricity_distribution_rural - generation to end-use within the same spatial unit
vtgs = year_all,
nds = bcus,
tmp = demand.df %>% filter(commodity == 'electricity' & level == 'rural_final' & year_all == 2016) %>% 
  mutate(year_all = as.numeric(year_all)) %>% 
  group_by(node,year_all,units) %>% 
  summarise(value = sum(value)) %>% 
  mutate(tec = 'electricity_distribution_rural') %>% 
  dplyr::select(node,tec,year_all,value) %>% ungroup() %>% 
  mutate(value = 0.5 * value)
electricity_distribution_rural =  
  list( 	nodes = nds,
         years = year_all,
         times = time,
         vintages = vtgs,	
         types = c('power'),
         modes = c( 1 ),
         lifetime = lft,
         
         input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       mode = c(1), 
                                                       commodity = 'electricity', 
                                                       level = 'energy_secondary',
                                                       value =  1 ) ,
                                         vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                             
         ),
         
         output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       mode = 1, 
                                                       commodity = 'electricity', 
                                                       level = 'rural_final',
                                                       value = 1 ) ,
                                         vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                             
                             left_join(   expand.grid( 	node = nds,
                                                        vintage = vtgs,
                                                        mode = 1, 
                                                        commodity = 'flexibility', 
                                                        level = 'energy_secondary',
                                                        value = -0.1 ) ,
                                          vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )				
                             
         ),	
         
         # data.frame( node,vintage,year_all,mode,emission) 
         emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               emission = 'CO2', 
                                                               value = round( 0 , digits = 5 ) ) ,
                                                  vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                       
         ),										
         
         # data.frame( value ) or data,frame( node, year_all, time, value )
         capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = 0.9 ) ,
                                       vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
         
         # data.frame( vintages, value )
         construction_time = expand.grid( 	node = nds,
                                           vintage = vtgs,
                                           value = 1	),
         
         # data.frame( vintages, value )
         technical_lifetime = expand.grid( 	node = nds,
                                            vintage = vtgs,
                                            value = lft	),
         
         # data.frame( vintages, value )
         inv_cost = expand.grid( node = nds,
                                 vintage = vtgs,
                                 value = 1.12	),
         
         # data.frame( node, vintages, year_all, value )
         fix_cost = left_join( 	expand.grid( 	node = nds,
                                              vintage = vtgs,
                                              value = 0.036	),
                                vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
         
         # data.frame( node, vintage, year_all, mode, time, value ) 
         var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          mode = c(1),
                                                          time = time,
                                                          value = 0.025	),
                                            vtg_year_time ) %>% 
                                  dplyr::select( node, vintage, year_all, mode, time, value ) 
                                
         ),
         
         historical_new_capacity = tmp %>% 
           bind_rows(tmp %>% mutate(year_all = 2016))						
         
  ),

# electricity_distribution_irrigation - generation to end-use within the same spatial unit
vtgs = year_all,
nds = bcus,
tmp = demand.df %>% filter(commodity == 'electricity' & level == 'irrigation_final' & year_all == 2016) %>% 
  mutate(year_all = as.numeric(year_all)) %>% 
  group_by(node,year_all,units) %>% 
  summarise(value = sum(value)) %>% 
  mutate(tec = 'electricity_distribution_irrigation') %>% 
  dplyr::select(node,tec,year_all,value) %>% ungroup() %>% 
  mutate(value = 0.5 * value),
electricity_distribution_irrigation = 
  list( 	nodes = nds,
         years = year_all,
         times = time,
         vintages = vtgs,	
         types = c('power'),
         modes = c( 1 ),
         lifetime = lft,
         
         input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       mode = c(1), 
                                                       commodity = 'electricity', 
                                                       level = 'energy_secondary',
                                                       value =  1 ) ,
                                         vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                             
         ),
         
         output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       mode = 1, 
                                                       commodity = 'electricity', 
                                                       level = 'irrigation_final',
                                                       value = 1 ) ,
                                         vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                             
                             left_join(   expand.grid( 	node = nds,
                                                        vintage = vtgs,
                                                        mode = 1, 
                                                        commodity = 'flexibility', 
                                                        level = 'energy_secondary',
                                                        value = -0.1 ) ,
                                          vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )				
                             
         ),	
         
         # data.frame( node,vintage,year_all,mode,emission) 
         emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               emission = 'CO2', 
                                                               value = round( 0 , digits = 5 ) ) ,
                                                  vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                       
         ),										
         
         # data.frame( value ) or data,frame( node, year_all, time, value )
         capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = 1 ) ,
                                       vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
         
         # data.frame( vintages, value )
         construction_time = expand.grid( 	node = nds,
                                           vintage = vtgs,
                                           value = 1	),
         
         # data.frame( vintages, value )
         technical_lifetime = expand.grid( 	node = nds,
                                            vintage = vtgs,
                                            value = lft	),
         
         # data.frame( vintages, value )
         inv_cost = expand.grid( node = nds,
                                 vintage = vtgs,
                                 value = 1.12	),
         
         # data.frame( node, vintages, year_all, value )
         fix_cost = left_join( 	expand.grid( 	node = nds,
                                              vintage = vtgs,
                                              value = 0.036	),
                                vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
         
         # data.frame( node, vintage, year_all, mode, time, value ) 
         var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          mode = c(1),
                                                          time = time,
                                                          value = 0.025	),
                                            vtg_year_time ) %>% 
                                  dplyr::select( node, vintage, year_all, mode, time, value )
                                
         ),
         
         historical_new_capacity = tmp %>% 
           bind_rows(tmp %>% mutate(year_all = 2010))						
         
  ),

# electricity_shtort term storage
vtgs = year_all,
nds = bcus,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
electricity_short_strg = 
  list( 	nodes = nds,
         years = year_all,
         times = time,
         vintages = vtgs,	
         types = c('power'),
         modes = c( 1 ),
         lifetime = lft,
         
         input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       mode = c(1), 
                                                       commodity = 'electricity', 
                                                       level = 'energy_secondary',
                                                       value =  0.2 ) ,
                                         vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                             
         ),
         
         output = bind_rows( left_join(   expand.grid( 	node = nds,
                                                        vintage = vtgs,
                                                        mode = 1, 
                                                        commodity = 'flexibility', 
                                                        level = 'energy_secondary',
                                                        value = 1 ) ,
                                          vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                               dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )				
                             
         ),	
         
         # data.frame( node,vintage,year_all,mode,emission) 
         emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               emission = 'CO2', 
                                                               value = round( 0 , digits = 5 ) ) ,
                                                  vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                       
         ),										
         
         # data.frame( value ) or data,frame( node, year_all, time, value )
         capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = 0.9 ) ,
                                       vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
         
         # data.frame( vintages, value )
         construction_time = expand.grid( 	node = nds,
                                           vintage = vtgs,
                                           value = 1	),
         
         # data.frame( vintages, value )
         technical_lifetime = expand.grid( 	node = nds,
                                            vintage = vtgs,
                                            value = 20	),
         
         # data.frame( vintages, value )
         inv_cost = expand.grid( node = nds,
                                 vintage = vtgs,
                                 value = 3.000	),
         
         # data.frame( node, vintages, year_all, value )
         fix_cost = left_join( 	expand.grid( 	node = nds,
                                              vintage = vtgs,
                                              value = 0.016	),
                                vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
         
         # data.frame( node, vintage, year_all, mode, time, value ) 
         var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          mode = c(1),
                                                          time = time,
                                                          value = 0.015	),
                                            vtg_year_time ) %>% 
                                  dplyr::select( node, vintage, year_all, mode, time, value ) 
                                
         ),
         
         historical_new_capacity = NULL						
         
  ),


#### Water technologies

# gw_extract					
vtgs = year_all,
nds = bcus,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
gw_extract = list( 	nodes = nds,
                    years = year_all,
                    times = time,
                    vintages = vtgs,	
                    types = c('water'),
                    modes = c( 1 ),
                    lifetime = lft,
                    
                    input = NULL,
                    
                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'freshwater', 
                                                                  level = 'aquifer',
                                                                  value = 1 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                    ),	
                    
                    # data.frame( node,vintage,year_all,mode,emission) 
                    emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          emission = 'groundwater', 
                                                                          value = 1 ) ,
                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                  
                    ),										
                    
                    # data.frame(node,vintage,year_all,time)
                    capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                vintage = vtgs,
                                                                value = 1 ) ,
                                                  vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                    
                    # data.frame( vintages, value )
                    construction_time = expand.grid( 	node = nds,
                                                      vintage = vtgs,
                                                      value = 0	),
                    
                    # data.frame( vintages, value )
                    technical_lifetime = expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = 1	),
                    
                    # data.frame( vintages, value )
                    inv_cost = expand.grid( node = nds,
                                            vintage = vtgs,
                                            value = 0	),
                    
                    # data.frame( node, vintages, year_all, value )
                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = 0	),
                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                    
                    # data.frame( node, vintage, year_all, mode, time, value ) 
                    var_cost = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    
                                                                    time = time,
                                                                    value =0.0146	),
                                                      vtg_year_time ) %>% 
                                            dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                    
                    # data.frame(node,year_all,value)
                    historical_new_capacity = NULL
                    
),

vtgs = year_all,
nds = bcus,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
renew_gw_extract = list( 	nodes = nds,
                          years = year_all,
                          times = time,
                          vintages = vtgs,	
                          types = c('water'),
                          modes = c( 1 ),
                          lifetime = lft,
                          
                          input = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = 1, 
                                                                       commodity = 'renewable_gw', 
                                                                       level = 'aquifer',
                                                                       value = 1 ) ,
                                                         vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                               dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                          ),
                          
                          output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        mode = 1, 
                                                                        commodity = 'freshwater', 
                                                                        level = 'aquifer',
                                                                        value = 1 ) ,
                                                          vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                          ),	
                          
                          # data.frame( node,vintage,year_all,mode,emission) 
                          emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                vintage = vtgs,
                                                                                mode = 1, 
                                                                                emission = 'groundwater', 
                                                                                value = 0 ) ,
                                                                   vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                        
                          ),										
                          
                          # data.frame(node,vintage,year_all,time)
                          capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                          
                          # data.frame( vintages, value )
                          construction_time = expand.grid( 	node = nds,
                                                            vintage = vtgs,
                                                            value = 0	),
                          
                          # data.frame( vintages, value )
                          technical_lifetime = expand.grid( 	node = nds,
                                                             vintage = vtgs,
                                                             value = 1	),
                          
                          # data.frame( vintages, value )
                          inv_cost = expand.grid( node = nds,
                                                  vintage = vtgs,
                                                  value = 0	),
                          
                          # data.frame( node, vintages, year_all, value )
                          fix_cost = left_join( 	expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 0	),
                                                 vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                          
                          # data.frame( node, vintage, year_all, mode, time, value ) 
                          var_cost = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          
                                                                          time = time,
                                                                          value =0.0146	),
                                                            vtg_year_time ) %>% 
                                                  dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                                                
                          
                          # data.frame(node,year_all,value)
                          historical_new_capacity = NULL
                          
),					

# rural_sw_diversion 
vtgs = year_all,
nds = bcus,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
rural_sw_diversion = list( 	nodes = nds,
                            years = year_all,
                            times = time,
                            vintages = vtgs,	
                            types = c('water'),
                            modes = c( 1 ),
                            lifetime = 20,
                            
                            input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'electricity', 
                                                                          level = 'rural_final',
                                                                          value =  0 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                
                                                left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'freshwater', 
                                                                          level = 'river_in',
                                                                          value =  1 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                
                            ),
                            
                            output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          commodity = 'freshwater', 
                                                                          level = 'rural_secondary',
                                                                          value = 1 ) ,
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                            ),	
                            
                            # data.frame( node,vintage,year_all,mode,emission) 
                            emission_factor = NULL,										
                            
                            # data.frame(node,vintage,year_all,time)
                            capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 1 ) ,
                                                          vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                            
                            # data.frame( vintages, value )
                            construction_time = expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 0	),
                            
                            # data.frame( vintages, value )
                            technical_lifetime = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 15	),
                            
                            # data.frame( vintages, value )
                            inv_cost = expand.grid( node = nds,
                                                    vintage = vtgs,
                                                    value = 0	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 value = 0	),
                                                   vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            
                                                                            time = time,
                                                                            value =0.0146	),
                                                              vtg_year_time ) %>% 
                                                    dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                                                  
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "Rural_sw_diversion",]
                            
),
                      
# rural_gw_diversion 
vtgs = year_all,
lft = 15,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
nds = bcus,
rural_gw_diversion = list( 	nodes = nds,
                            years = year_all,
                            times = time,
                            vintages = vtgs,	
                            types = c('water'),
                            modes = c( 1 ),
                            lifetime = 15,
                            
                            input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'electricity', 
                                                                          level = 'rural_final',
                                                                          value =  2.083 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                
                                                left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'freshwater', 
                                                                          level = 'aquifer',
                                                                          value =  1 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                
                            ),
                            
                            output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          commodity = 'freshwater', 
                                                                          level = 'rural_secondary',
                                                                          value = 1 ) ,
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                            ),	
                            
                            # data.frame( node,vintage,year_all,mode,emission) 
                            emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  emission = 'water_consumption', 
                                                                                  value = 0 ) ,
                                                                     vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                            ),								
                            
                            
                            # data.frame(node,vintage,year_all,time)
                            capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 0.9 ) ,
                                                          vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                            
                            # data.frame( vintages, value )
                            construction_time = expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 0	),
                            
                            # data.frame( vintages, value )
                            technical_lifetime = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = lft	),
                            
                            # data.frame( vintages, value )
                            inv_cost = expand.grid( node = nds,
                                                    vintage = vtgs,
                                                    value = 8.5	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 value = 1	),
                                                   vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            
                                                                            time = time,
                                                                            value =0.0146	),
                                                              vtg_year_time ) %>% 
                                                    dplyr::select( node, vintage, year_all, mode, time, value ) ,												
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_gw_diversion",],
                          
                            # rural_piped_distribution 
                            vtgs = year_all,
                            lft = 15,
                            vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ),
                            vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ), 
                            nds = bcus,
                            rural_piped_distribution = list(nodes = nds,
                                                              years = year_all,
                                                              times = time,
                                                              vintages = vtgs,	
                                                              types = c('water'),
                                                              modes = c( 1 ),
                                                              lifetime = lft,
                                  
                                  input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = c( 1 ), 
                                                                                commodity = 'electricity', 
                                                                                level = 'rural_final',
                                                                                value =  2.097 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                      
                                                      left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = c( 1 ), 
                                                                                commodity = 'freshwater', 
                                                                                level = 'rural_secondary',
                                                                                value =  1 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                      
                                  ),
                                  
                                  output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = 1, 
                                                                                commodity = 'freshwater', 
                                                                                level = 'rural_final',
                                                                                value = 1 ) ,
                                                                  vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                  ),	
                                  
                                  # data.frame( node,vintage,year_all,mode,emission) 
                                  emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                        vintage = vtgs,
                                                                                        mode = 1, 
                                                                                        emission = 'water_consumption', 
                                                                                        value = 0 ) ,
                                                                           vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                  ),								
                                  
                                  
                                  # data.frame(node,vintage,year_all,time)
                                  capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                              vintage = vtgs,
                                                                              value = 0.9 ) ,
                                                                vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                  
                                  # data.frame( vintages, value )
                                  construction_time = expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 0	),
                                  
                                  # data.frame( vintages, value )
                                  technical_lifetime = expand.grid( 	node = nds,
                                                                     vintage = vtgs,
                                                                     value = lft	),
                                  
                                  # data.frame( vintages, value )
                                  inv_cost = expand.grid( node = nds,
                                                          vintage = vtgs,
                                                          value =2.097	),
                                  
                                  # data.frame( node, vintages, year_all, value )
                                  fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = 18	),
                                                         vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                  
                                  # data.frame( node, vintage, year_all, mode, time, value ) 
                                  var_cost = NULL,							
                                  
                                  # data.frame(node,year_all,value)
                                  historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_piped_distribution",],
                                
# rural_unimproved_distribution 
vtgs = year_all,
lft = 1,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
nds = bcus,
rural_unimproved_distribution = list( 	nodes = nds,
                                       years = year_all,
                                       times = time,
                                       vintages = vtgs,	
                                       types = c('water'),
                                       modes = c( 1 ),
                                       lifetime = 1,
                                       
                                       input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'electricity', 
                                                                                     level = 'rural_final',
                                                                                     value =  0 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                           
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'rural_secondary',
                                                                                     value =  0 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                           
                                       ),
                                       
                                       output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1, 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'rural_final',
                                                                                     value = 0 ) ,
                                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                       ),	
                                       
                                       # data.frame( node,vintage,year_all,mode,emission) 
                                       emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                             vintage = vtgs,
                                                                                             mode = 1, 
                                                                                             emission = 'water_consumption', 
                                                                                             value = 0 ) ,
                                                                                vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                       ),								
                                       
                                       
                                       # data.frame(node,vintage,year_all,time)
                                       capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   value = 1 ) ,
                                                                     vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                       
                                       # data.frame( vintages, value )
                                       construction_time = expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 0	),
                                       
                                       # data.frame( vintages, value )
                                       technical_lifetime = expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 1	),
                                       
                                       # data.frame( vintages, value )
                                       inv_cost = expand.grid( node = nds,
                                                               vintage = vtgs,
                                                               value = 0	),
                                       
                                       # data.frame( node, vintages, year_all, value )
                                       fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            value = 0	),
                                                              vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                       
                                       # data.frame( node, vintage, year_all, mode, time, value ) 
                                       var_cost = NULL,							
                                       
                                       # data.frame(node,year_all,value)
                                       historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_unimproved_distribution",],
                                       

# rural_wastewater_collection
vtgs = year_all,
lft = 15,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ),
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ),
nds = bcus,
rural_wastewater_collection = list( 	nodes = nds,
                                     years = year_all,
                                     times = time,
                                     vintages = vtgs,	
                                     types = c('water'),
                                     modes = c( 1 ),
                                     lifetime = 15,
                                     
                                     input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'electricity', 
                                                                                   level = 'rural_final',
                                                                                   value =  0.03 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                         
                                                         left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'wastewater', 
                                                                                   level = 'rural_final',
                                                                                   value =  1 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                         
                                     ),
                                     
                                     output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = 1, 
                                                                                   commodity = 'wastewater', 
                                                                                   level = 'rural_secondary',
                                                                                   value = 1 ) ,
                                                                     vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                     ),	
                                     
                                     # data.frame( node,vintage,year_all,mode,emission) 
                                     emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                           vintage = vtgs,
                                                                                           mode = 1, 
                                                                                           emission = 'water_consumption', 
                                                                                           value = 0 ) ,
                                                                              vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                     ),								
                                     
                                     
                                     # data.frame(node,vintage,year_all,time)
                                     capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                 vintage = vtgs,
                                                                                 value = 1 ) ,
                                                                   vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                     
                                     # data.frame( vintages, value )
                                     construction_time = expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = 1	),
                                     
                                     # data.frame( vintages, value )
                                     technical_lifetime = expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 1	),
                                     
                                     # data.frame( vintages, value )
                                     inv_cost = expand.grid( node = nds,
                                                             vintage = vtgs,
                                                             value = 2.097	),
                                     
                                     # data.frame( node, vintages, year_all, value )
                                     fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 0	),
                                                            vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                     
                                     # data.frame( node, vintage, year_all, mode, time, value ) 
                                     # data.frame( node, vintage, year_all, mode, time, value ) 
                                     var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                      vintage = vtgs,
                                                                                      
                                                                                      time = time,
                                                                                      value = 0.00718	),
                                                                        vtg_year_time ) %>% 
                                                              dplyr::select( node, vintage, year_all, mode, time, value ) ,
                                                      
                                     # data.frame(node,year_all,value)
                                     historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_wastewater_collection",]
                                     
),

# rural_wastewater_release
vtgs = year_all,
lft = 1,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
nds = bcus,
rural_wastewater_release = list( nodes = nds,
                                  years = year_all,
                                  times = time,
                                  vintages = vtgs,	
                                  types = c('water'),
                                  modes = c( 1 ),
                                  lifetime = 1,
                                  
                                  input = bind_rows(  left_join(  
                                                      
                                                       expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = c( 1 ), 
                                                                                commodity = 'wastewater', 
                                                                                level = 'rural_final',
                                                                                value =  1 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                      
                                  ),
                                  
                                  output = bind_rows( 
                                  ),	
                                 left_join(  expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           mode = 1, 
                                                           commodity = 'freshwater', 
                                                           level = 'river_out',
                                                           value = 0 ) ,
                                             vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                   dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
),
                                  # data.frame( node,vintage,year_all,mode,emission) 
                                  emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                        vintage = vtgs,
                                                                                        mode = 1, 
                                                                                        emission = 'water_consumption', 
                                                                                        value = 0 ) ,
                                                                           vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                  ),								
                                  
                                  
                                  # data.frame(node,vintage,year_all,time)
                                  capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                              vintage = vtgs,
                                                                              value = 1 ) ,
                                                                vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                  
                                  # data.frame( vintages, value )
                                  construction_time = expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 0	),
                                  
                                  # data.frame( vintages, value )
                                  technical_lifetime = expand.grid( 	node = nds,
                                                                     vintage = vtgs,
                                                                     value = 1	),
                                  
                                  # data.frame( vintages, value )
                                  inv_cost = expand.grid( node = nds,
                                                          vintage = vtgs,
                                                          value = 0	),
                                  
                                  # data.frame( node, vintages, year_all, value )
                                  fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = 0	),
                                                         vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                  
                                  # data.frame( node, vintage, year_all, mode, time, value ) 
                                  var_cost = NULL,							
                                  
                                  # data.frame(node,year_all,value)
                                  historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_wastewater_release",],
                                  


# rural_wastewater_treatment
as.character( basin.spdf@data$DOWN[ iii ] ),
vtgs = year_all,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
nds = bcus,
rural_wastewater_treatment = list( 	nodes = nds,
                                    years = year_all,
                                    times = time,
                                    vintages = vtgs,	
                                    types = c('water'),
                                    modes = c( 1 ),
                                    lifetime = 20,
                                    
                                    input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = c( 1 ), 
                                                                                  commodity = 'electricity', 
                                                                                  level = 'rural_final',
                                                                                  value =  423.88 ) ,
                                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                        
                                                        left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = c( 1 ), 
                                                                                  commodity = 'wastewater', 
                                                                                  level = 'rural_secondary',
                                                                                  value =  0.85 ) ,
                                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                        
                                    ),
                                    
                                    output = bind_rows( left_join(  expand.grid( 	node = nds, 
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  commodity = 'freshwater', 
                                                                                  level = 'rural_final',
                                                                                  value = 1 ) ,
                                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    ),	
                                    left_join(  expand.grid( 	node = nds, 
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'fertilizer', 
                                                              level = 'agriculture_final',
                                                              value = 0.15 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
),	
                                      left_join(  expand.grid( 	node = nds, 
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  commodity = 'freshwater', 
                                                                                  level = 'river_out',
                                                                                  value = 0 ) ,
                                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    ),	
                                    
                                    
                                    # data.frame( node,vintage,year_all,mode,emission) 
                                    emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'water_consumption', 
                                                                                          value = 0 ) ,
                                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                    ),								
                                    
                                    
                                    # data.frame(node,vintage,year_all,time)
                                    capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                value = 0.9 ) ,
                                                                  vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                    
                                    # data.frame( vintages, value )
                                    construction_time = expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 1	),
                                    
                                    # data.frame( vintages, value )
                                    technical_lifetime = expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = 20	),
                                    
                                    # data.frame( vintages, value )
                                    inv_cost = expand.grid( node = nds,
                                                            vintage = vtgs,
                                                            value = 2.097	),
                                    
                                    # data.frame( node, vintages, year_all, value )
                                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 0	),
                                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                    
                                    # data.frame( node, vintage, year_all, mode, time, value ) 
var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                 vintage = vtgs,
                                                 
                                                 time = time,
                                                 value = 0.00165	),
                                   vtg_year_time ) %>% 
                         dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                                    
                                    # data.frame(node,year_all,value)
                                    historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_wastewater_treatment",]
                                    
),

# irrigation_sw_diversion - conventional
vtgs = year_all,
nds = bcus,
lft = 50,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ),
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ),
irrigation_sw_diversion = list( 	nodes = nds,
                                 years = year_all,
                                 times = time,
                                 vintages = vtgs,	
                                 types = c('water'),
                                 modes = c( 1 ),
                                 lifetime = lft,
                                 
                                 input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               mode = c( 1 ), 
                                                                               commodity = 'electricity', 
                                                                               level = 'irrigation_final',
                                                                               value =  2.083 ) ,
                                                                 vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                       dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                     
                                                     left_join(  expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               mode = c( 1 ), 
                                                                               commodity = 'freshwater', 
                                                                               level = 'river_in',
                                                                               value =  1 ) ,
                                                                 vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                       dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                     
                                 ),
                                 
                                 output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               mode = 1, 
                                                                               commodity = 'freshwater', 
                                                                               level = 'irrigation_final',
                                                                               value = 0.75 ) , # Average losses for canals from Wu et al. World Bank (2013)
                                                                 vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                       dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                     
                                                     # Seepage to groundwater
                                                     left_join(  expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               mode = 1, 
                                                                               commodity = 'renewable_gw', 
                                                                               level = 'aquifer',
                                                                               value = 0.25 ) , # Assumed inverse of the above
                                                                 vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                       dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                     
                                 ),	
                                 
                                 # data.frame( node,vintage,year_all,mode,emission) 
                                 emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                       vintage = vtgs,
                                                                                       mode = 1, 
                                                                                       emission = 'water_consumption', 
                                                                                       value = 0 ) ,
                                                                          vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                 ),								
                                 
                                 
                                 # data.frame(node,vintage,year_all,time)
                                 capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                             vintage = vtgs,
                                                                             value = 0.9 ) ,
                                                               vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                 
                                 # data.frame( vintages, value )
                                 construction_time = expand.grid( 	node = nds,
                                                                   vintage = vtgs,
                                                                   value = 1	),
                                 
                                 # data.frame( vintages, value )
                                 technical_lifetime = expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = lft	),
                                 
                                 # data.frame( vintages, value )
                                 inv_cost = expand.grid( node = nds,
                                                         vintage = vtgs,
                                                         value = 0	),
                                 
                                 # data.frame( node, vintages, year_all, value )
                                 fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 3	),
                                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                 
                                 # data.frame( node, vintage, year_all, mode, time, value ) 
                                 var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  
                                                                                  time = time,
                                                                                  value = 0.00165	),
                                                                    vtg_year_time ) %>% 
                                                          dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                                 
                                 # data.frame(node,year_all,value)
                                 historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "irrigation_sw_diversion",]
                                 
),

# irrigation_sw_diversion - smart
vtgs = year_all,
nds = bcus,
lft = 50,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
smart_irrigation_sw_diversion = list( 	nodes = nds,
                                       years = year_all,
                                       times = time,
                                       vintages = vtgs,	
                                       types = c('water'),
                                       modes = c( 1 ),
                                       lifetime = lft,
                                       
                                       input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'electricity', 
                                                                                     level = 'irrigation_final',
                                                                                     value =  2.83 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                           
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'river_in',
                                                                                     value =  1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                           
                                       ),
                                       
                                       output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1, 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'irrigation_final',
                                                                                     value = 0.75 + 0.1 ) , # Average losses for canals from Wu et al. World Bank (2013)
                                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                           
                                                           # Seepage to groundwater
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1, 
                                                                                     commodity = 'renewable_gw', 
                                                                                     level = 'aquifer',
                                                                                     value = 0.25 - 0.1 ) , # Assumed inverse of the above
                                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                           
                                                           # Electricity flexibility			
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'flexibility', 
                                                                                     level = 'energy_secondary',
                                                                                     value =  6 * 0.1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                                                           
                                       ),	
                                       
                                       # data.frame( node,vintage,year_all,mode,emission) 
                                       emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                             vintage = vtgs,
                                                                                             mode = 1, 
                                                                                             emission = 'water_consumption', 
                                                                                             value = 0 ) ,
                                                                                vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                       ),								
                                       
                                       
                                       # data.frame(node,vintage,year_all,time)
                                       capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   value = 0.9 ) ,
                                                                     vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                       
                                       # data.frame( vintages, value )
                                       construction_time = expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 1	),
                                       
                                       # data.frame( vintages, value )
                                       technical_lifetime = expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = lft	),
                                       
                                       # data.frame( vintages, value )
                                       inv_cost = expand.grid( node = nds,
                                                               vintage = vtgs,
                                                               value = 57 * 1.1	),
                                       
                                       # data.frame( node, vintages, year_all, value )
                                       fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            value = 3 * 1.1	),
                                                              vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                       
                                       # data.frame( node, vintage, year_all, mode, time, value ) 
                                       var_cost = NULL,							
                                       
                                       # data.frame(node,year_all,value)
                                       historical_new_capacity = NULL
                                       
),					

# irrigation_gw_diversion - conv
vtgs = year_all,
nds = bcus,
irrigation_gw_diversion = list( 	nodes = nds,
                                 years = year_all,
                                 times = time,
                                 vintages = vtgs,	
                                 types = c('water'),
                                 modes = c( 1 ),
                                 lifetime = 20,
                                 
                                 input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               mode = c( 1 ), 
                                                                               commodity = 'electricity', 
                                                                               level = 'irrigation_final',
                                                                               value =  2.083 ) ,
                                                                 vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                       dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                     
                                                     left_join(  expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               mode = c( 1 ), 
                                                                               commodity = 'freshwater', 
                                                                               level = 'aquifer',
                                                                               value =  1 ) ,
                                                                 vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                       dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                     
                                 ),
                                 
                                 output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               mode = 1, 
                                                                               commodity = 'freshwater', 
                                                                               level = 'irrigation_final',
                                                                               value = 1 ) ,
                                                                 vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                       dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                 ),	
                                 
                                 # data.frame( node,vintage,year_all,mode,emission) 
                                 emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                       vintage = vtgs,
                                                                                       mode = 1, 
                                                                                       emission = 'water_consumption', 
                                                                                       value = 0 ) ,
                                                                          vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                 ),								
                                 
                                 
                                 # data.frame(node,vintage,year_all,time)
                                 capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                             vintage = vtgs,
                                                                             value = 0.9 ) ,
                                                               vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                 
                                 # data.frame( vintages, value )
                                 construction_time = expand.grid( 	node = nds,
                                                                   vintage = vtgs,
                                                                   value = 1	),
                                 
                                 # data.frame( vintages, value )
                                 technical_lifetime = expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 20	),
                                 
                                 # data.frame( vintages, value )
                                 inv_cost = expand.grid( node = nds,
                                                         vintage = vtgs,
                                                         value = 8.5	),
                                 
                                 # data.frame( node, vintages, year_all, value )
                                 fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 1	),
                                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                 
                                 # data.frame( node, vintage, year_all, mode, time, value ) 
                                 var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  
                                                                                  time = time,
                                                                                  value = 0.00165	),
                                                                    vtg_year_time ) %>% 
                                                          dplyr::select( node, vintage, year_all, mode, time, value ) ,						
                                 
                                 # data.frame(node,year_all,value)
                                 historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "irrigation_gw_diversion",]
                                 
),

# irrigation_gw_diversion - smart
vtgs = year_all,
nds = bcus,
smart_irrigation_gw_diversion = list( 	nodes = nds,
                                       years = year_all,
                                       times = time,
                                       vintages = vtgs,	
                                       types = c('water'),
                                       modes = c( 1 ),
                                       lifetime = 20,
                                       
                                       input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'electricity', 
                                                                                     level = 'irrigation_final',
                                                                                     value =  16 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                           
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'aquifer',
                                                                                     value =  1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                           
                                       ),
                                       
                                       output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1, 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'irrigation_final',
                                                                                     value = 1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'flexibility', 
                                                                                     level = 'energy_secondary',
                                                                                     value =  16 * 0.1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                                       ),	
                                       
                                       # data.frame( node,vintage,year_all,mode,emission) 
                                       emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                             vintage = vtgs,
                                                                                             mode = 1, 
                                                                                             emission = 'water_consumption', 
                                                                                             value = 0 ) ,
                                                                                vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                       ),								
                                       
                                       
                                       # data.frame(node,vintage,year_all,time)
                                       capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   value = 0.9 ) ,
                                                                     vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                       
                                       # data.frame( vintages, value )
                                       construction_time = expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 1	),
                                       
                                       # data.frame( vintages, value )
                                       technical_lifetime = expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 20	),
                                       
                                       # data.frame( vintages, value )
                                       inv_cost = expand.grid( node = nds,
                                                               vintage = vtgs,
                                                               value = 8.5 * 1.1	),
                                       
                                       # data.frame( node, vintages, year_all, value )
                                       fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            value = 1 * 1.1	),
                                                              vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                       
                                       # data.frame( node, vintage, year_all, mode, time, value ) 
                                       var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                                        vintage = vtgs,
                                                                                        
                                                                                        time = time,
                                                                                        value = 0.00165	),
                                                                          vtg_year_time ) %>% 
                                                                dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                                                              
                                       
                                       # data.frame(node,year_all,value)
                                       historical_new_capacity = NULL
                                       
),					

# energy_sw_diversion
vtgs = year_all,
nds = bcus,
energy_sw_diversion = list( 	nodes = nds,
                             years = year_all,
                             times = time,
                             vintages = vtgs,	
                             types = c('water'),
                             modes = c( 1 ),
                             lifetime = 1,
                             
                             input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = c( 1 ), 
                                                                           commodity = 'electricity', 
                                                                           level = 'energy_secondary',
                                                                           value =  0 ) ,
                                                             vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                 
                                                 left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = c( 1 ), 
                                                                           commodity = 'freshwater', 
                                                                           level = 'river_in',
                                                                           value =  1 ) ,
                                                             vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                 
                             ),
                             
                             output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = 1, 
                                                                           commodity = 'freshwater', 
                                                                           level = 'energy_secondary',
                                                                           value = 1 ) ,
                                                             vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                             ),	
                             
                             # data.frame( node,vintage,year_all,mode,emission) 
                             emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = 1, 
                                                                                   emission = 'water_consumption', 
                                                                                   value = 0 ) ,
                                                                      vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                             ),								
                             
                             
                             # data.frame(node,vintage,year_all,time)
                             capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 1 ) ,
                                                           vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                             
                             # data.frame( vintages, value )
                             construction_time = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 0	),
                             
                             # data.frame( vintages, value )
                             technical_lifetime = expand.grid( 	node = nds,
                                                                vintage = vtgs,
                                                                value = 1	),
                             
                             # data.frame( vintages, value )
                             inv_cost = expand.grid( node = nds,
                                                     vintage = vtgs,
                                                     value = 0	),
                             
                             # data.frame( node, vintages, year_all, value )
                             fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 0	),
                                                    vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                             
                             # data.frame( node, vintage, year_all, mode, time, value ) 
                             var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                              vintage = vtgs,
                                                                              
                                                                              time = time,
                                                                              value = 0.00165	),
                                                                vtg_year_time ) %>% 
                                                      dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                                                    
                             
                             # data.frame(node,year_all,value)
                             historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "energy_sw_diversion",]
                             
),

# energy_gw_diversion 
vtgs = year_all,
nds = bcus,
energy_gw_diversion = list( 	nodes = nds,
                             years = year_all,
                             times = time,
                             vintages = vtgs,	
                             types = c('water'),
                             modes = c( 1 ),
                             lifetime = 1,
                             
                             input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = c( 1 ), 
                                                                           commodity = 'electricity', 
                                                                           level = 'energy_secondary',
                                                                           value =  2.83 ) ,
                                                             vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                 
                                                 left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = c( 1 ), 
                                                                           commodity = 'freshwater', 
                                                                           level = 'aquifer',
                                                                           value =  1 ) ,
                                                             vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                 
                             ),
                             
                             output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = 1, 
                                                                           commodity = 'freshwater', 
                                                                           level = 'energy_secondary',
                                                                           value = 1 ) ,
                                                             vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                             ),	
                             
                             # data.frame( node,vintage,year_all,mode,emission) 
                             emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = 1, 
                                                                                   emission = 'water_consumption', 
                                                                                   value = 0 ) ,
                                                                      vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                             ),								
                             
                             
                             # data.frame(node,vintage,year_all,time)
                             capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 1 ) ,
                                                           vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                             
                             # data.frame( vintages, value )
                             construction_time = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 0	),
                             
                             # data.frame( vintages, value )
                             technical_lifetime = expand.grid( 	node = nds,
                                                                vintage = vtgs,
                                                                value = 1	),
                             
                             # data.frame( vintages, value )
                             inv_cost = expand.grid( node = nds,
                                                     vintage = vtgs,
                                                     value = 0	),
                             
                             # data.frame( node, vintages, year_all, value )
                             fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 0	),
                                                    vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                             
                             # data.frame( node, vintage, year_all, mode, time, value ) 
                             var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                              vintage = vtgs,
                                                                              
                                                                              time = time,
                                                                              value = 0.00165	),
                                                                vtg_year_time ) %>% 
                                                      dplyr::select( node, vintage, year_all, mode, time, value ) ,							
                                                    
                             
                             # data.frame(node,year_all,value)
                             historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "energy_gw_diversion",]
                             
),

# transfer surface to groundwater - backstop option for meeting flow constraints					
vtgs = year_all,
nds = bcus,
surface2ground = list( 	nodes = nds,
                        years = year_all,
                        times = time,
                        vintages = vtgs,	
                        types = c('water'),
                        modes = c( 1 ),
                        lifetime = 1,
                        
                        input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = c( 1 ), 
                                                                      commodity = 'electricity', 
                                                                      level = 'energy_secondary',
                                                                      value =  2.1) ,
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                            
                                            left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = c( 1 ), 
                                                                      commodity = 'freshwater', 
                                                                      level = 'river',
                                                                      value =  1 ) ,
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                            
                        ),
                        
                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'freshwater', 
                                                                      level = 'aquifer',
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                        ),	
                        
                        # data.frame( node,vintage,year_all,mode,emission) 
                        emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                              vintage = vtgs,
                                                                              mode = 1, 
                                                                              emission = 'water_consumption', 
                                                                              value = 0 ) ,
                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                        ),								
                        
                        
                        # data.frame(node,vintage,year_all,time)
                        capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 1 ) ,
                                                      vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                        
                        # data.frame( vintages, value )
                        construction_time = expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          value = 0	),
                        
                        # data.frame( vintages, value )
                        technical_lifetime = expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = 1	),
                        
                        # data.frame( vintages, value )
                        inv_cost = expand.grid( node = nds,
                                                vintage = vtgs,
                                                value = 0	),
                        
                        # data.frame( node, vintages, year_all, value )
                        fix_cost = left_join( 	expand.grid( 	node = nds,
                                                             vintage = vtgs,
                                                             value = 0	),
                                               vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                        
                        # data.frame( node, vintage, year_all, mode, time, value ) 
                        var_cost = NULL,							
                        
                        # data.frame(node,year_all,value)
                        historical_new_capacity = NULL
                        
),

# transfer groundwater to suface water - backstop option for meeting flow constraints
vtgs = year_all,
nds = bcus,
ground2surface = list( 	nodes = nds,
                        years = year_all,
                        times = time,
                        vintages = vtgs,	
                        types = c('water'),
                        modes = c( 1 ),
                        lifetime = 1,
                        
                        input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = c( 1 ), 
                                                                      commodity = 'electricity', 
                                                                      level = 'energy_secondary',
                                                                      value =  2.1 ) ,
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                            
                                            left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = c( 1 ), 
                                                                      commodity = 'freshwater', 
                                                                      level = 'aquifer',
                                                                      value =  1 ) ,
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                            
                        ),
                        
                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'freshwater', 
                                                                      level = 'river',
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                        ),	
                        
                        # data.frame( node,vintage,year_all,mode,emission) 
                        emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                              vintage = vtgs,
                                                                              mode = 1, 
                                                                              emission = 'water_consumption', 
                                                                              value = 0 ) ,
                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                        ),								
                        
                        
                        # data.frame(node,vintage,year_all,time)
                        capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 1 ) ,
                                                      vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                        
                        # data.frame( vintages, value )
                        construction_time = expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          value = 0	),
                        
                        # data.frame( vintages, value )
                        technical_lifetime = expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = 1	),
                        
                        # data.frame( vintages, value )
                        inv_cost = expand.grid( node = nds,
                                                vintage = vtgs,
                                                value = 0	),
                        
                        # data.frame( node, vintages, year_all, value )
                        fix_cost = left_join( 	expand.grid( 	node = nds,
                                                             vintage = vtgs,
                                                             value = 0	),
                                               vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                        
                        # data.frame( node, vintage, year_all, mode, time, value ) 
                        var_cost = NULL,							
                        
                        # data.frame(node,year_all,value)
                        historical_new_capacity = NULL
                        
),

# rural_wastewater_recycling
vtgs = year_all,
nds = bcus,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
rural_wastewater_recycling =  list( 	nodes = nds,
                                     years = year_all,
                                     times = time,
                                     vintages = vtgs,	
                                     types = c('water'),
                                     modes = c( 1 ),
                                     lifetime = 20,
                                     
                                     input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'electricity', 
                                                                                   level = 'rural_final',
                                                                                   value =  423.88 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                         
                                                         left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'wastewater', 
                                                                                   level = 'rural_secondary',
                                                                                   value =  1 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                         
                                     ),
                                     
                                     output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = 1, 
                                                                                   commodity = 'freshwater', 
                                                                                   level = 'rural_secondary',
                                                                                   value = 0.85 ) ,
                                                                     vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                     ),	
                                     left_join(  expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               commodity = 'fertilizer', 
                                                               level = 'agricultural_final',
                                                               value = 0.15 ) ,
                                                 vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                       dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
),
                                     
                                     # data.frame( node,vintage,year_all,mode,emission) 
                                     emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                           vintage = vtgs,
                                                                                           mode = 1, 
                                                                                           emission = 'water_consumption', 
                                                                                           value = 0.2 ) ,
                                                                              vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                     ),								
                                     
                                     
                                     # data.frame(node,vintage,year_all,time)
                                     capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                 vintage = vtgs,
                                                                                 value = 0.9 ) ,
                                                                   vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                     
                                     # data.frame( vintages, value )
                                     construction_time = expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = 1	),
                                     
                                     # data.frame( vintages, value )
                                     technical_lifetime = expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = lft	),
                                     
                                     # data.frame( vintages, value )
                                     inv_cost = expand.grid( node = nds,
                                                             vintage = vtgs,
                                                             value = 1350	),
                                     
                                     # data.frame( node, vintages, year_all, value )
                                     fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 99	),
                                                            vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                     
                                     # data.frame( node, vintage, year_all, mode, time, value ) 
                                     var_cost = NULL,							
                                     
                                     # data.frame(node,year_all,value)
                                     historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_wastewater_recycling",]
                                     
),
# Distributed diesel gensets for water pumping in agriculture sector
vtgs = year_all,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
nds = bcus,
irri_diesel_genset = list( 	nodes = nds,
                            years = year_all,
                            times = time,
                            vintages = vtgs,	
                            types = c('water'),
                            modes = c( 1 ),
                            lifetime = 20,
                            
                            input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'Diesel', 
                                                                          level = 'agricultural_final',
                                                                          value =  2.4 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                
                                                left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'freshwater', 
                                                                          level = 'energy_secondary',
                                                                          value =  1 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                
                            ),
                            
                            
                            output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          commodity = 'electricity', 
                                                                          level = 'irrigation_final',
                                                                          value = 1 ) ,
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                            ),	
                            
                            # data.frame( node,vintage,year_all,mode,emission) 
                            emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  emission = 'CO2', 
                                                                                  value = round( 0.0741 * 2.86 * 60 * 60 * 24 / 1e3, digits = 3 ) ) ,
                                                                     vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                            ),								
                            
                            
                            # data.frame(node,vintage,year_all,time)
                            capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 0.9 ) ,
                                                          vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                            
                            # data.frame( vintages, value )
                            construction_time = expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 1	),
                            
                            # data.frame( vintages, value )
                            technical_lifetime = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = lft	),
                            
                            # data.frame( vintages, value )
                            inv_cost = expand.grid( node = nds,
                                                    vintage = vtgs,
                                                    value = 0	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 value = 0.007	),
                                                   vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = left_join(  left_join( expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            mode = 1 ),
                                                              vtg_year_time ), 
                                                   fossil_fuel_cost_var %>% 
                                                     filter(commodity == "Diesel") %>% 
                                                     dplyr::select( year_all, value ) %>% 
                                                     mutate( value = round( (1 + value) * 0.125 , digits = 5 ) )
                            ) %>% dplyr::select( node,  vintage, year_all, mode, time, value ),							
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "irri_diesel_genset",]
                            
),

# Distributed diesel gensets for machinery in agriculture sector
vtgs = year_all,
lft = 20,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
agri_diesel_genset = list( 	nodes = nds,
                            years = year_all,
                            times = time,
                            vintages = vtgs,	
                            types = c('power'),
                            modes = c( 1 ),
                            lifetime = 20,
                            # Distributed diesel gensets for machinery in agriculture sector
                            vtgs = year_all
                            lft = 20
                            vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
                            vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
                            nds = bcus
                            agri_diesel_genset = list( 	nodes = nds,
                                                        years = year_all,
                                                        times = time,
                                                        vintages = vtgs,	
                                                        types = c('power'),
                                                        modes = c( 1 ),
                                                        lifetime = 20,
                                                        
                                                        input = NULL,
                                                        
                                                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                                      vintage = vtgs,
                                                                                                      mode = 1, 
                                                                                                      commodity = 'energy', 
                                                                                                      level = 'agriculture_final',
                                                                                                      value = 1 ) ,
                                                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                        ),	
                                                        
                                                        # data.frame( node,vintage,year_all,mode,emission) 
                                                        emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                                              vintage = vtgs,
                                                                                                              mode = 1, 
                                                                                                              emission = 'CO2', 
                                                                                                              value = round( 0.0741 * 2.86 * 60 * 60 * 24 / 1e3, digits = 3 ) ) ,
                                                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                        ),								
                                                        
                                                        
                                                        # data.frame(node,vintage,year_all,time)
                                                        capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                                    vintage = vtgs,
                                                                                                    value = 0.9 ) ,
                                                                                      vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                                        
                                                        # data.frame( vintages, value )
                                                        construction_time = expand.grid( 	node = nds,
                                                                                          vintage = vtgs,
                                                                                          value = 1	),
                                                        
                                                        # data.frame( vintages, value )
                                                        technical_lifetime = expand.grid( 	node = nds,
                                                                                           vintage = vtgs,
                                                                                           value = lft	),
                                                        
                                                        # data.frame( vintages, value )
                                                        inv_cost = expand.grid( node = nds,
                                                                                vintage = vtgs,
                                                                                value = 0.676	),
                                                        
                                                        # data.frame( node, vintages, year_all, value )
                                                        fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                                             vintage = vtgs,
                                                                                             value = 0.007	),
                                                                               vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                                        
                                                        # data.frame( node, vintage, year_all, mode, time, value ) 
                                                        var_cost = left_join(  left_join( expand.grid( 	node = nds,
                                                                                                        vintage = vtgs,
                                                                                                        mode = 1 ),
                                                                                          vtg_year_time ), 
                                                                               fossil_fuel_cost_var %>% 
                                                                                 filter(commodity == "crudeoil") %>% 
                                                                                 dplyr::select( year_all, value ) %>% 
                                                                                 mutate( value = round( (1 + value) * 0.088 , digits = 5 ) )
                                                        ) %>% dplyr::select( node,  vintage, year_all, mode, time, value ),							
                                                        
                                                        # data.frame(node,year_all,value)
                                                        historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "agri_diesel_genset",]
                                                        
                            ),       
                            
                            # # Distributed solar PV for water pumping in agriculture sector - assume pumping flexible to output (i.e., flexible load)
                            vtgs = year_all,
                            nds = bcus,
                            agri_pv = list( 	nodes = nds,
                                             years = year_all,
                                             times = time,
                                             vintages = vtgs,	
                                             types = c('water'),
                                             modes = c( 1 ),
                                             lifetime = 20,
                                             
                                             input = NULL,
                                             
                                             output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                           vintage = vtgs,
                                                                                           mode = 1, 
                                                                                           commodity = 'electricity', 
                                                                                           level = 'irrigation_final',
                                                                                           value = 1 ) ,
                                                                             vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                                   dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                             ),	
                                             
                                             # data.frame( node,vintage,year_all,mode,emission) 
                                             emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                                   vintage = vtgs,
                                                                                                   mode = 1, 
                                                                                                   emission = 'CO2', 
                                                                                                   value = round( 0 * 2.86 * 60 * 60 * 24 / 1e3, digits = 3 ) ) ,
                                                                                      vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                             ),								
                                             
                                             
                                             # data.frame(node,vintage,year_all,time)
                                             capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                         vintage = vtgs,
                                                                                         value = 0.25 ) ,
                                                                           vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                             
                                             # data.frame( vintages, value )
                                             construction_time = expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               value = 1	),
                                             
                                             # data.frame( vintages, value )
                                             technical_lifetime = expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                value = lft	),
                                             
                                             # data.frame( vintages, value )
                                             inv_cost = expand.grid( node = nds,
                                                                     vintage = vtgs,
                                                                     value = 1	),
                                             
                                             # data.frame( node, vintages, year_all, value )
                                             fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  value = 0.007	),
                                                                    vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                             
                                             # data.frame( node, vintage, year_all, mode, time, value ) 
                                             var_cost = NULL,							
                                             
                                             # data.frame(node,year_all,value)
                                             historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "agri_pv",]
                                             
                            ),
                            
                            # ##### Network technologies
                            
                            ## Technology to represent environmental flows - movement of water from river_in to river_out within the same PID
                            vtgs = year_all,
                            nds = bcus,
                            environmental_flow = list( 	nodes = nds,
                                                        years = year_all,
                                                        times = time,
                                                        vintages = vtgs,	
                                                        types = c('water'),
                                                        modes = c( 1 ),
                                                        lifetime = 1,
                                                        
                                                        input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                                      vintage = vtgs,
                                                                                                      mode = c( 1 ), 
                                                                                                      commodity = 'freshwater', 
                                                                                                      level = 'river_in',
                                                                                                      value =  1 ) ,
                                                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                                            
                                                        ),
                                                        
                                                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                                      vintage = vtgs,
                                                                                                      mode = 1, 
                                                                                                      commodity = 'freshwater', 
                                                                                                      level = 'river_out',
                                                                                                      value = 1 - ( 0.6 * 0.1 ) ) ,
                                                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                                            
                                                                            # left_join(  expand.grid( 	node = nds,
                                                                            # 							vintage = vtgs,
                                                                            # 							mode = 1, 
                                                                            # 							commodity = 'renewable_gw', 
                                                                            # 							level = 'aquifer',
                                                                            # 							value = 0.6 * 0.1 ) , # test value of 0.6 base flow index; 0.1 represents 10% baseflow as indicator for renewable GW availability from Gleeson and Richter 2017
                                                                            # 			vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                                            # 			dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                                                        ),	
                                                        
                                                        # data.frame( node,vintage,year_all,mode,emission) 
                                                        emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                                              vintage = vtgs,
                                                                                                              mode = 1, 
                                                                                                              emission = 'env_flow', 
                                                                                                              value = 1 ) ,
                                                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                                                        ),								
                                                        
                                                        
                                                        # data.frame(node,vintage,year_all,time)
                                                        capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                                    vintage = vtgs,
                                                                                                    value = 1 ) ,
                                                                                      vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                                        
                                                        # data.frame( vintages, value )
                                                        construction_time = expand.grid( 	node = nds,
                                                                                          vintage = vtgs,
                                                                                          value = 0	),
                                                        
                                                        # data.frame( vintages, value )
                                                        technical_lifetime = expand.grid( 	node = nds,
                                                                                           vintage = vtgs,
                                                                                           value = 1	),
                                                        
                                                        # data.frame( vintages, value )
                                                        inv_cost = expand.grid( node = nds,
                                                                                vintage = vtgs,
                                                                                value = 0	),
                                                        
                                                        # data.frame( node, vintages, year_all, value )
                                                        fix_cost = NULL, 
                                                        
                                                        # data.frame( node, vintage, year_all, mode, time, value ) 
                                                        var_cost = NULL,							
                                                        
                                                        # data.frame(node,year_all,value)
                                                        historical_new_capacity = NULL
                            ),
                            
                            ## Technology to represent internal inflows in the node, move water to the river_in level and assign internal hydropower runoff potential
                            vtgs = year_all,
                            nds = bcus,
                            initial_nodes = as.character(basin.spdf@data$PID[!basin.spdf@data$PID %in% basin.spdf@data$DOWN]),
                            tmp = bind_rows( lapply( initial_nodes, function( ii ){ data.frame(node = ii,
                                                                                               qnt = quantile( unlist( water_resources.df[ which( water_resources.df$node == ii), 
                                                                                                                                           grepl( '2015', names(water_resources.df) ) ] ) , 0.75 )
                            ) } ) ),
                            internal_runoff = list( 	nodes = nds,
                                                     years = year_all,
                                                     times = time,
                                                     vintages = vtgs,	
                                                     types = c('water'),
                                                     modes = c( 1 ),
                                                     lifetime = 1,
                                                     
                                                     input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                                   vintage = vtgs,
                                                                                                   mode = c( 1 ), 
                                                                                                   commodity = 'freshwater', 
                                                                                                   level = 'inflow',
                                                                                                   value =  1 ) ,
                                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                                         
                                                     ),
                                                     
                                                     output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                                   vintage = vtgs,
                                                                                                   mode = 1, 
                                                                                                   commodity = 'freshwater', 
                                                                                                   level = 'river_in',
                                                                                                   value = 1 ),
                                                                                     vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                                           dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ) #,	
                                                                         
                                                                         # left_join(  expand.grid( 	node = nds,
                                                                         # vintage = vtgs,
                                                                         # mode = 1, 
                                                                         # commodity = 'hydro_potential_river', 
                                                                         # level = 'energy_secondary' ),
                                                                         # vtg_year_time ) %>% left_join(
                                                                         # water_resources.df %>%
                                                                         # mutate( value = river_mw_per_km3_per_day / 1e3 ) %>%
                                                                         # dplyr::select( node,value )) %>% 
                                                                         # filter(value > 0) %>% 
                                                                         # mutate( node_out = node, time_out = time ) %>% 
                                                                         # dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                                                         
                                                                         # left_join(  expand.grid( 	node = initial_nodes,
                                                                         # vintage = vtgs,
                                                                         # mode = 1, 
                                                                         # commodity = 'hydro_potential_old', 
                                                                         # level = 'energy_secondary' ),
                                                                         # vtg_year_time ) %>% left_join(
                                                                         # water_resources.df %>% filter(node %in% initial_nodes) %>% 
                                                                         # left_join(tmp) %>% 
                                                                         # mutate( value =  as.numeric(( existing_MW + planned_MW ) / qnt / 1e3)) %>% 
                                                                         # dplyr::select(node,value) ) %>% 
                                                                         # filter(value > 0) %>% 
                                                                         # mutate( node_out = node, time_out = time ) %>% 
                                                                         # dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                                                                         
                                                     ),	
                                                     
                                                     
                                                     
                                                     # data.frame( node,vintage,year_all,mode,emission) 
                                                     emission_factor = NULL,								
                                                     
                                                     
                                                     # data.frame(node,vintage,year_all,time)
                                                     capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                                                 vintage = vtgs,
                                                                                                 value = 1 ) ,
                                                                                   vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                                                     
                                                     # data.frame( vintages, value )
                                                     construction_time = expand.grid( 	node = nds,
                                                                                       vintage = vtgs,
                                                                                       value = 0	),
                                                     
                                                     # data.frame( vintages, value )
                                                     technical_lifetime = expand.grid( 	node = nds,
                                                                                        vintage = vtgs,
                                                                                        value = 1	),
                                                     
                                                     # data.frame( vintages, value )
                                                     inv_cost = expand.grid( node = nds,
                                                                             vintage = vtgs,
                                                                             value = 0	),
                                                     
                                                     # data.frame( node, vintages, year_all, value )
                                                     fix_cost = NULL, 
                                                     
                                                     # data.frame( node, vintage, year_all, mode, time, value ) 
                                                     var_cost = NULL,							
                                                     
                                                     # data.frame(node,year_all,value)
                                                     historical_new_capacity = NULL
                                                     
                            )
                 

                 

# ##### Network technologies

## Technology to represent environmental flows - movement of water from river_in to river_out within the same PID
vtgs = year_all,
nds = bcus,
environmental_flow = list( 	nodes = nds,
                            years = year_all,
                            times = time,
                            vintages = vtgs,	
                            types = c('water'),
                            modes = c( 1 ),
                            lifetime = 1,
                            
                            input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'freshwater', 
                                                                          level = 'river_in',
                                                                          value =  1 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                
                            ),
                            
                            output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          commodity = 'freshwater', 
                                                                          level = 'river_out',
                                                                          value = 0.95 ) ,
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                
                                                left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          commodity = 'renewable_gw', 
                                                                          level = 'aquifer',
                                                                          value = 0.6 * 0.1 ) , # test value of 0.6 base flow index; 0.1 represents 10% baseflow as indicator for renewable GW availability from Gleeson and Richter 2017
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                            ),	
                            
                            # data.frame( node,vintage,year_all,mode,emission) 
                            emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  emission = 'env_flow', 
                                                                                  value = 1 ) ,
                                                                     vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                            ),								
                            
                            
                            # data.frame(node,vintage,year_all,time)
                            capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 1 ) ,
                                                          vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                            
                            # data.frame( vintages, value )
                            construction_time = expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 0	),
                            
                            # data.frame( vintages, value )
                            technical_lifetime = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 1	),
                            
                            # data.frame( vintages, value )
                            inv_cost = expand.grid( node = nds,
                                                    vintage = vtgs,
                                                    value = 0	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = NULL, 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = NULL,							
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = NULL
                            
),

## River network - technologies that move surface water between PIDs
vtgs = year_all,
lft = 1,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
river_names = NULL,
for( iii in 1:length( basin.spdf ) )
{
  
  # Use the network mapping contained with the basin shapefile
  bi = as.character( basin.spdf@data$PID[ iii ] )
  bo = as.character( basin.spdf@data$DOWN[ iii ] )
  
  if( !is.na( bo ) ){ # A downstream basin exists
    
    # Output to downstream basin while producing hydropower potential 
    outx = bind_rows( 	expand.grid( 	node = bi,
                                     mode = 1,
                                     vintage = vtgs,
                                     time = time,
                                     commodity = 'freshwater',
                                     level = 'river_in',
                                     value = 0.75 ) %>%
                         mutate( node_out = bo, time_out = time, year_all = vintage ) %>%
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                       
                       expand.grid( 	node = bi,
                                     mode = 1,
                                     vintage = vtgs,
                                     time = time,
                                     commodity = 'hydro_potential_old',
                                     level = 'energy_secondary',
                                     value =  water_resources.df %>%
                                       filter( node == bi ) %>%
                                       mutate( value =  as.numeric(( existing_MW + planned_MW ) / quantile( unlist( water_resources.df[ which( water_resources.df$node == bi), grepl( '2015', names(water_resources.df) ) ] ) , 0.75 ) / 1e3 )) %>%
                                       dplyr::select( value ) %>% unlist() ) %>%	
                         mutate( node_out = node, time_out = time, year_all = vintage ) %>%
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                       
                       expand.grid( 	node = bi,
                                     mode = 1,
                                     vintage = vtgs,
                                     time = time,
                                     commodity = 'hydro_potential_river',
                                     level = 'energy_secondary',
                                     value =  water_resources.df %>%
                                       filter( node == bi ) %>%
                                       mutate( value = river_mw_per_km3_per_day / 1e3 ) %>%
                                       dplyr::select( value ) %>% unlist() ) %>%	
                         mutate( node_out = node, time_out = time, year_all = vintage ) %>%
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )	
                       
    )
    
  }else{ # No downstream basin - sink or outlet, i.e., no downstream node in the core model
    
    bo = 'SINK'  
    
    outx = bind_rows( 	left_join(  data.frame( commodity = 'hydro_potential_old', 
                                               level = 'energy_secondary', 
                                               mode = 1, 
                                               node = bi,
                                               vintage = vtgs,
                                               value = water_resources.df %>%
                                                 filter( node == bi ) %>%
                                                 mutate( value =  ( existing_MW + planned_MW ) / quantile( get( names(water_resources.df)[ grepl( '2015', names(water_resources.df) ) ] ) , 0.75 ) / 1e3 ) %>%
                                                 dplyr::select( value ) %>% unlist() ),
                                   vtg_year_time ) %>%
                         mutate( node_out = node, time_out = time ) %>%							
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                       
                       left_join(  data.frame( commodity = 'hydro_potential_river', 
                                               level = 'energy_secondary', 
                                               mode = 1, 
                                               node = bi,
                                               vintage = vtgs,
                                               value = water_resources.df %>%
                                                 filter( node == bi ) %>%
                                                 mutate( value = river_mw_per_km3_per_day / 1e3 ) %>%
                                                 dplyr::select( value ) %>% unlist() ),
                                   vtg_year_time ) %>%
                         mutate( node_out = node, time_out = time ) %>%							
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                       
    )
    
  }
  
  river_name = paste( 'river', bi, bo, sep = '|' ) 
  
  river_names = c( river_names, river_name )
  
  tlst = list( 	nodes = bi,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('water'),
                modes = c( 1 ),
                lifetime = 20,
                
                input = bind_rows( left_join(  expand.grid( 	node = bi,
                                                             vintage = vtgs,
                                                             mode = 1, 
                                                             commodity = 'freshwater', 
                                                             level = 'river_out',
                                                             value = 1 ) ,
                                               vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                     dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )	
                ),
                
                output = outx,
                
                # data.frame( node,vintage,year_all,mode,emission) 
                emission_factor = NULL,								
                
                
                # data.frame(node,vintage,year_all,time)
                capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                            vintage = vtgs,
                                                            value = 1 ) ,
                                              vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                
                # data.frame( vintages, value )
                construction_time = expand.grid( 	node = nds,
                                                  vintage = vtgs,
                                                  value = 0	),
                
                # data.frame( vintages, value )
                technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = 1	),
                
                # data.frame( vintages, value )
                inv_cost = expand.grid( node = nds,
                                        vintage = vtgs,
                                        value = 0	),
                
                # data.frame( node, vintages, year_all, value )
                fix_cost = left_join( 	expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = 0	),
                                       vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                
                # data.frame( node, vintage, year_all, mode, time, value ) 
                var_cost = NULL,							
                
                # data.frame(node,year_all,value)
                historical_new_capacity = NULL
                
  )
  
  assign( river_name, tlst )
  
}

river_routes = gsub('river\\|','',river_names),
## Conveyance - technologies that move surface water between PIDs
vtgs = year_all,
lft = 50,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
canal_names = NULL,

# Need to provide options for lined and unlined canals 
for( hhh in c( 'conv', 'lined' ) )
{
  
  if( hhh == 'conv' ){ eff = 0; cst = 1; flg = 1 }else{ eff = 0.15; cst = 1.5; flg = 0 } # set adders/mulitpliers for efficiency and costs between lined and unlined systems
  
  # Need to provide option for both directions as invididual investments as opposed to a single investment / bi-directional system - conveyance not typically operated bi-directionally
  adjacent_routes2 = c( adjacent_routes, paste( unlist( strsplit( adjacent_routes, '[|]' ) )[ seq( 2,2*length(adjacent_routes),by=2 ) ], unlist( strsplit( adjacent_routes, '[|]' ) )[ seq( 1,2*length(adjacent_routes),by=2 ) ], sep = '|'  ) )
  adjacent_routes2 = setdiff(adjacent_routes2,river_routes)
  # no cross national routes
  # adjacent_routes2 = adjacent_routes2[gsub('_.*', '',gsub('.*\\|', '',adjacent_routes2)) == 	gsub('_.*', '',gsub('\\|.*', '',adjacent_routes2))]
  
  can_inv_cost.df = rbind( can_inv_cost.df, can_inv_cost.df %>% mutate( tec = paste( unlist( strsplit( tec, '[|]' ) )[ seq( 2,2*length(tec),by=2 ) ], unlist( strsplit( tec, '[|]' ) )[ seq( 1,2*length(tec),by=2 ) ], sep = '|'  ) ) )
  for( iii in 1:length(adjacent_routes2) )
  {
    
    bi = unlist( strsplit( as.character( adjacent_routes2[iii] ), '[|]' ) )[1]
    bo = unlist( strsplit( as.character( adjacent_routes2[iii] ), '[|]' ) )[2]
    
    if( adjacent_routes2[iii] %in% canals_agg.df$route ){ hc = round( canals_agg.df$capacity_m3_per_sec[ which( canals_agg.df$route == adjacent_routes2[iii] ) ] * 60 * 60 * 24 / 1e6, digits = 1 ) }else{ hc = 0 }
    
    canal_name = paste0( hhh, '_canal|', adjacent_routes2[iii] )
    
    canal_names = c( canal_names, canal_name )
    
    tlst = list( 	nodes = bi,
                  years = year_all,
                  times = time,
                  vintages = vtgs,	
                  types = c('water'),
                  modes = c( 1 ),
                  lifetime = 20,
                  
                  input = bind_rows(  left_join(  expand.grid( 	node = bi,
                                                                vintage = vtgs,
                                                                mode = 1, 
                                                                commodity = 'freshwater', 
                                                                level = 'river_out',
                                                                value = 1 ) , 
                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                                      left_join(  expand.grid( 	node = bi,
                                                                vintage = vtgs,
                                                                mode = 1, 
                                                                commodity = 'electricity', 
                                                                level = 'urban_final',
                                                                value = 12 ) , # ! Should be updated to unique value for each route
                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                  ),
                  
                  output = bind_rows( left_join(  expand.grid( 	node = bi,
                                                                vintage = vtgs,
                                                                mode = 1, 
                                                                commodity = 'freshwater', 
                                                                level = 'river_in',
                                                                value = 0.75 + eff ) , # assuming 25% losses - should be updated to align with seepage estimates
                                                  vtg_year_time ) %>% mutate( node_out = bo, time_out = time ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                  ),
                  
                  # data.frame( node,vintage,year_all,mode,emission) 
                  emission_factor = NULL,								
                  
                  
                  # data.frame(node,vintage,year_all,time)
                  capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 0.9 ) ,
                                                vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                  
                  # data.frame( vintages, value )
                  construction_time = expand.grid( 	node = nds,
                                                    vintage = vtgs,
                                                    value = 5	),
                  
                  # data.frame( vintages, value )
                  technical_lifetime = expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = lft	),
                  
                  # data.frame( vintages, value )
                  inv_cost = expand.grid( node = nds,
                                          vintage = vtgs,
                                          value = cst * can_inv_cost.df$value[ which( can_inv_cost.df$tec == adjacent_routes2[iii] | can_inv_cost.df$tec == paste( unlist( strsplit( adjacent_routes2[iii], '[|]' ))[c(2,1)] ,collapse='|') ) ] ),
                  
                  # data.frame( node, vintages, year_all, value )
                  fix_cost = left_join( 	expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = 0.05 * cst * can_inv_cost.df$value[ which( can_inv_cost.df$tec == adjacent_routes2[iii] | can_inv_cost.df$tec == paste( unlist( strsplit( adjacent_routes2[iii], '[|]' ))[c(2,1)] ,collapse='|') ) ]	),
                                         vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                  
                  # data.frame( node, vintage, year_all, mode, time, value ) 
                  var_cost = NULL,							
                  
                  # data.frame(node,year_all,value)
                  historical_new_capacity = expand.grid( node = bi, year_all = year_all, value = hc * flg ),
                  
                  # data.frame(node,year_all,value)
                  bound_total_capacity_lo = expand.grid(  node = bi, 
                                                          year_all = year_all, 
                                                          value = flg * max( c( 0, round( canals_agg.df %>% filter( route == adjacent_routes2[iii] ) %>% select( capacity_m3_per_sec )%>% unlist( . ) * 60 * 60 * 24 / 1e6, digits = 1 ) ), na.rm = TRUE ) ),
                  
                  bound_activity_lo = expand.grid( 	node = bi, 
                                                    year_all = year_all, 
                                                    mode = 1,
                                                    time = as.character( time ), 
                                                    value = flg * 0.2 * max( c( 0, round( canals_agg.df %>% filter( route == adjacent_routes2[iii] ) %>% select( capacity_m3_per_sec ) %>% unlist( . ) * 60 * 60 * 24 / 1e6, digits = 1 ) ), na.rm = TRUE ) )
                  
    )
    
    assign( canal_name, tlst )
    
  }	
  
}
# ##### Network technologies

## Technology to represent environmental flows - movement of water from river_in to river_out within the same PID
vtgs = year_all,
nds = bcus,
environmental_flow = list( 	nodes = nds,
                            years = year_all,
                            times = time,
                            vintages = vtgs,	
                            types = c('water'),
                            modes = c( 1 ),
                            lifetime = 1,
                            
                            input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = c( 1 ), 
                                                                          commodity = 'freshwater', 
                                                                          level = 'river_in',
                                                                          value =  1 ) ,
                                                            vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                
                            ),
                            
                            output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          commodity = 'freshwater', 
                                                                          level = 'river_out',
                                                                          value = 0.95 ) ,
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                                
                                                left_join(  expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          mode = 1, 
                                                                          commodity = 'renewable_gw', 
                                                                          level = 'aquifer',
                                                                          value = 0.6 * 0.1 ) , # test value of 0.6 base flow index; 0.1 represents 10% baseflow as indicator for renewable GW availability from Gleeson and Richter 2017
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                            ),	
                            
                            # data.frame( node,vintage,year_all,mode,emission) 
                            emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  emission = 'env_flow', 
                                                                                  value = 1 ) ,
                                                                     vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ) 
                            ),								
                            
                            
                            # data.frame(node,vintage,year_all,time)
                            capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 1 ) ,
                                                          vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                            
                            # data.frame( vintages, value )
                            construction_time = expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 0	),
                            
                            # data.frame( vintages, value )
                            technical_lifetime = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 1	),
                            
                            # data.frame( vintages, value )
                            inv_cost = expand.grid( node = nds,
                                                    vintage = vtgs,
                                                    value = 0	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = NULL, 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = NULL,							
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = NULL
                            
),

## River network - technologies that move surface water between PIDs
vtgs = year_all,
lft = 1,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
river_names = NULL,
for( iii in 1:length( basin.spdf ) )
{
  
  # Use the network mapping contained with the basin shapefile
  bi = as.character( basin.spdf@data$PID[ iii ] )
  bo = as.character( basin.spdf@data$DOWN[ iii ] )
  
  if( !is.na( bo ) ){ # A downstream basin exists
    
    # Output to downstream basin while producing hydropower potential 
    outx = bind_rows( 	expand.grid( 	node = bi,
                                     mode = 1,
                                     vintage = vtgs,
                                     time = time,
                                     commodity = 'freshwater',
                                     level = 'river_in',
                                     value = 0.75 ) %>%
                         mutate( node_out = bo, time_out = time, year_all = vintage ) %>%
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                       
                       expand.grid( 	node = bi,
                                     mode = 1,
                                     vintage = vtgs,
                                     time = time,
                                     commodity = 'hydro_potential_old',
                                     level = 'energy_secondary',
                                     value =  water_resources.df %>%
                                       filter( node == bi ) %>%
                                       mutate( value =  as.numeric(( existing_MW + planned_MW ) / quantile( unlist( water_resources.df[ which( water_resources.df$node == bi), grepl( '2015', names(water_resources.df) ) ] ) , 0.75 ) / 1e3 )) %>%
                                       dplyr::select( value ) %>% unlist() ) %>%	
                         mutate( node_out = node, time_out = time, year_all = vintage ) %>%
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                       
                       expand.grid( 	node = bi,
                                     mode = 1,
                                     vintage = vtgs,
                                     time = time,
                                     commodity = 'hydro_potential_river',
                                     level = 'energy_secondary',
                                     value =  water_resources.df %>%
                                       filter( node == bi ) %>%
                                       mutate( value = river_mw_per_km3_per_day / 1e3 ) %>%
                                       dplyr::select( value ) %>% unlist() ) %>%	
                         mutate( node_out = node, time_out = time, year_all = vintage ) %>%
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )	
                       
    )
    
  }else{ # No downstream basin - sink or outlet, i.e., no downstream node in the core model
    
    bo = 'SINK'  
    
    outx = bind_rows( 	left_join(  data.frame( commodity = 'hydro_potential_old', 
                                               level = 'energy_secondary', 
                                               mode = 1, 
                                               node = bi,
                                               vintage = vtgs,
                                               value = water_resources.df %>%
                                                 filter( node == bi ) %>%
                                                 mutate( value =  ( existing_MW + planned_MW ) / quantile( get( names(water_resources.df)[ grepl( '2015', names(water_resources.df) ) ] ) , 0.75 ) / 1e3 ) %>%
                                                 dplyr::select( value ) %>% unlist() ),
                                   vtg_year_time ) %>%
                         mutate( node_out = node, time_out = time ) %>%							
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                       
                       left_join(  data.frame( commodity = 'hydro_potential_river', 
                                               level = 'energy_secondary', 
                                               mode = 1, 
                                               node = bi,
                                               vintage = vtgs,
                                               value = water_resources.df %>%
                                                 filter( node == bi ) %>%
                                                 mutate( value = river_mw_per_km3_per_day / 1e3 ) %>%
                                                 dplyr::select( value ) %>% unlist() ),
                                   vtg_year_time ) %>%
                         mutate( node_out = node, time_out = time ) %>%							
                         dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                       
    )
    
  }
  
  river_name = paste( 'river', bi, bo, sep = '|' ) 
  
  river_names = c( river_names, river_name )
  
  tlst = list( 	nodes = bi,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('water'),
                modes = c( 1 ),
                lifetime = 20,
                
                input = bind_rows( left_join(  expand.grid( 	node = bi,
                                                             vintage = vtgs,
                                                             mode = 1, 
                                                             commodity = 'freshwater', 
                                                             level = 'river_out',
                                                             value = 1 ) ,
                                               vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                     dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )	
                ),
                
                output = outx,
                
                # data.frame( node,vintage,year_all,mode,emission) 
                emission_factor = NULL,								
                
                
                # data.frame(node,vintage,year_all,time)
                capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                            vintage = vtgs,
                                                            value = 1 ) ,
                                              vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                
                # data.frame( vintages, value )
                construction_time = expand.grid( 	node = nds,
                                                  vintage = vtgs,
                                                  value = 0	),
                
                # data.frame( vintages, value )
                technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = 1	),
                
                # data.frame( vintages, value )
                inv_cost = expand.grid( node = nds,
                                        vintage = vtgs,
                                        value = 0	),
                
                # data.frame( node, vintages, year_all, value )
                fix_cost = left_join( 	expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = 0	),
                                       vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                
                # data.frame( node, vintage, year_all, mode, time, value ) 
                var_cost = NULL,							
                
                # data.frame(node,year_all,value)
                historical_new_capacity = NULL
                
  )
  
  assign( river_name, tlst )
  
}

river_routes = gsub('river\\|','',river_names),
## Conveyance - technologies that move surface water between PIDs
vtgs = year_all,
lft = 50,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
canal_names = NULL,

# Need to provide options for lined and unlined canals 
for( hhh in c( 'conv', 'lined' ) )
{
  
  if( hhh == 'conv' ){ eff = 0; cst = 1; flg = 1 }else{ eff = 0.15; cst = 1.5; flg = 0 } # set adders/mulitpliers for efficiency and costs between lined and unlined systems
  
  # Need to provide option for both directions as invididual investments as opposed to a single investment / bi-directional system - conveyance not typically operated bi-directionally
  adjacent_routes2 = c( adjacent_routes, paste( unlist( strsplit( adjacent_routes, '[|]' ) )[ seq( 2,2*length(adjacent_routes),by=2 ) ], unlist( strsplit( adjacent_routes, '[|]' ) )[ seq( 1,2*length(adjacent_routes),by=2 ) ], sep = '|'  ) )
  adjacent_routes2 = setdiff(adjacent_routes2,river_routes)
  # no cross national routes
  # adjacent_routes2 = adjacent_routes2[gsub('_.*', '',gsub('.*\\|', '',adjacent_routes2)) == 	gsub('_.*', '',gsub('\\|.*', '',adjacent_routes2))]
  
  can_inv_cost.df = rbind( can_inv_cost.df, can_inv_cost.df %>% mutate( tec = paste( unlist( strsplit( tec, '[|]' ) )[ seq( 2,2*length(tec),by=2 ) ], unlist( strsplit( tec, '[|]' ) )[ seq( 1,2*length(tec),by=2 ) ], sep = '|'  ) ) )
  for( iii in 1:length(adjacent_routes2) )
  {
    
    bi = unlist( strsplit( as.character( adjacent_routes2[iii] ), '[|]' ) )[1]
    bo = unlist( strsplit( as.character( adjacent_routes2[iii] ), '[|]' ) )[2]
    
    if( adjacent_routes2[iii] %in% canals_agg.df$route ){ hc = round( canals_agg.df$capacity_m3_per_sec[ which( canals_agg.df$route == adjacent_routes2[iii] ) ] * 60 * 60 * 24 / 1e6, digits = 1 ) }else{ hc = 0 }
    
    canal_name = paste0( hhh, '_canal|', adjacent_routes2[iii] )
    
    canal_names = c( canal_names, canal_name )
    
    tlst = list( 	nodes = bi,
                  years = year_all,
                  times = time,
                  vintages = vtgs,	
                  types = c('water'),
                  modes = c( 1 ),
                  lifetime = 20,
                  
                  input = bind_rows(  left_join(  expand.grid( 	node = bi,
                                                                vintage = vtgs,
                                                                mode = 1, 
                                                                commodity = 'freshwater', 
                                                                level = 'river_out',
                                                                value = 1 ) , 
                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                                      left_join(  expand.grid( 	node = bi,
                                                                vintage = vtgs,
                                                                mode = 1, 
                                                                commodity = 'electricity', 
                                                                level = 'rural_final',
                                                                value = 12 ) , # ! Should be updated to unique value for each route
                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                  ),
                  
                  output = bind_rows( left_join(  expand.grid( 	node = bi,
                                                                vintage = vtgs,
                                                                mode = 1, 
                                                                commodity = 'freshwater', 
                                                                level = 'river_in',
                                                                value = 0.75 + eff ) , # assuming 25% losses - should be updated to align with seepage estimates
                                                  vtg_year_time ) %>% mutate( node_out = bo, time_out = time ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                  ),
                  
                  # data.frame( node,vintage,year_all,mode,emission) 
                  emission_factor = NULL,								
                  
                  
                  # data.frame(node,vintage,year_all,time)
                  capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 0.9 ) ,
                                                vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                  
                  # data.frame( vintages, value )
                  construction_time = expand.grid( 	node = nds,
                                                    vintage = vtgs,
                                                    value = 5	),
                  
                  # data.frame( vintages, value )
                  technical_lifetime = expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = lft	),
                  
                  # data.frame( vintages, value )
                  inv_cost = expand.grid( node = nds,
                                          vintage = vtgs,
                                          value = cst * can_inv_cost.df$value[ which( can_inv_cost.df$tec == adjacent_routes2[iii] | can_inv_cost.df$tec == paste( unlist( strsplit( adjacent_routes2[iii], '[|]' ))[c(2,1)] ,collapse='|') ) ] ),
                  
                  # data.frame( node, vintages, year_all, value )
                  fix_cost = left_join( 	expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = 0.05 * cst * can_inv_cost.df$value[ which( can_inv_cost.df$tec == adjacent_routes2[iii] | can_inv_cost.df$tec == paste( unlist( strsplit( adjacent_routes2[iii], '[|]' ))[c(2,1)] ,collapse='|') ) ]	),
                                         vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                  
                  # data.frame( node, vintage, year_all, mode, time, value ) 
                  var_cost = NULL,							
                  
                  # data.frame(node,year_all,value)
                  historical_new_capacity = expand.grid( node = bi, year_all = year_all, value = hc * flg ),
                  
                  # data.frame(node,year_all,value)
                  bound_total_capacity_lo = expand.grid(  node = bi, 
                                                          year_all = year_all, 
                                                          value = flg * max( c( 0, round( canals_agg.df %>% filter( route == adjacent_routes2[iii] ) %>% select( capacity_m3_per_sec )%>% unlist( . ) * 60 * 60 * 24 / 1e6, digits = 1 ) ), na.rm = TRUE ) ),
                  
                  bound_activity_lo = expand.grid( 	node = bi, 
                                                    year_all = year_all, 
                                                    mode = 1,
                                                    time = as.character( time ), 
                                                    value = flg * 0.2 * max( c( 0, round( canals_agg.df %>% filter( route == adjacent_routes2[iii] ) %>% select( capacity_m3_per_sec ) %>% unlist( . ) * 60 * 60 * 24 / 1e6, digits = 1 ) ), na.rm = TRUE ) )
                  
    )
    
    assign( canal_name, tlst )
    
  }	
  
}
# Need to provide option for both directions as invididual investments as opposed to a single investment / bi-directional system - conveyance not typically operated bi-directionally
adjacent_routes2 = c( adjacent_routes, paste( unlist( strsplit( adjacent_routes, '[|]' ) )[ seq( 2,2*length(adjacent_routes),by=2 ) ], unlist( strsplit( adjacent_routes, '[|]' ) )[ seq( 1,2*length(adjacent_routes),by=2 ) ], sep = '|'  ) ),

# # Remove options that are across borders 
# adjacent_routes2 = adjacent_routes2[ which( unlist( strsplit( unlist( strsplit( adjacent_routes2, '[|]' ) )[ seq( 1,2*length(adjacent_routes2), by=2 ) ], '_' ) )[ seq( 1,2*length(adjacent_routes2), by=2 ) ] ==
# 											unlist( strsplit( unlist( strsplit( adjacent_routes2, '[|]' ) )[ seq( 2,2*length(adjacent_routes2), by=2 ) ], '_' ) )[ seq( 1,2*length(adjacent_routes2), by=2 ) ] ) ]
# 
# Cost data
adjacent_routes2 = setdiff(adjacent_routes2,river_routes),

if (!FULL_COOPERATION) {
  # # Remove options that are across borders
  adjacent_routes2 = adjacent_routes2[gsub('_.*', '',gsub('.*\\|', '',adjacent_routes2)) == 	gsub('_.*', '',gsub('\\|.*', '',adjacent_routes2))]
} else{
} # end if
can_inv_cost.df = rbind( can_inv_cost.df, can_inv_cost.df %>% mutate( tec = paste( unlist( strsplit( tec, '[|]' ) )[ seq( 2,2*length(tec),by=2 ) ], unlist( strsplit( tec, '[|]' ) )[ seq( 1,2*length(tec),by=2 ) ], sep = '|'  ) ) ),

# Go through routes
for( iii in 1:length(adjacent_routes2) )
{
  
  bi = unlist( strsplit( as.character( adjacent_routes2[iii] ), '[|]' ) )[1]
  bo = unlist( strsplit( as.character( adjacent_routes2[iii] ), '[|]' ) )[2]
  
  if( adjacent_routes2[iii] %in% canals_agg.df$route ){ hc = round( canals_agg.df$capacity_m3_per_sec[ which( canals_agg.df$route == adjacent_routes2[iii] ) ] * 60 * 60 * 24 / 1e6, digits = 1 ) }else{ hc = 0 }
  
  canal_name = paste0( hhh, '_canal|', adjacent_routes2[iii] )
  
  canal_names = c( canal_names, canal_name )
  
  tlst = list( 	nodes = bi,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('water'),
                modes = c( 1 ),
                lifetime = 20,
                
                input = bind_rows(  left_join(  expand.grid( 	node = bi,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'river_out',
                                                              value = 1 ) , 
                                                vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                                    left_join(  expand.grid( 	node = bi,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'electricity', 
                                                              level = 'urban_final',
                                                              value = 12 ) , # ! Should be updated to unique value for each route
                                                vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                ),
                
                output = bind_rows( left_join(  expand.grid( 	node = bi,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'river_in',
                                                              value = 0.75 + eff ) , # assuming 25% losses - should be updated to align with seepage estimates
                                                vtg_year_time ) %>% mutate( node_out = bo, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                ),
                
                # data.frame( node,vintage,year_all,mode,emission) 
                emission_factor = NULL,								
                
                
                # data.frame(node,vintage,year_all,time)
                capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                            vintage = vtgs,
                                                            value = 0.9 ) ,
                                              vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                
                # data.frame( vintages, value )
                construction_time = expand.grid( 	node = nds,
                                                  vintage = vtgs,
                                                  value = 5	),
                
                # data.frame( vintages, value )
                technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = lft	),
                
                # data.frame( vintages, value )
                inv_cost = expand.grid( node = nds,
                                        vintage = vtgs,
                                        value = cst * can_inv_cost.df$value[ which( can_inv_cost.df$tec == adjacent_routes2[iii] | can_inv_cost.df$tec == paste( unlist( strsplit( adjacent_routes2[iii], '[|]' ))[c(2,1)] ,collapse='|') ) ] ),
                
                # data.frame( node, vintages, year_all, value )
                fix_cost = left_join( 	expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = 0.05 * cst * can_inv_cost.df$value[ which( can_inv_cost.df$tec == adjacent_routes2[iii] | can_inv_cost.df$tec == paste( unlist( strsplit( adjacent_routes2[iii], '[|]' ))[c(2,1)] ,collapse='|') ) ]	),
                                       vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                
                # data.frame( node, vintage, year_all, mode, time, value ) 
                var_cost = NULL,							
                
                # data.frame(node,year_all,value)
                historical_new_capacity = expand.grid( node = bi, year_all = year_all, value = hc * flg ),
                
                # data.frame(node,year_all,value)
                bound_total_capacity_lo = expand.grid(  node = bi, 
                                                        year_all = year_all, 
                                                        value = flg * max( c( 0, round( canals_agg.df %>% filter( route == adjacent_routes2[iii] ) %>% select( capacity_m3_per_sec )%>% unlist( . ) * 60 * 60 * 24 / 1e6, digits = 1 ) ), na.rm = TRUE ) ),
                
                bound_activity_lo = expand.grid( 	node = bi, 
                                                  year_all = year_all, 
                                                  mode = 1,
                                                  time = as.character( time ), 
                                                  value = flg * 0.2 * max( c( 0, round( canals_agg.df %>% filter( route == adjacent_routes2[iii] ) %>% select( capacity_m3_per_sec ) %>% unlist( . ) * 60 * 60 * 24 / 1e6, digits = 1 ) ), na.rm = TRUE ) )
                
  )
  
  assign( canal_name, tlst )
  
}	



# CROPS and irrigation technologies

# the number of crops and names can be decided by the user, it is basin specific 
# to select the main crops, and in this way many crops can be easily added
crp = crop_names,
# ittigation technologies are just 3 at the moment, and rain-fed irrigation
# is considered in addition

machinery_ei_kwh_per_kg = 0.13, # energy in per unit of crop production - Average from Rao et al. (2018)
irrigation_tecs = unique( irr_tech_data.df$irr_tech ),
# Define average efficiency for water once it reaches the farm-gate 
# Assuming all irrigation is basically flood irrigation based on disucssions with stakeholders
# Also aligns closely with asssumptions in Wu et al. (2013, World Bank) figure 5.4 
field_efficiency = 0.85,
water_course_efficiency = 0.55, # these numbers need to match the efficiencies used for calibration in crop_yields.r so perhaps good to explicility link later
field_efficiency_conv = field_efficiency * water_course_efficiency,
gwp_ch4 = unlist(gwp.df$CH4),
crop_ch4 = data.frame( crop = 'rice',  value = 1300 ), # default IPCC CH4 emission factor converted to metric tons per Mha per day
crop_tech_names = NULL,
rainfed_crop_names = NULL,
irr_tech_names = NULL,
lft.crops = data.frame(crop = crop_names,
                       lft = c(5,5,5,5,5,5,5,30,5)),
residue_data.dummy = residue_data %>% bind_rows(
  data.frame(crop = c('fruit','vegetables'), res_yield = c(0,0) , mode = c(8,9), liquid = c(0,0),
             ethanol_ratio = c(NA,NA), var_eth_cost = c(NA,NA)  ,stringsAsFactors = F)
),
for( ii in seq_along( crop_names ) )
{
  vtgs = year_all
  nds = bcus
  crop_tech_name = paste0('crop_',crop_names[ii])
  crop_tech_names = c( crop_tech_names, crop_tech_name )
  
  lft = lft.crops$lft[lft.crops$crop == crop_names[ii]]
  vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
  vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
  node_mode_vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( node = bcus, mode = 1, vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) )
  
  tmp = crop_input_data.df %>% filter(crop == crop_names[ii] & par == 'rain-fed_yield') %>% 
    dplyr::select(node,value)
  tmp = tmp %>% expand(tmp,time) %>% 
    left_join(crop_tech_data.df %>% 
                filter(crop == crop_names[ii] & par == 'crop_coef') %>% 
                rename(ccf = value) %>% 
                dplyr::select(time,ccf) ) %>%     #from yearly yield to monthly and scaled with crop coefficient
    mutate(value = value * ccf ) %>%  #kton/Mha
    filter(!is.na(value)) %>% 
    mutate(commodity = paste0(crop_names[ii],'_yield'))
  
  tlst = list(nodes = nds,
              years = year_all,
              times = time,
              vintages = vtgs,	
              types = c('land'),
              modes = c( 1 ),
              lifetime = lft,
              
              input =  left_join( tmp %>% expand(tmp, level = c('agriculture_final'), vintage = vtgs ) %>% # on-farm energy requirements for machinery
                                    mutate( mode = 1, time_in = time, node_in = node, commodity = 'energy' ) %>%
                                    mutate( value = round( machinery_ei_kwh_per_kg * value * ( 1 / 8760  ) * ( 1 / 1e3 ) * ( 1e6 / 1 ) , digits = 3 ) )	, # convert the intensity to MW per Mha - assumed it is evenly distributed across the year
                                  vtg_year ) %>% 
                dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
              
              output = bind_rows( 
                
                left_join( expand.grid( node = nds,
                                        commodity = paste0(crop_names[ii],'_land'), 
                                        vintage = vtgs,
                                        level = 'crop', 
                                        mode = 1, 
                                        value = 1 ), 
                           vtg_year_time )	%>%	mutate( node_out = node, time_out = time ) %>% 
                  dplyr::select(  node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ) ,
                
                # for the next df the time_output is yearly (annual yield demand)
                left_join( tmp %>% expand(tmp, level = c('raw','residue'), vintage = vtgs ) %>% 
                             mutate(mode = 1, time = time) %>% 
                             mutate(time_out = if_else(level == 'raw','year',time)) %>% 
                             mutate(node_out = if_else(level == 'raw',gsub('_.*','',node) ,node)) %>%
                             mutate(value = if_else(value == 0 , value, if_else(level == 'residue', ( residue_data.dummy$res_yield[ residue_data.dummy$crop == crop_names[ii] ] ) *ccf , value ) ) ),
                           vtg_year ) %>% 
                  dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )
                
              ),
              
              # data.frame( node,vintage,year_all,mode,emission) 
              emission_factor = NULL,
              
              #   rbind( left_join( fertilizer_emissions.df %>% filter( crop == crop_names[ii] ) %>%
              # 		filter( if( length( which( irrigation == 'rainfed' ) ) == 0 ) irrigation == 'irrigated' else irrigation == 'rainfed' ) %>%
              # 		group_by( PID, crop, emission ) %>% # 0.8 reflects that about 80% farmers using fertilizers at recommended rates
              # 		summarise( value = round( sum ( value ) * 1 / 365 * 1 / 1e3 * 1e6 / 1 * 0.8, digits = 3 ) ) %>% # convert from kg per year per hectare to metric tons per day per Mha
              # 		ungroup() %>% data.frame() %>%
              # 		rename( node = PID ),
              # 	node_mode_vtg_year ) %>%
              # 	select( node, vintage, year_all, mode, emission, value ), # add methane emissions 
              # 	left_join( 	node_mode_vtg_year, 
              # 				rbind( 	expand.grid( node = bcus, emission = 'CH4', value = max( 0, unlist( crop_ch4 %>% filter(crop==crop_names[ii]) %>% select(value) ), na.rm=TRUE ) ), 
              # 						expand.grid( node = bcus, emission = 'CO2eq', value = max( 0, unlist( crop_ch4 %>% filter(crop==crop_names[ii]) %>% select(value) ), na.rm=TRUE ) * gwp_ch4 ) ) ) ) %>% 
              # 	group_by( node, vintage, year_all, mode, emission ) %>% summarise( value = round( sum(value), digits = 3 ) ) %>%
              # 	ungroup() %>% data.frame(),						
              
              # data.frame(node,vintage,year_all,time)
              capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          value = 1 ) ,
                                            vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
              
              # data.frame( vintages, value )
              construction_time = expand.grid( 	node = nds,
                                                vintage = vtgs,
                                                value = 1	),
              
              # data.frame( vintages, value )
              technical_lifetime = expand.grid( 	node = nds,
                                                 vintage = vtgs,
                                                 value = lft	),
              
              # data.frame( vintages, value )
              inv_cost = expand.grid( node = nds,
                                      vintage = vtgs,
                                      value = crop_tech_data.df %>% 
                                        filter( crop == crop_names[ii], par == 'inv_cost' ) %>% 
                                        dplyr::select( value ) %>% 
                                        unlist() ),
              
              # data.frame( node, vintages, year_all, value )
              fix_cost = left_join( 	expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = crop_tech_data.df %>% 
                                                     filter( crop == crop_names[ii], par == 'fix_cost' ) %>% 
                                                     dplyr::select( value ) %>% 
                                                     unlist() ), 
                                     vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
              
              # data.frame( node, vintage, year_all, mode, time, value ) 
              var_cost = left_join( 	expand.grid( 	node = nds,
                                                   mode = 1,
                                                   vintage = vtgs,
                                                   value = crop_tech_data.df %>% 
                                                     filter( crop == crop_names[ii], par == 'var_cost' ) %>% 
                                                     dplyr::select( value ) %>% 
                                                     unlist() ), 
                                     vtg_year_time ) %>% dplyr::select( node, vintage, year_all, mode, time, value )	,	
              
              min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                vintage = vtgs,
                                                                value = 0.9	),
                                                  vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
              
              # data.frame(node,year_all,value)
              
              historical_new_capacity = 
                
                expand.grid(node = nds, year_all = c(2016) ) %>%
                left_join(	crop_input_data.df %>%
                             filter(crop == crop_names[ii] & par %in% c('crop_irr_land_2015','crop_rainfed_land_2015') ) %>%
                             mutate(crop = crop_tech_name, value = value ) %>%
                             dplyr::rename( tec = crop ) ) %>%
                group_by(node,tec,year_all) %>% 
                summarise(value = sum(value)) %>% ungroup() %>% 
                dplyr::select(node,tec,year_all,value)
              
  )
  
  
  assign( crop_tech_name, tlst )
  
  # rain-fed crops, will have particular parametrization, like yield,
  # for now we keep it separated from other irrigation technologies
  
  vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
  vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
  
  rainfed_crop_name = paste0('rainfed_',crop_names[ii])
  rainfed_crop_names = c( rainfed_crop_names, rainfed_crop_name  )
  tlst = list(nodes = nds,
              years = year_all,
              times = time,
              vintages = vtgs,	
              types = c('land'),
              modes = c( 1 ),
              lifetime = lft,
              
              input = left_join( expand.grid( node = nds,
                                              commodity = paste0(crop_names[ii],'_land'), 
                                              vintage = vtgs,
                                              level = 'crop', 
                                              mode = 1, 
                                              value = 1 ), 
                                 vtg_year_time )	%>%	mutate( node_in = node, time_in = time ) %>% 
                dplyr::select(  node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
              
              output = bind_rows( 
                
                left_join( expand.grid( node = nds,
                                        commodity = 'crop_land', 
                                        vintage = vtgs,
                                        level = 'area', 
                                        mode = 1, 
                                        value = 1 ), 
                           vtg_year_time )	%>%	mutate( node_out = node, time_out = time ) %>% 
                  dplyr::select(  node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )  
                
              ),
              
              # data.frame( node,vintage,year_all,mode,emission) emissions allocated to crop land area and to irrigation tec
              emission_factor = NULL,
              
              # data.frame(node,vintage,year_all,time)
              capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          value = 1 ) ,
                                            vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
              
              # data.frame( vintages, value )
              construction_time = expand.grid( 	node = nds,
                                                vintage = vtgs,
                                                value = 1	),
              
              # data.frame( vintages, value )
              technical_lifetime = expand.grid( 	node = nds,
                                                 vintage = vtgs,
                                                 value = lft	),
              
              # data.frame( vintages, value )
              inv_cost = expand.grid( node = nds,
                                      vintage = vtgs,
                                      value = 0 ),
              
              # data.frame( node, vintages, year_all, value )
              fix_cost = left_join( 	expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = 0 ), 
                                     vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
              
              # data.frame( node, vintage, year_all, mode, time, value ) 
              var_cost = left_join( 	expand.grid( 	node = nds,
                                                   mode = 1,
                                                   vintage = vtgs,
                                                   value = 0), 
                                     vtg_year_time ) %>% dplyr::select( node, vintage, year_all, mode, time, value ),							
              
              # data.frame(node,year_all,value)
              historical_new_capacity =  expand.grid(node = nds, year_all = c(2016) ) %>%
                left_join( crop_input_data.df %>%
                             dplyr::filter(crop == crop_names[ii] & par == 'crop_rainfed_land_2016') %>%
                             mutate( crop = rainfed_crop_name, value = round( value, digits = 5 ) ) %>%
                             dplyr::rename( tec = crop )
                ) %>% dplyr::select(node,tec,year_all,value)
              
  )
  
  assign( rainfed_crop_name, tlst )
  
  for (jj in seq_along(irrigation_tecs)){
    
    
    vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
    vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
    
    irr_tech_name = paste0(irrigation_tecs[jj],'_',crop_names[ii])
    irr_tech_names = c( irr_tech_names, irr_tech_name)
    tmp = crop_input_data.df %>% filter(crop == crop_names[ii]) %>% 
      spread(par,value) %>% 
      mutate(irrigation_yield = if_else(is.na(irrigation_yield),0,irrigation_yield),
             `rain-fed_yield` = if_else(is.na(`rain-fed_yield` ),0,`rain-fed_yield` ) ) %>% 
      mutate(value = irrigation_yield - `rain-fed_yield`) %>% 
      dplyr::select(node,value)
    tmp = tmp %>% expand(tmp,time) %>% 
      left_join(	crop_tech_data.df %>% 
                   filter(crop == crop_names[ii] & par == 'crop_coef') %>% 
                   rename(ccf = value) %>% 
                   dplyr::select(time,ccf) ) %>% 
      mutate(value = value * ccf) %>%  #kton/Mha
      dplyr::filter(!is.na(value)) %>% 
      mutate(commodity = paste0(crop_names[ii],'_yield'))
    
    if (grepl('irr_flood_',irr_tech_name)){
      tmp_hist_new_cap =  expand.grid(node = nds, year_all = c(2015) ) %>%
        left_join( crop_input_data.df %>%
                     dplyr::filter(crop == crop_names[ii] & par == 'crop_irr_land_2015') %>%
                     mutate( crop = irr_tech_name, value = round( value, digits = 5 ) ) %>%
                     dplyr::rename( tec = crop )
        ) %>% dplyr::select(node,tec,year_all,value)
    } else {
      tmp_hist_new_cap =  NULL
    }
    
    tlst = list( 	nodes = nds,
                  years = year_all,
                  times = time,
                  vintages = vtgs,	
                  types = c('land'),
                  modes = 1,
                  lifetime = lft,
                  
                  input = bind_rows(  left_join(  
                    expand.grid( 	node = nds,
                                  vintage = vtgs,
                                  mode = 1, 
                                  commodity = paste0(crop_names[ii],'_land'), 
                                  level = 'crop',
                                  value = 1 ) ,
                    vtg_year_time ) %>% 
                      mutate( node_in = node, time_in = time ) %>% 
                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                    
                    # crop water requirement scaled to represent water taken from irrigation diversions 
                    # need to divide by the field efficiency multiplied by the efficiency of the irrigation tech to estimate water requirement at the crop-level
                    # Note that additional efficiency losses are accounted for in 'irrigation_sw_diversion', to account for the distribution losses
                    left_join( crop_water.df %>% filter(crop == crop_names[ii]) %>% 
                                 dplyr::rename( year_all = year ) %>%
                                 mutate( value = ( 1 / unlist( 	irr_tech_data.df %>% 
                                                                  filter( irr_tech == irrigation_tecs[jj], par == 'water_efficiency' ) %>% 
                                                                  select( value ) %>% unlist( . ) * 
                                                                  field_efficiency_conv ) 
                                 ) * value, time = as.character( time ) ) %>%
                                 mutate( commodity = 'freshwater', level = 'irrigation_final',  mode = 1, node_in = node, time_in = time ),
                               vtg_year ) %>%	
                      filter(year_all <= lastyear) %>% 
                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ) %>%
                      mutate( value = round( value, digits = 3 ) ),
                    
                    # Operational electricity for the irrigation tech - varies based on water use
                    left_join( crop_water.df %>% filter(crop == crop_names[ii]) %>% 
                                 dplyr::rename( year_all = year ) %>%
                                 mutate( value = ( 1 / unlist( 	irr_tech_data.df %>% 
                                                                  filter( irr_tech == irrigation_tecs[jj], par == 'water_efficiency' ) %>% 
                                                                  select( value ) %>% unlist( . ) * 
                                                                  field_efficiency_conv ) 
                                 ) * value, time = as.character( time ) ) %>%
                                 mutate( commodity = 'electricity', level = 'irrigation_final',  mode = 1, node_in = node, time_in = time ),
                               vtg_year ) %>%	
                      filter(year_all <= lastyear) %>% 
                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ) %>%
                      mutate( value = value * irr_tech_data.df %>% # multiply water use per area by electricity use per water to get electricity per activity
                                filter( irr_tech == irrigation_tecs[jj], par == 'electricity_intensity' ) %>% 
                                select( value ) %>% unlist( . ) ) %>% 
                      mutate( value = round( value, digits = 3 ) )
                    
                  ), 
                  
                  output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                vintage = vtgs,
                                                                mode = 1, 
                                                                commodity = 'crop_land', 
                                                                level = 'area',
                                                                value = 1 ) ,
                                                  vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )	,
                                      
                                      # for the next df the time_output is yearly (annual yield demand)
                                      left_join( tmp %>% expand(tmp, level = c('raw','residue'), vintage = vtgs ) %>% 
                                                   mutate(mode = 1, time = time) %>% 
                                                   mutate(time_out = if_else(level == 'raw','year',time)) %>% 
                                                   mutate(node_out = if_else(level == 'raw',gsub('_.*','',node) ,node)) %>%
                                                   mutate(value = if_else(value == 0 , value, if_else(level == 'residue', ( residue_data.dummy$res_yield[ residue_data.dummy$crop == crop_names[ii] ] ) *ccf , value ) ) ),
                                                 vtg_year ) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ) ,
                                      
                                      # irrigation losses contribute to groundwater recharge		
                                      left_join( crop_water.df %>% filter(crop == crop_names[ii]) %>% 
                                                   dplyr::rename( year_all = year ) %>%
                                                   mutate( value = (( 1 / unlist( irr_tech_data.df %>% 
                                                                                    filter( irr_tech == irrigation_tecs[jj], par == 'water_efficiency' ) %>% 
                                                                                    select( value ) %>% unlist( . ) * field_efficiency_conv ) )-1 ) * value, time = as.character( time ) ) %>%
                                                   mutate( commodity = 'renewable_gw', level = 'aquifer',  mode = 1, node_out = node, time_out = time ),
                                                 vtg_year ) %>%	
                                        filter(year_all <= lastyear) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                      
                                      # Operational electricity flexibility for the smart irrigation tech - varies based on water use
                                      left_join( crop_water.df %>% filter(crop == crop_names[ii]) %>% 
                                                   dplyr::rename( year_all = year ) %>%
                                                   mutate( value = ( 1 / unlist( 	irr_tech_data.df %>% 
                                                                                    filter( irr_tech == irrigation_tecs[jj], par == 'water_efficiency' ) %>% 
                                                                                    select( value ) %>% unlist( . ) * 
                                                                                    field_efficiency_conv ) 
                                                   ) * value, time = as.character( time ) ) %>%
                                                   mutate( commodity = 'flexibility', level = 'energy_secondary',  mode = 1, node_in = node, time_in = time ),
                                                 vtg_year ) %>%	
                                        filter(year_all <= lastyear) %>% 
                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ) %>%
                                        mutate( value = value * irr_tech_data.df %>% # multiply water use per area by electricity use per water to get electricity per area 
                                                  filter( irr_tech == irrigation_tecs[jj], par %in% c( 'electricity_intensity', 'electricity_flexibility' ) ) %>% 
                                                  select( value ) %>% unlist( . ) %>% min( c( prod( . ), 0 ) ) ) %>% # electricity flexibility impacts depend on electricity demand level - avoid double counting flexibility impacts included in distribution techs									
                                        mutate( value = round( value, digits = 3 ) ) %>%
                                        rename( node_out = node_in, time_out = time_in )		
                                      
                                      
                                      
                  ),	
                  
                  # data.frame( node,vintage,year_all,mode,emission) - difference between the irrigated and rain fed to avoid doible counting
                  emission_factor = NULL,
                  
                  # right_join(
                  # 	left_join( fertilizer_emissions.df %>% filter( crop == crop_names[ii] ) %>%
                  # 		filter( if( length( which( irrigation == 'rainfed' ) ) == 0 ) irrigation == 'irrigated' else irrigation == 'rainfed' ) %>%
                  # 		group_by( PID, crop, emission ) %>%
                  # 		summarise( value = sum ( value ) * 1 / 365 * 1 / 1e3 * 1e6 / 1 * 0.8 ) %>% ungroup() %>% data.frame() %>%
                  # 		rename( node = PID ), node_mode_vtg_year ) %>%
                  # 	select( node, vintage, year_all, mode, emission, value ) %>% rename( value2 = value ),
                  # 	left_join( fertilizer_emissions.df %>% filter( crop == crop_names[ii] ) %>%
                  # 			filter( irrigation == 'irrigated') %>%
                  # 			group_by( PID, crop, emission ) %>%
                  # 			summarise( value = sum ( value ) * 1 / 365 * 1 / 1e3 * 1e6 / 1 * 0.8 ) %>% # 0.8 reflects that about 80% farmers using fertilizers at recommended rates
                  # 			ungroup() %>% data.frame() %>%
                  # 		rename( node = PID ), node_mode_vtg_year ) %>%
                  # 	select( node, vintage, year_all, mode, emission, value ) ) %>%
                  # 		mutate( value2 = ifelse( is.na(value2), 0, value2 ) ) %>%
                  # 		mutate( value = round( value-value2 , digits = 3 ) ) %>%
                  # 		select( node, vintage, year_all, mode, emission, value ),										
                  
                  # data.frame(node,vintage,year_all,time)
                  capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              value = 1 ) ,
                                                vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                  
                  # data.frame( vintages, value )
                  construction_time = expand.grid( 	node = nds,
                                                    vintage = vtgs,
                                                    value = 0	),
                  
                  # data.frame( vintages, value )
                  technical_lifetime = expand.grid( 	node = nds,
                                                     vintage = vtgs,
                                                     value = lft	),
                  
                  # data.frame( vintages, value )
                  inv_cost = expand.grid( node = nds,
                                          vintage = vtgs,
                                          value = irr_tech_data.df %>% 
                                            filter( irr_tech == irrigation_tecs[ jj ], par == 'inv_cost' ) %>%
                                            select( value ) %>% unlist() ),
                  
                  # data.frame( node, vintages, year_all, value )
                  fix_cost = left_join( 	expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = irr_tech_data.df %>% 
                                                         filter( irr_tech == irrigation_tecs[ jj ], par == 'fix_cost' ) %>%
                                                         select( value ) %>% unlist() ), 
                                         vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                  
                  # data.frame( node, vintage, year_all, mode, time, value ) 
                  var_cost = left_join( 	expand.grid( 	node = nds,
                                                       mode = 1,	
                                                       vintage = vtgs,
                                                       value = irr_tech_data.df %>% 
                                                         filter( irr_tech == irrigation_tecs[ jj ], par == 'var_cost' ) %>%
                                                         select( value ) %>% unlist() ),
                                         vtg_year_time ) %>% dplyr::select( node, vintage, year_all, mode, time, value ),
                  
                  min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 0.9	),
                                                      vtg_year ) %>% dplyr::select( node, vintage, year_all, value ) ,
                  
                  # data.frame(node,year_all,value)
                  
                  historical_new_capacity =  tmp_hist_new_cap
    )
    
    assign( irr_tech_name, tlst )
    
  }
  
}

# fellow crops, do not consume of produce anything, no costs, just consume land,
# it is required to not necessarily use all the available land and still having
# a full commodity balance
vtgs = year_all,
lft = 1,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
fallow_crop	 = list( 	nodes = nds,
                      years = year_all,
                      times = time,
                      vintages = vtgs,	
                      types = c('land'),
                      modes = 1,
                      lifetime = lft,
                      
                      input = NULL, 
                      
                      output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    mode = 1, 
                                                                    commodity = 'crop_land', 
                                                                    level = 'area',
                                                                    value = 1 ) ,
                                                      vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                            dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )	
                                          
                      ),	
                      
                      # data.frame( node,vintage,year_all,mode,emission) 
                      emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                            vintage = vtgs,
                                                                            mode = 1, 
                                                                            emission = 'CO2', 
                                                                            value = 0 ) ,
                                                               vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                                    
                      ),										
                      
                      # data.frame(node,vintage,year_all,time)
                      capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 1 ) ,
                                                    vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                      
                      # data.frame( vintages, value )
                      construction_time = expand.grid( 	node = nds,
                                                        vintage = vtgs,
                                                        value = 0	),
                      
                      # data.frame( vintages, value )
                      technical_lifetime = expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = lft	),
                      
                      # data.frame( vintages, value )
                      inv_cost = expand.grid( node = nds,
                                              vintage = vtgs,
                                              value = 0	),
                      
                      # data.frame( node, vintages, year_all, value )
                      fix_cost = left_join( 	expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = 0	),
                                             vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                      
                      # data.frame( node, vintage, year_all, mode, time, value ) 
                      var_cost = left_join( 	expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           mode = 1,
                                                           value =0 ) ,	 # 5.2E-3 M$/kt transport costs	
                                             vtg_year_time ) %>% dplyr::select( node, vintage, year_all, mode, time, value ),				
                      
                      
                      # data.frame(node,vintage,year_all,value)
                      min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 0	),
                                                          vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                      
                      # data.frame(node,year_all,value)
                      historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "fallow_crop",]
                      
),

## biomass converions into ethanol or solid, including transport
vtgs = year_all,
lft = 30,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
nds = bcus,
solid_biom = list( 	nodes = nds,
                    years = year_all,
                    times = time,
                    vintages = vtgs,	
                    types = c('power'),
                    modes = residue_data$mode,
                    lifetime = lft,
                    
                    input = left_join( 	left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = residue_data$mode, 
                                                                  level = 'residue',
                                                                  value = 1	),
                                                    data.frame( mode = residue_data$mode, commodity = paste0( residue_data$crop, '_yield' ) ) 
                    ), vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ), 
                    
                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = residue_data$mode, 
                                                                  commodity = 'biomass', 
                                                                  level = 'solid',
                                                                  value = 1 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )	
                                        
                    ),	
                    
                    # data.frame( node,vintage,year_all,mode,emission) 
                    emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                          vintage = vtgs,
                                                                          mode = residue_data$mode, 
                                                                          emission = 'CO2', 
                                                                          value = 0 ) ,
                                                             vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                                  
                    ),										
                    
                    # data.frame(node,vintage,year_all,time)
                    capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                vintage = vtgs,
                                                                value = 0.9 ) ,
                                                  vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                    
                    # data.frame( vintages, value )
                    construction_time = expand.grid( 	node = nds,
                                                      vintage = vtgs,
                                                      value = 5	),
                    
                    # data.frame( vintages, value )
                    technical_lifetime = expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = lft	),
                    
                    # data.frame( vintages, value )
                    inv_cost = expand.grid( node = nds,
                                            vintage = vtgs,
                                            value = 0	),
                    
                    # data.frame( node, vintages, year_all, value )
                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = 0	),
                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                    
                    # data.frame( node, vintage, year_all, mode, time, value ) 
                    var_cost = left_join( 	expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         mode = residue_data$mode,
                                                         value = 5.2E-3 ) ,	 # 5.2E-3 M$/kt transport costs	
                                           vtg_year_time ) %>% dplyr::select( node, vintage, year_all, mode, time, value ),				
                    
                    
                    # data.frame(node,vintage,year_all,value)
                    min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 0.2	),
                                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                    
                    # data.frame(node,year_all,value)
                    historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "solid_biom",]
                    
),
#solid biomass tratment, and trnasport (drying is usually done at the power plant, using waste heat)
vtgs = year_all,
nds = bcus,
lft = 30,
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) ,
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) ,
liq_modes = unlist( ( residue_data %>% filter(liquid > 0))['mode'] )
ethanol_prod = list( 	nodes = nds,
                      years = year_all,
                      times = time,
                      vintages = vtgs,	
                      types = c('power'),
                      modes = liq_modes,
                      lifetime = lft,
                      
                      input = bind_rows(  left_join( 	left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = liq_modes, 
                                                                                level = 'residue' ),
                                                                  data.frame( mode = liq_modes, value = round( 1 / ( residue_data %>% filter(liquid > 0) %>% dplyr::select( ethanol_ratio ) %>% unlist() ), digits = 5 ),
                                                                              commodity = paste0(residue_data$crop[residue_data$liquid > 0],'_yield') ) 
                      ), vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                      
                      left_join(  expand.grid( 	node = nds,
                                                vintage = vtgs,
                                                mode = liq_modes, 
                                                commodity = 'freshwater', 
                                                level = 'energy_secondary',
                                                value = 3 ),
                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                      
                      ),
                      
                      output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    mode = liq_modes, 
                                                                    commodity = 'biomass', 
                                                                    level = 'ethanol',
                                                                    value = 1 ) ,
                                                      vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                            dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )	
                                          
                      ),	
                      
                      # data.frame( node,vintage,year_all,mode,emission) 
                      emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                            vintage = vtgs,
                                                                            mode = liq_modes, 
                                                                            emission = 'CO2', 
                                                                            value = 0 ) ,
                                                               vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value ),
                                                    
                                                    left_join( expand.grid( node = nds,
                                                                            vintage = vtgs,
                                                                            mode = liq_modes, 
                                                                            emission = 'water_consumption', 
                                                                            value = 3 ) ,
                                                               vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                                    
                      ),										
                      
                      # data.frame(node,vintage,year_all,time)
                      capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 0.9 ) ,
                                                    vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                      
                      # data.frame( vintages, value )
                      construction_time = expand.grid( 	node = nds,
                                                        vintage = vtgs,
                                                        value = 5	),
                      
                      # data.frame( vintages, value )
                      technical_lifetime = expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = lft	),
                      
                      # data.frame( vintages, value )
                      inv_cost = expand.grid( node = nds,
                                              vintage = vtgs,
                                              value = 1.064	),
                      
                      # data.frame( node, vintages, year_all, value )
                      fix_cost = left_join( 	expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = 0.016	),
                                             vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                      
                      # data.frame( node, vintage, year_all, mode, time, value ) 
                      var_cost = left_join( 	left_join( 	expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = liq_modes ),
                                                         data.frame( mode = liq_modes, value = 5.2E-3 +( residue_data %>% filter(liquid > 0) %>% dplyr::select( var_eth_cost ) %>% unlist() ) ) ),	 # 5.2E-3 M$/kt transport costs	
                                             vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, mode, time, value ),				
                      
                      
                      # data.frame(node,vintage,year_all,value)
                      min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = 0.2	),
                                                          vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                      
                      # data.frame(node,year_all,value)
                      historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "ethanol_prod",],
                      
                      # bound_new_capacity_up(node,inv_tec,year)
                      bound_total_capacity_up = expand.grid( 	node = nds, year_all = c(2020,2030,2040,2050,2060), value = 1	)
                      
),			

# Ethanol generator, rural areas only
ethanol_genset = list( 	nodes = nds,
                        years = year_all,
                        times = time,
                        vintages = vtgs,	
                        types = c('power'),
                        modes = c(1,2),
                        lifetime = lft,
                        
                        input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = c(1,2), 
                                                                      commodity = 'biomass', 
                                                                      level = 'ethanol',
                                                                      value = 1/0.33 ),
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                            
                        ),
                        
                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'electricity', 
                                                                      level = 'irrigation_final',
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                            left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 2, 
                                                                      commodity = 'electricity', 
                                                                      level = 'rural_final',
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )					
                                            
                        ),	
                        
                        # data.frame( node,vintage,year_all,mode,emission) 
                        emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                              vintage = vtgs,
                                                                              mode = c(1,2), 
                                                                              emission = 'CO2', 
                                                                              value = round( 0.0741 * 2.86 * 60 * 60 * 24 / 1e3, digits = 3 ) ) ,
                                                                 vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                                      
                        ),										
                        
                        # data.frame(node,vintage,year_all,time)
                        capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 0.9 ) ,
                                                      vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                        
                        # data.frame( vintages, value )
                        construction_time = expand.grid( 	node = nds,
                                                          vintage = vtgs,
                                                          value = 5	),
                        
                        # data.frame( vintages, value )
                        technical_lifetime = expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = lft	),
                        
                        # data.frame( vintages, value )
                        inv_cost = expand.grid( node = nds,
                                                vintage = vtgs,
                                                value = 0.676	),
                        
                        # data.frame( node, vintages, year_all, value )
                        fix_cost = left_join( 	expand.grid( 	node = nds,
                                                             vintage = vtgs,
                                                             value = 0.007	),
                                               vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                        
                        # data.frame( node, vintage, year_all, mode, time, value ) 
                        var_cost = bind_rows( 	left_join( expand.grid( node = nds,
                                                                       vintage = vtgs,
                                                                       mode = c(1,2),
                                                                       value = 0 ),
                                                          vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, mode, time, value )
                        ),				
                        
                        
                        # data.frame(node,vintage,year_all,value)
                        min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 0.2	),
                                                            vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                        
                        # data.frame(node,year_all,value)
                        historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "ethanol_genset",],
                        
                        # bound_total_capacity_up(node,inv_tec,year)
                        bound_total_capacity_up = expand.grid( 	node = nds, year_all = c(2020,2030,2040,2050,2060), value = 1	)
                        
),

# pectin generator, on-farm machinery
ethanol_agri_genset = list( 	nodes = nds,
                             years = year_all,
                             times = time,
                             vintages = vtgs,	
                             types = c('power'),
                             modes = c(1),
                             lifetime = lft,
                             
                             input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = c(1), 
                                                                           commodity = 'biomass', 
                                                                           level = 'pectin',
                                                                           value = 0.357 ),
                                                             vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                                 
                             ),
                             
                             output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                           vintage = vtgs,
                                                                           mode = 1, 
                                                                           commodity = 'pectin', 
                                                                           level = 'agriculture_final',
                                                                           value = 1 ) ,
                                                             vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                   dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value )				
                                                 
                             ),	
                             
                             # data.frame( node,vintage,year_all,mode,emission) 
                             emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c(1), 
                                                                                   emission = 'CO2', 
                                                                                   value = round( 0.0741 * 2.86 * 60 * 60 * 24 / 1e3, digits = 3 ) ) ,
                                                                      vtg_year ) %>% dplyr::select( node,  vintage, year_all, mode, emission, value )
                                                           
                             ),										
                             
                             # data.frame(node,vintage,year_all,time)
                             capacity_factor = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 0.9 ) ,
                                                           vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, time, value ),
                             
                             # data.frame( vintages, value )
                             construction_time = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 5	),
                             
                             # data.frame( vintages, value )
                             technical_lifetime = expand.grid( 	node = nds,
                                                                vintage = vtgs,
                                                                value = lft	),
                             
                             # data.frame( vintages, value )
                             inv_cost = expand.grid( node = nds,
                                                     vintage = vtgs,
                                                     value = 2000	),
                             
                             # data.frame( node, vintages, year_all, value )
                             fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 0.537),
                                                    vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                             
                             # data.frame( node, vintage, year_all, mode, time, value ) 
                             var_cost = bind_rows( 	left_join( expand.grid( node = nds,
                                                                            vintage = vtgs,
                                                                            mode = c(1),
                                                                            value = 0 ),
                                                               vtg_year_time ) %>% dplyr::select( node,  vintage, year_all, mode, time, value )
                             ),				
                             
                             
                             # data.frame(node,vintage,year_all,value)
                             min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                               vintage = vtgs,
                                                                               value = 0.33	),
                                                                 vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                             
                             # data.frame(node,year_all,value)
                             historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "pectin_agri_genset",],
                             
                             # bound_new_capacity_up(node,inv_tec,year)
                             bound_total_capacity_up = expand.grid( 	node = nds, year_all = c(2020,2030,2040,2050,2060), value = 1	)
                             
)					

