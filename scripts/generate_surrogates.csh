#!/bin/csh -f
#******************* Generate Surrogates Run Script **************************
# This script generates surrogates for the MIMS spatial tool test case
# (8km over Tennessee).
# 
# Script created by : Alison Eyth, Carolina Environmental Program, UNC-CH
# Last edited : June 2005
#
# Dec. 2007, LR -- projection specification changes
#****************************************************************************

# Set installation directory

setenv DEBUG_OUTPUT N 

# Set directory for output surrogate and shape files
setenv WORK_DIR $SA_HOME/output

# Location of input shapefiles
setenv DATA $SA_HOME/data

if (! -d $WORK_DIR) mkdir -p $WORK_DIR

# Grid settings
setenv GRIDDESC $DATA/GRIDDESC.txt   # Grid description file
setenv OUTPUT_GRID_NAME M08_NASH             # Grid name
setenv OUTPUT_FILE_ELLIPSOID "+a=6370000.0,+b=6370000.0"    # Ellipsoid

# Location of executable
setenv EXE $SA_HOME/bin/64bits/srgcreate.exe

setenv SURROGATE_FILE   $WORK_DIR/tmp_srg.${OUTPUT_GRID_NAME}.txt      # temporary surrogate file    
setenv SRG_FILE         $WORK_DIR/srg_${OUTPUT_GRID_NAME}.txt # final merged surrogate file


# WRITE_QASUM=YES prints surrogate sums by county in file
# WRITE_SRG_NUMERATOR=YES writes surrogate numerator as comment in file
# WRITE_SRG_DENOMINATOR=YES writes denminator (county totals) for srg weight
setenv WRITE_QASUM       YES            # YES prints srg sums by county in file
setenv WRITE_SRG_NUMERATOR YES        # YES writes numerator for surrogates
setenv WRITE_SRG_DENOMINATOR YES      # YES writes denominator for surrogates

# Print header info
setenv WRITE_HEADER      NO             # YES - prints header info to srg file

# Specify type of data files to use
setenv OUTPUT_FILE_TYPE    RegularGrid	   # Type of grid
setenv DATA_FILE_NAME_TYPE   ShapeFile	   # Type of input data file
setenv WEIGHT_FILE_TYPE ShapeFile	   # Type of weighted data file

# The data polygons should e the shape file containing county polygons 
setenv DATA_FILE_NAME    $DATA/shapefiles/cnty_tn      # shapefile with counties in grid
setenv DATA_ID_ATTR FIPS_CODE          # attribute to report surrogates by
setenv DATA_FILE_MAP_PRJN   "+proj=latlong"       # map projection for data poly file
setenv DATA_FILE_ELLIPSOID  "+a=6370000.0,+b=6370000.0" 

# An example of using a non-default named ellipsoid
#set DATA_FILE_ELLIPSOID +datum=NAD27

# set weight projection to that of EPA files
setenv WEIGHT_FILE_MAP_PRJN "+proj=lcc,+lat_1=33,+lat_2=45,+lat_0=40,+lon_0=-97"
setenv WEIGHT_FILE_ELLIPSOID "+a=6370000.0,+b=6370000.0"

setenv TIME time

# Set the WEIGHT_FUNCTION and FILTER_FILE to NONE in case they were set
# from earlier executions of scripts
setenv WEIGHT_FUNCTION NONE
setenv FILTER_FILE NONE

echo "Writing surrogates to file $SRG_FILE"
# Generate surrogate header line
$EXE -header > $SRG_FILE

setenv SURROGATE_ID  2                # current surrogate category  

# Loop over surrogates categories
while ( $SURROGATE_ID <= 7 )
   set run_srg = Y
   
   switch ( $SURROGATE_ID )
   case 2:  # airports
      set infostring="GENERATING AIRPORT SURROGATE"
      setenv WEIGHT_FILE_NAME  $DATA/shapefiles/us_air-pt   # weighted shapefile
      setenv WEIGHT_ATTR_LIST  NONE   # if available, num departures would be good 
      setenv OUTPUT_FILE_NAME $WORK_DIR/grid_airpt_${OUTPUT_GRID_NAME}
      breaksw
   case 3:  # land area
      set infostring="GENERATING AREA SURROGATE"
      setenv WEIGHT_FILE_NAME  NONE	# weighted shapefile - NONE for land area
      setenv WEIGHT_ATTR_LIST  NONE	# attribute to overlay by - NONE for land area
      setenv OUTPUT_FILE_NAME $WORK_DIR/grid_area_${OUTPUT_GRID_NAME}
      breaksw
   case 4:  # ports
      set infostring="GENERATING PORTS SURROGATE"
      setenv WEIGHT_FILE_NAME  $DATA/shapefiles/tn_ports   # weight shapefile
      setenv WEIGHT_ATTR_LIST  BERTHS           # attribute to weight by         
      setenv OUTPUT_FILE_NAME $WORK_DIR/grid_ports_${OUTPUT_GRID_NAME}
      breaksw
   case 5:  # navigable H20
      set infostring="GENERATING NAVIGABLE H20 SURROGATE"
      setenv WEIGHT_FILE_NAME  $DATA/shapefiles/us_nav_h20   # weight shapefile
      setenv WEIGHT_ATTR_LIST  LENGTH     # could use NONE for sys to compute length
      setenv OUTPUT_FILE_NAME $WORK_DIR/grid_navig_${OUTPUT_GRID_NAME}
      breaksw
   case 6:  # highways
      set infostring="GENERATING HIGHWAYS SURROGATE"
      setenv WEIGHT_FILE_NAME  $DATA/shapefiles/tn_roads   # weight shapefile
      setenv WEIGHT_ATTR_LIST  NONE             # could use LENGTH
      setenv OUTPUT_FILE_NAME $WORK_DIR/grid_highway_${OUTPUT_GRID_NAME}
      breaksw
   case 7:  # households, population 
      set infostring="GENERATING POPULATION AND HOUSING SURROGATES"
      setenv SURROGATE_ID '7,8'
      setenv WEIGHT_FILE_NAME  $DATA/shapefiles/tn_pophous    # weighted shapefile
      setenv WEIGHT_ATTR_LIST  HOUSEHOLDS,POP2000  # attribute to overlay by
      setenv OUTPUT_FILE_NAME $WORK_DIR/grid_pop_${OUTPUT_GRID_NAME} # sum contains last surrg
      breaksw
   default:
      echo "ERROR: Unrecognized surrogate category"
      exit ( 1 )
   endsw
   
   if ( $run_srg == 'Y' ) then
      echo ""
      echo "$infostring - category =" $SURROGATE_ID
   
      $TIME $EXE

      if ( $status == 0 ) then
         /bin/cat $SURROGATE_FILE >> $SRG_FILE
         /bin/rm  $SURROGATE_FILE
      else
         echo "Error generating surrogate for category $SURROGATE_ID"
         exit 2
      endif

      if ( $SURROGATE_ID == '7,8' ) then  # if you want to do more after 8
         setenv SURROGATE_ID 8
      endif
   endif
   
   @ SURROGATE_ID = $SURROGATE_ID + 1
   setenv SURROGATE_ID $SURROGATE_ID
end
echo "Surrogates written to file $SRG_FILE"
