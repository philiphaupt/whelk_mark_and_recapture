# Call functions to make data spatial

# From my_functions folder
source("C:/Users/philip.haupt/OneDrive - Kent & Essex Inshore Fisheries and Conservation Authority/data_analysis/my_functions/coordinates/ddm_to_dd_converter_2023.R")
source("C:/Users/philip.haupt/OneDrive - Kent & Essex Inshore Fisheries and Conservation Authority/data_analysis/my_functions/coordinates/wrapper_ddm_to_dd_converter_2023.R")
cat("Name of two functions: convert_coords_table, dm_to_dd_fn")

# Apply the conversion function - adds two columns xcoord and ycoord
mr_dat <- convert_coords_table(mr_dat, lon_col = "start_long_dm", lat_col = "start_long_dm")

# Make sf object
mr_dat_sf <- sf::st_as_sf(mr_dat, coords = c("xcoord", "ycoord"), crs = 4326)

# transpose utm
mr_dat_utm <- mr_dat_sf %>% sf::st_transform(crs = 32631)

# test
ggplot(mr_dat_utm)+
  geom_sf()
