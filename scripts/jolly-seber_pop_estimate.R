library("mra")
# Cormack-Jolly-Seber

# The calculation of the total population is specified as follows:

# m2 – number of marked individuals recaptured on the second (subsequent) sampling event. 
# n2 – total number caught on second sampling event. 
# n1 - total number caught and marked on the first marking event.
# N – total population.
# The total population is then estimated as:  N ̂=(n_1+1)(n_2+ 1)/(m_2+ 1) - 1 
# 
# Such that m_2/n_2 =n_1/N  where N is the total (estimated) population.
# This can be expressed as  N=(〖(n〗_1*n_2))/m_2   






# examples from existing packages:
# data(dipper.data)
# data(dipper.histories)
# 
# #install.packages("marked") # first time only
# library(marked)
# 
# # Load dipper data (included in "marked")
# data(dipper, package = "marked")
# 
# # Examine data structure
# head(dipper)
# 
# # First, process data (Notice model = "JS", previous version = "CJS")
# dipper.js.proc <- process.data(dipper, 
#                                model = "JS", 
#                                groups = "sex")
# # Second, make design data (from processed data)
# dipper.js.ddl <- make.design.data(dipper.js.proc)



