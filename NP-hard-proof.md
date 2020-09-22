# Appendix

##Terminology and Definition:



For one Basic Processing Unit(BPU) and multiple execution engines(EEs) in the Adaptable Switch(AS) design, let ![](https://render.githubusercontent.com/render/math?math=N_0) be the number of flow entries in the original Action function that only contains single EE; ![](https://render.githubusercontent.com/render/math?math=C_0) be the original capacity of the flow table; ![](https://render.githubusercontent.com/render/math?math=R_d) be the resource redundancy of the flow table, ![](https://render.githubusercontent.com/render/math?math=K) be the number of paralleled EEs; ![](https://render.githubusercontent.com/render/math?math=C_k) be the capacity of each sub-table of EE, where ![](https://render.githubusercontent.com/render/math?math=k) is from 1 to ![](https://render.githubusercontent.com/render/math?math=K); Partition number ![](https://render.githubusercontent.com/render/math?math=ID) is the result of  ![](https://render.githubusercontent.com/render/math?math=HASH()) function, ![](https://render.githubusercontent.com/render/math?math=J=HASH)(packet header), where ![](https://render.githubusercontent.com/render/math?math=j) is the value space of ![](https://render.githubusercontent.com/render/math?math=ID).

Therefore, 

![](https://render.githubusercontent.com/render/math?math=N\leq\sum^{K}_{k=1}C_k\leq{C_0}\cdot{R_d} ) &emsp;&emsp;&emsp;&emsp;&emsp; (1)

![](https://render.githubusercontent.com/render/math?math=D\_flow[i]) is defined as the ratio of the traffic load of one flow ![](https://render.githubusercontent.com/render/math?math=i),

![](https://render.githubusercontent.com/render/math?math=\sum^{N}_{i=1}D\_flow[i]=1,i\in{[1,N]} ) &emsp;&emsp; (2)




![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5837.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5838.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5839.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5840.PNG)
