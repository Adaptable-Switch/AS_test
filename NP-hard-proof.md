# Appendix

## Terminology and Definition:

![](https://render.githubusercontent.com/render/math?math=ID)

For one Basic Processing Unit(BPU) and multiple execution engines(EEs) in the Adaptable Switch(AS) design, let ![](https://render.githubusercontent.com/render/math?math=N_0) be the number of flow entries in the original Action function that only contains single EE; ![](https://render.githubusercontent.com/render/math?math=C_0) be the original capacity of the flow table; ![](https://render.githubusercontent.com/render/math?math=R_d) be the resource redundancy of the flow table, ![](https://render.githubusercontent.com/render/math?math=K) be the number of paralleled EEs; ![](https://render.githubusercontent.com/render/math?math=C_k) be the capacity of each sub-table of EE, where ![](https://render.githubusercontent.com/render/math?math=k) is from 1 to ![](https://render.githubusercontent.com/render/math?math=K); Partition number ![](https://render.githubusercontent.com/render/math?math=ID) is the result of  ![](https://render.githubusercontent.com/render/math?math=HASH()) function, ![](https://render.githubusercontent.com/render/math?math=J=HASH)(packet header), where ![](https://render.githubusercontent.com/render/math?math=j) is the value space of ![](https://render.githubusercontent.com/render/math?math=ID).

<!---
-->
Therefore, 

&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=N\leq\sum^{K}_{k=1}C_k\leq{C_0}\cdot{R_d} ) &emsp;&emsp;&emsp;&emsp;&emsp; (1)

![](https://render.githubusercontent.com/render/math?math=D\_flow[i]) is defined as the ratio of the traffic load of one flow ![](https://render.githubusercontent.com/render/math?math=i),

&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=\sum^{N}_{i=1}D\_flow[i]=1,i\in{[1,N]} ) &emsp;&emsp; (2)

![](https://render.githubusercontent.com/render/math?math=D\_id[j]) is defined as total traffic load in one of the ![](https://render.githubusercontent.com/render/math?math=ID) partitions,

&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=D\_id[j]=\sum^{}_{flow[i]\in{j}}D\_flow[i] ) &emsp;&emsp; (3)

![](https://render.githubusercontent.com/render/math?math=T) refers to the tolerance of the discrepancy of table utilization among the parallelized EE in one BPU. Let ![](https://render.githubusercontent.com/render/math?math=S) be the set of all the ![](https://render.githubusercontent.com/render/math?math=ID) groups,![](https://render.githubusercontent.com/render/math?math=S=\{1,2,...,2^P\}). ![](https://render.githubusercontent.com/render/math?math=Q_k) be the allocation result of ![](https://render.githubusercontent.com/render/math?math=ID) group in tables, ![](https://render.githubusercontent.com/render/math?math=Q_k\subseteq{S},\cup{Q_k}=S,|Q_k|) be the number of ![](https://render.githubusercontent.com/render/math?math=ID)group allocated in one table. We define ![](https://render.githubusercontent.com/render/math?math=D[k]) as the traffic load allocated ito table ![](https://render.githubusercontent.com/render/math?math=k), so, 

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=D[k]=\sum^{}_{j\in{Q_k}}D\_id[j])&emsp;&emsp;&emsp;&emsp;&emsp;(4)

If more than one extended sub rules be allocated into the same ![](https://render.githubusercontent.com/render/math?math=Q_k), we can remerging these rules into one rule by just changing the different bits to a mask "![](https://render.githubusercontent.com/render/math?math=\ast)". We note the number of compressed sub rules as ![](https://render.githubusercontent.com/render/math?math=V_k). Then optimization problem is given by **The Load-Balance-Based Table Construction Problem** .

#### Subject To.

&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=Q_k\subseteq{S},k\in[1,k],\cup{Q_k}=S,N\leq\sum^{K}_{k=1}C_k\leq{C_0}\cdot{R_d})
 
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=||\dfrac{Q_i}{C_{ki}}|-|\dfrac{Q_j}{C_{kj}}||\cdot{100percent\leq{T}}(i,j,ki,kj\in[1,k]))
 
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=BOOL(i,j)) =1 ![](https://render.githubusercontent.com/render/math?math=j\in{Q_i}) or 0 ![](https://render.githubusercontent.com/render/math?math=j\notin{Q_i})
  
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=G\left[j\right]=\sum^{k}_{i=1}BOOL)(i,j)=![](https://render.githubusercontent.com/render/math?math=1(j\in{S}))
   
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=\sum_{j\in{S}}G\left[i\right]=2^{P}(j\in{S}))
   
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=D[k]=\sum_{j\in{Q_k}}D_{-}id[i](k=1,\ldots,K))
   
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=F_1k]=MAX(D[k])) ![](https://render.githubusercontent.com/render/math?math=-MlN(D[k]))![](https://render.githubusercontent.com/render/math?math=\leq{q_1})

&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=F_2[k]=C_0-\sum^{K}_{k=1}V_k\leq{q_2})

#### Minimize a Pareto function:

&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=F[k]=(F_1[k],F_2[k])) ![](https://render.githubusercontent.com/render/math?math=k\in[1,K])
   


![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5837.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5838.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5839.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5840.PNG)
