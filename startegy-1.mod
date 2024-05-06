/*********************************************
 * OPL 12.6.1.0 Model
 * Author: SHAHRIAR TANVIR ALAM
 * Creation Date: Apr 18, 2024 at 9:49:35 PM
 *********************************************/
 
//ISE 662 (Strategy-1)
 
 
// Indices
int Nsupply_centers=2;
range supply_centers=1..Nsupply_centers; //i

int Nmanufacturing_centers=1;
range manufacturing_centers=1..Nmanufacturing_centers; //j

int Ndemand_centers=3;
range demand_centers=1..Ndemand_centers; //k

int Nretail_centers=2;
range retail_centers=1..Nretail_centers; //l

int Ncustomer_centers=3;
range customer_centers=1..Ncustomer_centers; //m


{string} products={"A", "B"}; //s

// Parameters

float demand_deamand_center[products][demand_centers]= ...;
float demand_customer_center[products][customer_centers] = ...; // Demand of product s in customer center m
float capacity_supply_center[supply_centers] = ...; // Capacity of supply center i
float capacity_manufacturing_center[manufacturing_centers] = ...; // Capacity of manufacturing center j
float capacity_demand_center[demand_centers] = ...; // Capacity of demand center k
float capacity_retail_center[retail_centers] = ...; // Capacity of retail center l
float cost_supply_to_manufacturing[products][supply_centers][manufacturing_centers] = ...; // Cost of transporting product s from supply center i to manufacturing center j

float cost_manufacturing_to_demand[products][manufacturing_centers][demand_centers] = ...; // Cost of transporting product s from manufacturing center j to demand center k
float cost_demand_to_retail[products][demand_centers][retail_centers] = ...; // Cost of transporting product s from demand center k to retail center l
float cost_retail_to_customer[products][retail_centers][customer_centers] = ...; // Cost of transporting product s from retail center l to customer center m
//float demand_fulfillment_percentage [products]= ...; // The percentage of demand at the demand center that is fulfilled

float cost_shortage[products][demand_centers] = ...;
float cost_maintenance[products][manufacturing_centers] = ...;
float cost_inventory[products][demand_centers] = ...;

int machine[manufacturing_centers]=...;


// Decision Variables
dvar float+ quantity_supply_centers_to_manufacturing_centers[products][supply_centers][manufacturing_centers]; // Quantity transported from supply center i to manufacturing center j
dvar float+ quantity_manufacturing_centers_to_demand_centers[products][manufacturing_centers][demand_centers]; // Quantity transported from manufacturing center j to demand center k
dvar float+ quantity_demand_centers_to_retail_centers[products][demand_centers][retail_centers]; // Quantity transported from demand center k to retail center l
dvar float+ quantity_retail_centers_to_customer_centers[products][retail_centers][customer_centers]; // Quantity transported from retail center l to customer center m
dvar float+ unmet_demand[products][demand_centers]; // Unmet demand for each product at each demand center
// Objective Function


minimize
    sum(s in products, i in supply_centers, j in manufacturing_centers) cost_supply_to_manufacturing[s][i][j] * quantity_supply_centers_to_manufacturing_centers[s][i][j] +
    sum(s in products, j in manufacturing_centers, k in demand_centers) cost_manufacturing_to_demand[s][j][k] * quantity_manufacturing_centers_to_demand_centers[s][j][k] +
    sum(s in products, k in demand_centers, l in retail_centers) cost_demand_to_retail[s][k][l] * quantity_demand_centers_to_retail_centers[s][k][l] +
    sum(s in products, l in retail_centers, m in customer_centers) cost_retail_to_customer[s][l][m] * quantity_retail_centers_to_customer_centers[s][l][m]+
    sum(s in products, k in demand_centers)unmet_demand[s][k]*cost_shortage[s][k]+
    sum(s in products, j in manufacturing_centers)2*2*machine[j]*cost_maintenance[s][j]+
    sum(s in products, k in demand_centers)demand_deamand_center[s][k]*cost_inventory[s][k];

// Constraints

subject to {


// Flow conservation at manufacturing centers
forall(s in products, j in manufacturing_centers)
    sum(i in supply_centers) quantity_supply_centers_to_manufacturing_centers[s][i][j] >=
    sum(k in demand_centers) quantity_manufacturing_centers_to_demand_centers[s][j][k];


 // Modify the flow conservation at demand centers to distribute the fulfilled demand between the retail centers and customer centers
forall(s in products, k in demand_centers)
    sum(j in manufacturing_centers) quantity_manufacturing_centers_to_demand_centers[s][j][k] >=
     demand_deamand_center[s][k]; 

 // Flow conservation at retail centers
forall(s in products, l in retail_centers)
    sum(k in demand_centers) quantity_demand_centers_to_retail_centers[s][k][l]>=
    sum(m in customer_centers) quantity_retail_centers_to_customer_centers[s][l][m];
    
    
// Modify the demand constraints at customer centers to ensure that the demand is met
forall(s in products, m in customer_centers)
    sum(l in retail_centers) quantity_retail_centers_to_customer_centers[s][l][m]>= 
     demand_customer_center[s][m];
  
forall(s in products, k in demand_centers)
    unmet_demand[s][k] == demand_deamand_center[s][k] - sum(j in manufacturing_centers) quantity_manufacturing_centers_to_demand_centers[s][j][k];

  
    
    //capacity
forall(j in manufacturing_centers)
    sum(s in products, i in supply_centers) quantity_supply_centers_to_manufacturing_centers[s][i][j] <= capacity_manufacturing_center[j];

forall(k in demand_centers)
    sum(s in products, j in manufacturing_centers) quantity_manufacturing_centers_to_demand_centers[s][j][k] <= capacity_demand_center[k];

forall(l in retail_centers)
    sum(s in products, k in demand_centers) quantity_demand_centers_to_retail_centers[s][k][l] <= capacity_retail_center[l];
  
  
  forall(s in products, i in supply_centers, j in manufacturing_centers)
    quantity_supply_centers_to_manufacturing_centers[s][i][j] >= 0;

forall(s in products, j in manufacturing_centers, k in demand_centers)
    quantity_manufacturing_centers_to_demand_centers[s][j][k] >= 0;

forall(s in products, k in demand_centers, l in retail_centers)
    quantity_demand_centers_to_retail_centers[s][k][l] >= 0;

forall(s in products, l in retail_centers, m in customer_centers)
    quantity_retail_centers_to_customer_centers[s][l][m] >= 0;
    } 

 