# geothermal with closed loop cooling
vtgs = year_all
nds = bcus
geothermal_cl =  list( 	nodes = nds,
                        years = year_all,
                        times = time,
                        vintages = vtgs,	
                        types = c('power'),
                        modes = c( 1),
                        lifetime = lft,
                        
                        input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'freshwater', 
                                                                      level = 'energy_secondary',
                                                                      value =  0.019 ) ,
                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                            ),
                        
                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'electricity', 
                                                                      level = 'energy_secondary',
                                                                      value = 1 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                            
                                            left_join(   expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = 2, 
                                                                       commodity = 'electricity', 
                                                                       level = 'energy_secondary',
                                                                       value = 1 * dCF ) ,
                                                         vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                            
                                            left_join(  expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      mode = 1, 
                                                                      commodity = 'freshwater', 
                                                                      level = 'river_out',
                                                                      value = 0.0010 ) ,
                                                        vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                            
                                            left_join(   expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = 2, 
                                                                       commodity = 'freshwater', 
                                                                       level = 'river_out',
                                                                       value = round( 0.0010, digits = 5 ) ) ,
                                                         vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                              dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                            
                                            left_join(   expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       mode = 2, 
                                                                       commodity = 'flexibility', 
                                                                       level = 'energy_secondary',
                                                                       value = 0.15 ) ,
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
                                                          value = 5	),
                        
                        # data.frame( vintages, value )
                        technical_lifetime = expand.grid( 	node = nds,
                                                           vintage = vtgs,
                                                           value = lft	),
                        
                        # data.frame( vintages, value )
                        inv_cost = expand.grid( node = nds,
                                                vintage = vtgs,
                                                value = 6.343	),
                        
                        # data.frame( node, vintages, year_all, value )
                        fix_cost = left_join( 	expand.grid( 	node = nds,
                                                             vintage = vtgs,
                                                             value = 0.135	),
                                               vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                        
                        # data.frame( node, vintage, year_all, mode, time, value ) 
                        var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         mode = 1,
                                                                         time = time,
                                                                         value = 0	),
                                                           vtg_year_time ) %>% 
                                                 dplyr::select( node, vintage, year_all, mode, time, value ) ,
                                               
                                               left_join(  expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         mode = 2,
                                                                         time = time,
                                                                         value = 0.018	),
                                                           vtg_year_time ) %>% 
                                                 dplyr::select( node, vintage, year_all, mode, time, value ) 
                                               
                        ),							
                        
                        
                        # data.frame(node,vintage,year_all,value)
                        min_utilization_factor = left_join( expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 0.5	),
                                                            vtg_year ) %>% dplyr::select( node, vintage, year_all, value ),
                        
                        # data.frame(node,year_all,value)
                        historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "geothermal_cl",],
                        
                        # bound_new_capacity_up(node,inv_tec,year)
                        bound_new_capacity_up = expand.grid( 	node = nds, year_all = c(2020,2030), value = 5	),
                        
                        # data.frame(node,inv_tec,year)
                        growth_new_capacity_up = expand.grid( 	node = nds, year_all = c(2030,2040,2050,2060), value = 0.05	)
                        
)

# solar PV (utility-scale)
vtgs = year_all
nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "solar_1"]))
solar_pv_1 = list( 	nodes = 'Gheshlagh_Esfantaje',
                    years = year_all,
                    times = time,
                    vintages = vtgs,	
                    types = c('power'),
                    modes = c( 1 ),
                    lifetime = lft,
                    
                    input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'freshwater', 
                                                                  level = 'energy_secondary',
                                                                  value =  0 ) ,
                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                        
                    ),
                    
                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'electricity', 
                                                                  level = 'energy_secondary',
                                                                  value = 686.8 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                        
                                        left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'freshwater', 
                                                                  level = 'river_out',
                                                                  value = 0 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                        
                                        left_join(   expand.grid( 	node = nds,
                                                                   vintage = vtgs,
                                                                   mode = 1, 
                                                                   commodity = 'flexibility', 
                                                                   level = 'energy_secondary',
                                                                   value = -0.05 ) ,
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
                                                      value = 5	),
                    
                    # data.frame( vintages, value )
                    technical_lifetime = expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = lft	),
                    
                    # data.frame( vintages, value )
                    inv_cost = expand.grid( node = nds,
                                            vintage = vtgs,
                                            value = 0.4	),
                    
                    # data.frame( node, vintages, year_all, value )
                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = 0.004	),
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
                    
)

nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "solar_2"]))
solar_pv_2 = list( 	nodes = 'Yay',
                    years = year_all,
                    times = time,
                    vintages = vtgs,	
                    types = c('power'),
                    modes = c( 1 ),
                    lifetime = lft,
                    
                    input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'freshwater', 
                                                                  level = 'energy_secondary',
                                                                  value =  0 ) ,
                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                        
                    ),
                    
                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'electricity', 
                                                                  level = 'energy_secondary',
                                                                  value = 686.8 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                        
                                        left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'freshwater', 
                                                                  level = 'river_out',
                                                                  value = 0 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                        
                                        left_join(   expand.grid( 	node = nds,
                                                                   vintage = vtgs,
                                                                   mode = 1, 
                                                                   commodity = 'flexibility', 
                                                                   level = 'energy_secondary',
                                                                   value = -0.05 ) ,
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
                                                      value = 5	),
                    
                    # data.frame( vintages, value )
                    technical_lifetime = expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = lft	),
                    
                    # data.frame( vintages, value )
                    inv_cost = expand.grid( node = nds,
                                            vintage = vtgs,
                                            value = 0.4	),
                    
                    # data.frame( node, vintages, year_all, value )
                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = 0.004	),
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
                    
)
solar_pv_3 = list( 	nodes = 'Haris_Some_Ashan',
                    years = year_all,
                    times = time,
                    vintages = vtgs,	
                    types = c('power'),
                    modes = c( 1 ),
                    lifetime = lft,
                    
                    input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'freshwater', 
                                                                  level = 'energy_secondary',
                                                                  value =  0 ) ,
                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )
                                        
                    ),
                    
                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'electricity', 
                                                                  level = 'energy_secondary',
                                                                  value = 686.8 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                        
                                        left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = 1, 
                                                                  commodity = 'freshwater', 
                                                                  level = 'river_out',
                                                                  value = 0 ) ,
                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                        
                                        left_join(   expand.grid( 	node = nds,
                                                                   vintage = vtgs,
                                                                   mode = 1, 
                                                                   commodity = 'flexibility', 
                                                                   level = 'energy_secondary',
                                                                   value = -0.05 ) ,
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
                                                      value = 5	),
                    
                    # data.frame( vintages, value )
                    technical_lifetime = expand.grid( 	node = nds,
                                                       vintage = vtgs,
                                                       value = lft	),
                    
                    # data.frame( vintages, value )
                    inv_cost = expand.grid( node = nds,
                                            vintage = vtgs,
                                            value = 0.4	),
                    
                    # data.frame( node, vintages, year_all, value )
                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                         vintage = vtgs,
                                                         value = 0.004	),
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
                    
)

# Wind (utility-scale)
vtgs = year_all
nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "wind_1"]))
wind_1 = list( 	nodes = nds,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('power'),
                modes = c( 1 ),
                lifetime = lft,
                
                input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'energy_secondary',
                                                              value =  0 ) ,
                                                vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                                    
                ),
                
                output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'electricity', 
                                                              level = 'energy_secondary',
                                                              value = 1 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'river_out',
                                                              value = 0 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    left_join(   expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               commodity = 'flexibility', 
                                                               level = 'energy_secondary',
                                                               value = -0.08 ) ,
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
                                                  value = 5	),
                
                # data.frame( vintages, value )
                technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = lft	),
                
                # data.frame( vintages, value )
                inv_cost = expand.grid( node = nds,
                                        vintage = vtgs,
                                        value = 7.000	),
                
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
                
)

nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "wind_2"]))
wind_2 = list( 	nodes = nds,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('power'),
                modes = c( 1 ),
                lifetime = lft,
                
                input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'energy_secondary',
                                                              value =  0 ) ,
                                                vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                                    
                ),
                
                output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'electricity', 
                                                              level = 'energy_secondary',
                                                              value = 1 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'river_out',
                                                              value = 0 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    left_join(   expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               commodity = 'flexibility', 
                                                               level = 'energy_secondary',
                                                               value = -0.08 ) ,
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
                                                  value = 5	),
                
                # data.frame( vintages, value )
                technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = lft	),
                
                # data.frame( vintages, value )
                inv_cost = expand.grid( node = nds,
                                        vintage = vtgs,
                                        value = 7.000	),
                
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
                  filter( tec == 'wind_2' ) %>% 
                  expand( data.frame( node, value  ), year_all ) %>%
                  dplyr::select( node, year_all, value )
                
)

nds = as.character(unique(capacity_factor_sw.df$node[capacity_factor_sw.df$tec == "wind_3"]))
wind_3 = list( 	nodes = nds,
                years = year_all,
                times = time,
                vintages = vtgs,	
                types = c('power'),
                modes = c( 1 ),
                lifetime = lft,
                
                input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'energy_secondary',
                                                              value =  0 ) ,
                                                vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),	
                                    
                ),
                
                output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'electricity', 
                                                              level = 'energy_secondary',
                                                              value = 1 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    left_join(  expand.grid( 	node = nds,
                                                              vintage = vtgs,
                                                              mode = 1, 
                                                              commodity = 'freshwater', 
                                                              level = 'river_out',
                                                              value = 0 ) ,
                                                vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                      dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    
                                    left_join(   expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               commodity = 'flexibility', 
                                                               level = 'energy_secondary',
                                                               value = -0.08 ) ,
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
                                                  value = 1	),
                
                # data.frame( vintages, value )
                technical_lifetime = expand.grid( 	node = nds,
                                                   vintage = vtgs,
                                                   value = lft	),
                
                # data.frame( vintages, value )
                inv_cost = expand.grid( node = nds,
                                        vintage = vtgs,
                                        value = 7.000	),
                
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
                
)
# electricity_distribution_urban - generation to end-use within the same spatial unit
vtgs = year_all
nds = bcus
tmp = demand.df %>% filter(commodity == 'electricity' & level == 'urban_final' & year_all == 2015) %>% 
  mutate(year_all = as.numeric(year_all)) %>% 
  group_by(node,year_all,units) %>% 
  summarise(value = sum(value)) %>% 
  mutate(tec = 'electricity_distribution_urban') %>% 
  dplyr::select(node,tec,year_all,value) %>% ungroup() %>% 
  mutate(value = 0.5 * value)
electricity_distribution_urban =  
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
                                                       level = 'urban_final',
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
           bind_rows(tmp %>% mutate(year_all = 2010))						
         
  )

# electricity_distribution_industry - generation to end-use within the same spatial unit
vtgs = year_all
nds = bcus
tmp = demand.df %>% filter(commodity == 'electricity' & level == 'industry_final' & year_all == 2015) %>% 
  mutate(year_all = as.numeric(year_all)) %>% 
  group_by(node,year_all,units) %>% 
  summarise(value = sum(value)) %>% 
  mutate(tec = 'electricity_distribution_industry') %>% 
  dplyr::select(node,tec,year_all,value) %>% ungroup() %>% 
  mutate(value = 0.5 * value)				
electricity_distribution_industry =  
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
                                                       level = 'industry_final',
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
           bind_rows(tmp %>% mutate(year_all = 2010))						
         
  )				

# electricity_distribution_rural - generation to end-use within the same spatial unit
vtgs = year_all
nds = bcus
tmp = demand.df %>% filter(commodity == 'electricity' & level == 'rural_final' & year_all == 2015) %>% 
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
           bind_rows(tmp %>% mutate(year_all = 2010))						
         
  )

# electricity_distribution_irrigation - generation to end-use within the same spatial unit
vtgs = year_all
nds = bcus
tmp = demand.df %>% filter(commodity == 'electricity' & level == 'irrigation_final' & year_all == 2015) %>% 
  mutate(year_all = as.numeric(year_all)) %>% 
  group_by(node,year_all,units) %>% 
  summarise(value = sum(value)) %>% 
  mutate(tec = 'electricity_distribution_irrigation') %>% 
  dplyr::select(node,tec,year_all,value) %>% ungroup() %>% 
  mutate(value = 0.5 * value)
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
           bind_rows(tmp %>% mutate(year_all = 2010))						
         
  )

# electricity_shtort term storage
vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
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
         
  )

# Electricity transmission
vtgs = year_all
lft = 30
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
for( jjj in 1:length(adjacent_routes) ){ # add
  
  routes_names <- paste0('trs_',adjacent_routes)
  
  assign( routes_names[jjj], 
          
          list( 	nodes = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[1],
                 years = year_all,
                 times = time,
                 vintages = vtgs,	
                 types = c('power'),
                 modes = c( 1,2 ),
                 lifetime = lft,
                 
                 input = bind_rows(  left_join(  expand.grid( 	node = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[1],
                                                               node_in = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[1],
                                                               vintage = vtgs,
                                                               mode = c(1), 
                                                               commodity = 'electricity', 
                                                               level = 'energy_secondary',
                                                               value =  1 ) ,
                                                 vtg_year_time ) %>% mutate( time_in = time ) %>% 
                                       dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                     
                                     left_join(  expand.grid( 	node = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[1],
                                                               node_in = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[2],
                                                               vintage = vtgs,
                                                               mode = c(2), 
                                                               commodity = 'electricity', 
                                                               level = 'energy_secondary',
                                                               value =  1 ) ,
                                                 vtg_year_time ) %>% mutate( time_in = time ) %>% 
                                       dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )		
                                     
                 ),
                 
                 output = bind_rows( left_join(  expand.grid( 	node = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[1],
                                                               node_out = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[2],
                                                               vintage = vtgs,
                                                               mode = 1, 
                                                               commodity = 'electricity', 
                                                               level = 'energy_secondary',
                                                               value = 1 - trs_eff.df$value[trs_eff.df$tec == adjacent_routes[jjj]] ) ,
                                                 vtg_year_time ) %>% mutate( time_out = time ) %>% 
                                       dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),
                                     
                                     left_join(  expand.grid( 	node = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[1],
                                                               node_out = unlist( strsplit( adjacent_routes[jjj], '[|]' ) )[1],
                                                               vintage = vtgs,
                                                               mode = 2, 
                                                               commodity = 'electricity', 
                                                               level = 'energy_secondary',
                                                               value = 1 - trs_eff.df$value[trs_eff.df$tec == adjacent_routes[jjj]] ) ,
                                                 vtg_year_time ) %>% mutate( time_out = time ) %>% 
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
                                                   value = 5	),
                 
                 # data.frame( vintages, value )
                 technical_lifetime = expand.grid( 	node = nds,
                                                    vintage = vtgs,
                                                    value = lft	),
                 
                 # data.frame( vintages, value )
                 inv_cost = expand.grid( node = nds,
                                         vintage = vtgs,
                                         value = trs_inv_cost.df$value[trs_inv_cost.df$tec == adjacent_routes[jjj]] ),
                 
                 # data.frame( node, vintages, year_all, value )
                 fix_cost = left_join( 	expand.grid( 	node = nds,
                                                      vintage = vtgs,
                                                      value = 0.05 * trs_inv_cost.df$value[trs_inv_cost.df$tec == adjacent_routes[jjj]] ),
                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                 
                 # data.frame( node, vintage, year_all, mode, time, value ) 
                 var_cost = bind_rows( 	left_join(  expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  mode = c(1,2),
                                                                  time = time,
                                                                  value = trs_hurdle.df$hurdle[as.character(trs_hurdle.df$tec) == adjacent_routes[jjj]]	),
                                                    vtg_year_time ) %>% 
                                          dplyr::select( node, vintage, year_all, mode, time, value ) 
                                        
                 ),
                 
                 historical_new_capacity = transmission_routes.df[transmission_routes.df$tec == routes_names[jjj],]					
                 
          )
          
          
  ) 
  
}
#### Water technologies

# gw_extract					
vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
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
                    var_cost = NULL,							
                    
                    # data.frame(node,year_all,value)
                    historical_new_capacity = NULL
                    
)

vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
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
                          var_cost = NULL,							
                          
                          # data.frame(node,year_all,value)
                          historical_new_capacity = NULL
                          
)					

# urban_sw_diversion 
vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_sw_diversion = list( 	nodes = nds,
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
                                                                          level = 'urban_final',
                                                                          value =  6 ) ,
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
                                                                          level = 'urban_secondary',
                                                                          value = 1 ) ,
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
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
                                                              value = 0	),
                            
                            # data.frame( vintages, value )
                            technical_lifetime = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 15	),
                            
                            # data.frame( vintages, value )
                            inv_cost = expand.grid( node = nds,
                                                    vintage = vtgs,
                                                    value = 57	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 value = 3	),
                                                   vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = NULL,							
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "urban_sw_diversion",]
                            
)

# urban_gw_diversion 
vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_gw_diversion = list( 	nodes = nds,
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
                                                                          level = 'urban_final',
                                                                          value =  13 ) ,
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
                                                                          level = 'urban_secondary',
                                                                          value = 1 ) ,
                                                            vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
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
                                                              value = 0	),
                            
                            # data.frame( vintages, value )
                            technical_lifetime = expand.grid( 	node = nds,
                                                               vintage = vtgs,
                                                               value = 15	),
                            
                            # data.frame( vintages, value )
                            inv_cost = expand.grid( node = nds,
                                                    vintage = vtgs,
                                                    value = 20	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 value = 8.5	),
                                                   vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = NULL,							
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "urban_gw_diversion",]
                            
)

# urban_piped_distribution 
vtgs = year_all
nds = bcus
lft = 50
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_piped_distribution = list( 	nodes = nds,
                                  years = year_all,
                                  times = time,
                                  vintages = vtgs,	
                                  types = c('water'),
                                  modes = c( 1 ),
                                  lifetime = lft,
                                  
                                  input = bind_rows(  left_join(  expand.grid( node = nds,
                                                                               vintage = vtgs,
                                                                               mode = c( 1 ), 
                                                                               commodity = 'electricity', 
                                                                               level = 'urban_final',
                                                                               value =  6 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                      
                                                      left_join(  expand.grid( node = nds,
                                                                               vintage = vtgs,
                                                                               mode = c( 1 ), 
                                                                               commodity = 'freshwater', 
                                                                               level = 'urban_secondary',
                                                                               value =  1 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                      
                                  ),
                                  
                                  output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = 1, 
                                                                                commodity = 'freshwater', 
                                                                                level = 'urban_final',
                                                                                value = 1 ) ,
                                                                  vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
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
                                                                    value = 1	),
                                  
                                  # data.frame( vintages, value )
                                  technical_lifetime = expand.grid( 	node = nds,
                                                                     vintage = vtgs,
                                                                     value = lft	),
                                  
                                  # data.frame( vintages, value )
                                  inv_cost = expand.grid( node = nds,
                                                          vintage = vtgs,
                                                          value = 1013	),
                                  
                                  # data.frame( node, vintages, year_all, value )
                                  fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = 252	),
                                                         vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                  
                                  # data.frame( node, vintage, year_all, mode, time, value ) 
                                  var_cost = NULL,							
                                  
                                  # data.frame(node,year_all,value)
                                  historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "urban_piped_distribution",]
                                  
)

# urban_unimproved_distribution 
vtgs = year_all
nds = bcus
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_unimproved_distribution = list( 	nodes = nds,
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
                                                                                     level = 'urban_final',
                                                                                     value =  0 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                           
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'urban_secondary',
                                                                                     value =  1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )		
                                                           
                                       ),
                                       
                                       output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1, 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'urban_final',
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

# urban_wastewater_collection
vtgs = year_all
nds = bcus
lft = 30
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_wastewater_collection = list( 	nodes = nds,
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
                                                                                   level = 'urban_final',
                                                                                   value =  6 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                         
                                                         left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'wastewater', 
                                                                                   level = 'urban_final',
                                                                                   value =  1 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                         
                                     ),
                                     
                                     output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = 1, 
                                                                                   commodity = 'wastewater', 
                                                                                   level = 'urban_secondary',
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
                                                                       value = 1	),
                                     
                                     # data.frame( vintages, value )
                                     technical_lifetime = expand.grid( 	node = nds,
                                                                        vintage = vtgs,
                                                                        value = lft	),
                                     
                                     # data.frame( vintages, value )
                                     inv_cost = expand.grid( node = nds,
                                                             vintage = vtgs,
                                                             value = 785	),
                                     
                                     # data.frame( node, vintages, year_all, value )
                                     fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                          vintage = vtgs,
                                                                          value = 251	),
                                                            vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                     
                                     # data.frame( node, vintage, year_all, mode, time, value ) 
                                     var_cost = NULL,							
                                     
                                     # data.frame(node,year_all,value)
                                     historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "urban_wastewater_collection",]
                                     
)


# urban_wastewater_release
vtgs = year_all
nds = bcus
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_wastewater_release = list( 	nodes = nds,
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
                                                                                level = 'urban_final',
                                                                                value =  0 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                      
                                                      left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = c( 1 ), 
                                                                                commodity = 'wastewater', 
                                                                                level = 'urban_final',
                                                                                value =  1 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                      
                                  ),
                                  
                                  output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = 1, 
                                                                                commodity = 'freshwater', 
                                                                                level = 'river_out',
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

# urban_wastewater_treatment
vtgs = year_all
nds = bcus
lft = 25
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_wastewater_treatment = list( 	nodes = nds,
                                    years = year_all,
                                    times = time,
                                    vintages = vtgs,	
                                    types = c('water'),
                                    modes = c( 1 ),
                                    lifetime = 25,
                                    
                                    input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = c( 1 ), 
                                                                                  commodity = 'electricity', 
                                                                                  level = 'urban_final',
                                                                                  value =  12.5 ) ,
                                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                        
                                                        left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = c( 1 ), 
                                                                                  commodity = 'wastewater', 
                                                                                  level = 'urban_secondary',
                                                                                  value =  1 ) ,
                                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                        
                                    ),
                                    
                                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  commodity = 'freshwater', 
                                                                                  level = 'river_out',
                                                                                  value = 0.9 ) ,
                                                                    vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                    ),	
                                    
                                    # data.frame( node,vintage,year_all,mode,emission) 
                                    emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                          vintage = vtgs,
                                                                                          mode = 1, 
                                                                                          emission = 'water_consumption', 
                                                                                          value = 0.1 ) ,
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
                                                            value = 431	),
                                    
                                    # data.frame( node, vintages, year_all, value )
                                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 37	),
                                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                    
                                    # data.frame( node, vintage, year_all, mode, time, value ) 
                                    var_cost = NULL,							
                                    
                                    # data.frame(node,year_all,value)
                                    historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "urban_wastewater_treatment",]
                                    
)

# industry_sw_diversion 
vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
industry_sw_diversion = list( 	nodes = nds,
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
                                                                             level = 'industry_final',
                                                                             value =  6 ) ,
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
                                                                             level = 'industry_secondary',
                                                                             value = 1 ) ,
                                                               vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
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
                                                                 value = 0	),
                               
                               # data.frame( vintages, value )
                               technical_lifetime = expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 15	),
                               
                               # data.frame( vintages, value )
                               inv_cost = expand.grid( node = nds,
                                                       vintage = vtgs,
                                                       value = 57	),
                               
                               # data.frame( node, vintages, year_all, value )
                               fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 3	),
                                                      vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                               
                               # data.frame( node, vintage, year_all, mode, time, value ) 
                               var_cost = NULL,							
                               
                               # data.frame(node,year_all,value)
                               historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "industry_sw_diversion",]
                               
)

# industry_gw_diversion 
vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
industry_gw_diversion = list( 	nodes = nds,
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
                                                                             level = 'industry_final',
                                                                             value =  13 ) ,
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
                                                                             level = 'industry_secondary',
                                                                             value = 1 ) ,
                                                               vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
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
                                                                 value = 0	),
                               
                               # data.frame( vintages, value )
                               technical_lifetime = expand.grid( 	node = nds,
                                                                  vintage = vtgs,
                                                                  value = 15	),
                               
                               # data.frame( vintages, value )
                               inv_cost = expand.grid( node = nds,
                                                       vintage = vtgs,
                                                       value = 20	),
                               
                               # data.frame( node, vintages, year_all, value )
                               fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                    vintage = vtgs,
                                                                    value = 8.5	),
                                                      vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                               
                               # data.frame( node, vintage, year_all, mode, time, value ) 
                               var_cost = NULL,							
                               
                               # data.frame(node,year_all,value)
                               historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "industry_gw_diversion",]
                               
)

# industry_distribution 
vtgs = year_all
nds = bcus
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
industry_distribution = list( 	nodes = nds,
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
                                                                             level = 'industry_final',
                                                                             value =  0 ) ,
                                                               vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                     dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                   
                                                   left_join(  expand.grid( 	node = nds,
                                                                             vintage = vtgs,
                                                                             mode = c( 1 ), 
                                                                             commodity = 'freshwater', 
                                                                             level = 'industry_secondary',
                                                                             value =  1 ) ,
                                                               vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                     dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )		
                                                   
                               ),
                               
                               output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                             vintage = vtgs,
                                                                             mode = 1, 
                                                                             commodity = 'freshwater', 
                                                                             level = 'industry_final',
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

# industry_wastewater_collection
vtgs = year_all
nds = bcus
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
industry_wastewater_collection = list( 	nodes = nds,
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
                                                                                      level = 'industry_final',
                                                                                      value =  0 ) ,
                                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                            
                                                            left_join(  expand.grid( 	node = nds,
                                                                                      vintage = vtgs,
                                                                                      mode = c( 1 ), 
                                                                                      commodity = 'wastewater', 
                                                                                      level = 'industry_final',
                                                                                      value =  1 ) ,
                                                                        vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                              dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                            
                                        ),
                                        
                                        output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                      vintage = vtgs,
                                                                                      mode = 1, 
                                                                                      commodity = 'wastewater', 
                                                                                      level = 'industry_secondary',
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
                                        var_cost = NULL,							
                                        
                                        # data.frame(node,year_all,value)
                                        historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "industry_wastewater_collection",]
                                        
)


# industry_wastewater_release
vtgs = year_all
nds = bcus
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
industry_wastewater_release = list( 	nodes = nds,
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
                                                                                   level = 'industry_final',
                                                                                   value =  0 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                         
                                                         left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'wastewater', 
                                                                                   level = 'industry_final',
                                                                                   value =  1 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                         
                                     ),
                                     
                                     output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = 1, 
                                                                                   commodity = 'freshwater', 
                                                                                   level = 'river_out',
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

# industry_wastewater_treatment
vtgs = year_all
nds = bcus
lft = 25
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
industry_wastewater_treatment = list( 	nodes = nds,
                                       years = year_all,
                                       times = time,
                                       vintages = vtgs,	
                                       types = c('water'),
                                       modes = c( 1 ),
                                       lifetime = 25,
                                       
                                       input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'electricity', 
                                                                                     level = 'industry_final',
                                                                                     value =  12.5 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                           
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'wastewater', 
                                                                                     level = 'industry_secondary',
                                                                                     value =  1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                           
                                       ),
                                       
                                       output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1, 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'river_out',
                                                                                     value = 0.9 ) ,
                                                                       vtg_year_time ) %>% mutate( node_out = node, time_out = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_out, commodity, level, time, time_out, value ),	
                                       ),	
                                       
                                       # data.frame( node,vintage,year_all,mode,emission) 
                                       emission_factor = bind_rows( 	left_join( expand.grid( node = nds,
                                                                                             vintage = vtgs,
                                                                                             mode = 1, 
                                                                                             emission = 'water_consumption', 
                                                                                             value = 0.1 ) ,
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
                                                               value = 431	),
                                       
                                       # data.frame( node, vintages, year_all, value )
                                       fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                            vintage = vtgs,
                                                                            value = 37	),
                                                              vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                       
                                       # data.frame( node, vintage, year_all, mode, time, value ) 
                                       var_cost = NULL,							
                                       
                                       # data.frame(node,year_all,value)
                                       historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "industry_wastewater_treatment",]
                                       
)					

# rural_sw_diversion 
vtgs = year_all
lft = 15
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
rural_sw_diversion = list( 	nodes = nds,
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
                                                                          value =  6 ) ,
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
                                                    value = 57	),
                            
                            # data.frame( node, vintages, year_all, value )
                            fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                 vintage = vtgs,
                                                                 value = 3	),
                                                   vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                            
                            # data.frame( node, vintage, year_all, mode, time, value ) 
                            var_cost = NULL,							
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_sw_diversion",]
                            
)

# rural_gw_diversion 
vtgs = year_all
lft = 15
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
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
                                                                          value =  15 ) ,
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
                            var_cost = NULL,							
                            
                            # data.frame(node,year_all,value)
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_gw_diversion",]
                            
)

# rural_piped_distribution 
vtgs = year_all
lft = 15
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
rural_piped_distribution = list( 	nodes = nds,
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
                                                                                value =  6 ) ,
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
                                                          value = 326	),
                                  
                                  # data.frame( node, vintages, year_all, value )
                                  fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                       vintage = vtgs,
                                                                       value = 18	),
                                                         vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                  
                                  # data.frame( node, vintage, year_all, mode, time, value ) 
                                  var_cost = NULL,							
                                  
                                  # data.frame(node,year_all,value)
                                  historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_piped_distribution",]
                                  
)

# rural_unimproved_distribution 
vtgs = year_all
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
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
                                       historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_unimproved_distribution",]
                                       
)

# rural_wastewater_collection
vtgs = year_all
lft = 15
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
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
                                                                                   value =  0 ) ,
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
                                     historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_wastewater_collection",]
                                     
)

# rural_wastewater_release
vtgs = year_all
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
rural_wastewater_release = list( 	nodes = nds,
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
                                                                                commodity = 'wastewater', 
                                                                                level = 'rural_final',
                                                                                value =  1 ) ,
                                                                  vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                        dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )			
                                                      
                                  ),
                                  
                                  output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                vintage = vtgs,
                                                                                mode = 1, 
                                                                                commodity = 'freshwater', 
                                                                                level = 'river_out',
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
                                  historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_wastewater_release",]
                                  
)


# rural_wastewater_treatment
as.character( basin.spdf@data$DOWN[ iii ] )
vtgs = year_all
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
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
                                                                                  value =  6 ) ,
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
                                                                                  level = 'river_out',
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
                                                            value = 759	),
                                    
                                    # data.frame( node, vintages, year_all, value )
                                    fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                         vintage = vtgs,
                                                                         value = 77	),
                                                           vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                    
                                    # data.frame( node, vintage, year_all, mode, time, value ) 
                                    var_cost = NULL,							
                                    
                                    # data.frame(node,year_all,value)
                                    historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "rural_wastewater_treatment",]
                                    
)

# irrigation_sw_diversion - conventional
vtgs = year_all
nds = bcus
lft = 50
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
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
                                                                               value =  6 ) ,
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
                                                         value = 57	),
                                 
                                 # data.frame( node, vintages, year_all, value )
                                 fix_cost = left_join( 	expand.grid( 	node = nds,
                                                                      vintage = vtgs,
                                                                      value = 3	),
                                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                                 
                                 # data.frame( node, vintage, year_all, mode, time, value ) 
                                 var_cost = NULL,							
                                 
                                 # data.frame(node,year_all,value)
                                 historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "irrigation_sw_diversion",]
                                 
)

# irrigation_sw_diversion - smart
vtgs = year_all
nds = bcus
lft = 50
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
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
                                                                                     value =  6 ) ,
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
                                       
)					

# irrigation_gw_diversion - conv
vtgs = year_all
nds = bcus
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
                                 var_cost = NULL,							
                                 
                                 # data.frame(node,year_all,value)
                                 historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "irrigation_gw_diversion",]
                                 
)

# irrigation_gw_diversion - smart
vtgs = year_all
nds = bcus
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
                                       var_cost = NULL,							
                                       
                                       # data.frame(node,year_all,value)
                                       historical_new_capacity = NULL
                                       
)					

# energy_sw_diversion
vtgs = year_all
nds = bcus
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
                             var_cost = NULL,							
                             
                             # data.frame(node,year_all,value)
                             historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "energy_sw_diversion",]
                             
)

# energy_gw_diversion 
vtgs = year_all
nds = bcus
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
                                                                           value =  6 ) ,
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
                             var_cost = NULL,							
                             
                             # data.frame(node,year_all,value)
                             historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "energy_gw_diversion",]
                             
)

# transfer surface to groundwater - backstop option for meeting flow constraints					
vtgs = year_all
nds = bcus
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
                                                                      value =  6 ) ,
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
                        
)

# transfer groundwater to suface water - backstop option for meeting flow constraints
vtgs = year_all
nds = bcus
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
                                                                      value =  6 ) ,
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
                        
)
# urban_wastewater_recycling
vtgs = year_all
nds = bcus
lft = 30
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_wastewater_recycling = list( 	nodes = nds,
                                    years = year_all,
                                    times = time,
                                    vintages = vtgs,	
                                    types = c('water'),
                                    modes = c( 1 ),
                                    lifetime = 30,
                                    
                                    input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = c( 1 ), 
                                                                                  commodity = 'electricity', 
                                                                                  level = 'urban_final',
                                                                                  value =  42 ) ,
                                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                        
                                                        left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = c( 1 ), 
                                                                                  commodity = 'wastewater', 
                                                                                  level = 'urban_secondary',
                                                                                  value =  1 ) ,
                                                                    vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                          dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                        
                                    ),
                                    
                                    output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                  vintage = vtgs,
                                                                                  mode = 1, 
                                                                                  commodity = 'freshwater', 
                                                                                  level = 'urban_secondary',
                                                                                  value = 0.8 ) ,
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
                                    historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "urban_wastewater_recycling",]
                                    
)

# industry_wastewater_recycling
vtgs = year_all
nds = bcus
lft = 30
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
industry_wastewater_recycling = list( 	nodes = nds,
                                       years = year_all,
                                       times = time,
                                       vintages = vtgs,	
                                       types = c('water'),
                                       modes = c( 1 ),
                                       lifetime = 30,
                                       
                                       input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'electricity', 
                                                                                     level = 'industry_final',
                                                                                     value =  42 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                           
                                                           left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = c( 1 ), 
                                                                                     commodity = 'wastewater', 
                                                                                     level = 'industry_secondary',
                                                                                     value =  1 ) ,
                                                                       vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                             dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                           
                                       ),
                                       
                                       output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                     vintage = vtgs,
                                                                                     mode = 1, 
                                                                                     commodity = 'freshwater', 
                                                                                     level = 'industry_secondary',
                                                                                     value = 0.8 ) ,
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
                                       historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "industry_wastewater_recycling",]
                                       
)					

# urban_wastewater_irrigation
vtgs = year_all
nds = bcus
lft = 30
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
urban_wastewater_irrigation = list( 	nodes = nds,
                                     years = year_all,
                                     times = time,
                                     vintages = vtgs,	
                                     types = c('water'),
                                     modes = c( 1 ),
                                     lifetime = 30,
                                     
                                     input = bind_rows(  left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'electricity', 
                                                                                   level = 'urban_final',
                                                                                   value =  80 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value ),
                                                         
                                                         left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = c( 1 ), 
                                                                                   commodity = 'wastewater', 
                                                                                   level = 'urban_secondary',
                                                                                   value =  1 ) ,
                                                                     vtg_year_time ) %>% mutate( node_in = node, time_in = time ) %>% 
                                                           dplyr::select( node,  vintage, year_all, mode, node_in, commodity, level, time, time_in, value )				
                                                         
                                     ),
                                     
                                     output = bind_rows( left_join(  expand.grid( 	node = nds,
                                                                                   vintage = vtgs,
                                                                                   mode = 1, 
                                                                                   commodity = 'freshwater', 
                                                                                   level = 'irrigation_final',
                                                                                   value = 0.8 ) ,
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
                                     historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "urban_wastewater_irrigation",]
                                     
)					

# rural_wastewater_recycling
vtgs = year_all
nds = bcus
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
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
                                                                                   value =  42 ) ,
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
                                                                                   value = 0.8 ) ,
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
                                     
)
# Distributed diesel gensets for water pumping in agriculture sector
vtgs = year_all
lft = 20
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
nds = bcus
irri_diesel_genset = list( 	nodes = nds,
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
                            historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "irri_diesel_genset",]
                            
)

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
                            
)					

# # Distributed solar PV for water pumping in agriculture sector - assume pumping flexible to output (i.e., flexible load)
vtgs = year_all
nds = bcus
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
                                         value = 3.873	),
                 
                 # data.frame( node, vintages, year_all, value )
                 fix_cost = left_join( 	expand.grid( 	node = nds,
                                                      vintage = vtgs,
                                                      value = 0.007	),
                                        vtg_year ) %>% dplyr::select( node, vintage, year_all, value ), 
                 
                 # data.frame( node, vintage, year_all, mode, time, value ) 
                 var_cost = NULL,							
                 
                 # data.frame(node,year_all,value)
                 historical_new_capacity = hist_new_cap.df[hist_new_cap.df$tec == "agri_pv",]
                 
)
# ##### Network technologies

## Technology to represent environmental flows - movement of water from river_in to river_out within the same PID
vtgs = year_all
nds = bcus
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
                            
)

## River network - technologies that move surface water between PIDs
vtgs = year_all
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
river_names = NULL
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

river_routes = gsub('river\\|','',river_names)
## Conveyance - technologies that move surface water between PIDs
vtgs = year_all
lft = 50
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
canal_names = NULL

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
vtgs = year_all
nds = bcus
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
                            
)

## River network - technologies that move surface water between PIDs
vtgs = year_all
lft = 1
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
river_names = NULL
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

river_routes = gsub('river\\|','',river_names)
## Conveyance - technologies that move surface water between PIDs
vtgs = year_all
lft = 50
vtg_year = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ] ) } ) ) 
vtg_year_time = bind_rows( lapply( vtgs, function( vv ){ expand.grid( vintage = vv, year_all = year_all[ year_all %in% vv:(vv+lft) ], time = time )  } ) ) 
canal_names = NULL

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
