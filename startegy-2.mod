/*********************************************
 * OPL 12.6.1.0 Model
 * Author: SHAHRIAR TANVIR ALAM
 * Creation Date: Apr 19, 2024 at 5:29:32 AM
 *********************************************/
 
//ISE 662 (Strategy-2)
 
 
//sets
{string} OPs=...;//i
{string} ODCs=...;//j
{string} DPs=...;//r
{string} products=...;//g
{string} vehicles=...;//l



//parameters
int total_available_quantity_oxygen_OPs[products][OPs]=...;//k(i_g)
float per_unit_cost_vehicle[vehicles]=...;//Cl

float weight_commodity[products]=...;//Wg
float volume_commodity[products]=...;//Vg

float weight_vehicle[vehicles]=...;//Wl
float volume_vehicle[vehicles]=...;//Vl

float distance_OPs_ODCs[OPs][ODCs]=...;//Sij
float distance_ODCs_DPs[ODCs][DPs]=...;//Mjr


int demand_oxygen_DPs[products][DPs]=...;//D(g_r)

float capacity_of_ODC[products][ODCs]=...;//Pj

float shortage_cost_unsatisfied_demand_oxygen_DPs[products][DPs]=...;//Trg
float cost_maintenance[products][OPs] = ...;
float cost_maintenance_vehicle[vehicles] = ...;

float emergency_rating[products]=...;//alpha

int total_number_vehicle[vehicles]=...;//NVt
int machine[OPs]=...;


//Decision variables
dvar int+ quantity_oxygen_OPs_ODCs[products][OPs][ODCs];//x
dvar int+ quantity_oxygen_ODCs_DPs[products][ODCs][DPs];//z

dvar int+ number_vehicle_OPs_ODCs[OPs][ODCs][vehicles];//NVij
dvar int+ number_vehicle_ODCs_DPs[ODCs][DPs][vehicles];//jr


dvar int+ shortage_demand_oxygen_DPs[products][DPs];//SHrg

//objective function
minimize
  sum(s in products,i in OPs)2*2*machine[i]*cost_maintenance[s][i]+
  sum(l in vehicles)cost_maintenance_vehicle[l]*total_number_vehicle[l];
  

//constrains

subject to
{

//1
forall(s in products,r in DPs)
  sum(j in ODCs)quantity_oxygen_ODCs_DPs[s][j][r]>=
  emergency_rating[s]*demand_oxygen_DPs[s][r];

  
//2
forall(s in products,r in DPs)
  shortage_demand_oxygen_DPs[s][r]==
  demand_oxygen_DPs[s][r]-sum(j in ODCs)quantity_oxygen_ODCs_DPs[s][j][r];

  
//3
forall(s in products,i in OPs)
  sum(j in ODCs)quantity_oxygen_OPs_ODCs[s][i][j]<=total_available_quantity_oxygen_OPs[s][i];

//4
forall(s in products,j in ODCs)
  sum(i in OPs)quantity_oxygen_OPs_ODCs[s][i][j]<=capacity_of_ODC[s][j];


//6
forall(s in products,j in ODCs)
  sum(i in OPs)quantity_oxygen_OPs_ODCs[s][i][j]>=
  sum(r in DPs)quantity_oxygen_ODCs_DPs[s][j][r];



//9
forall(j in ODCs,i in OPs)
  sum(s in products)quantity_oxygen_OPs_ODCs[s][i][j]*weight_commodity[s]<=
  sum(l in vehicles)number_vehicle_OPs_ODCs[i][j][l]*weight_vehicle[l];


//10
forall(j in ODCs,i in OPs)
  sum(s in products)quantity_oxygen_OPs_ODCs[s][i][j]*volume_commodity[s]<=
  sum(l in vehicles)number_vehicle_OPs_ODCs[i][j][l]*volume_vehicle[l];
  


//13
forall(j in ODCs,r in DPs)
  sum(s in products)quantity_oxygen_ODCs_DPs[s][j][r]*weight_commodity[s]<=
  sum(l in vehicles)number_vehicle_ODCs_DPs[j][r][l]*weight_vehicle[l];


//14
forall(j in ODCs,r in DPs)
  sum(s in products)quantity_oxygen_ODCs_DPs[s][j][r]*volume_commodity[s]<=
  sum(l in vehicles)number_vehicle_ODCs_DPs[j][r][l]*volume_vehicle[l];


//17
forall(l in vehicles)
  sum(i in OPs,j in ODCs) number_vehicle_OPs_ODCs[i][j][l]+
  sum(j in ODCs,r in DPs)number_vehicle_ODCs_DPs[j][r][l]<=
  total_number_vehicle[l];


}