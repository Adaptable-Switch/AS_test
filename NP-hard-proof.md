## Appendix

Terminology and Definition: For one Basic Processing Unit(BPU) and multiple execution engines(EEs) in the Adaptable Switch(AS) design, let N0 be the number of flow entries in the original Action function that only contains single EE; C0 be the original capacity of the flow table; Rd be the resource redundancy of the flow table, K be the number of paralleled EEs; Ck be the capacity of each sub-table of EE, where k is from 1 to K; Partition number ID is the result of HASH() function, j=HASH(packet header), where j is the value space of ID.

therefore, 

N 小于等于 和Ck 小于等于 C0*Rd

D_flow[i] is defined as the ratio of the traffic load of one flow i, 

和D_flow[i]=1,i in [1,N]

D_flow[i] is defined as total traffic load in one of the ID partitions,

D_flow[i]=和D_flow[i]

T refers to the tolerance of the discrepancy of table utilization among the parallelized EE in one BPU.


We define the optimization problem of data splitting is a Load-Balance-Based Table Division problem (LBBTD).

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5837.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5838.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5839.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5840.PNG)
