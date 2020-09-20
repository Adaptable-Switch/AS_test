

# Adaptable_Switch_Test

## 1.Hardware Design.

In HDL folder, it's hardware design VHDL code files, as figure below shown.

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/asarc.jpg)

An opensourced packet generator can be find in the project of [PacketGenerator](https://github.com/NetFPGA/netfpga/wiki/PacketGenerator), the packet data can be read from PCAP files.

The key contribution in PL part is the Dispatch module that is combined from source files (1)input_arb.v, (2)crossbar.v and (3)selector.v.

Also we implemented the key module in SS, the module of (1)MMU.v.


Besides, other important modules are the data BUS converter and the output BUS: (1)c8to512.v, (2)lookup.v.

Use cases are implemented in files: (1)statefull.v (2)ndp48.v (3)ndpqs.v (4)measure.v

## 2.Software Design.

The SA-based heuristic algorithm is following the processing graph below.

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/Saprocess2.jpg)

The algorithm is implemented in heuristic.py file.



The input of the algorithm is the flow group ![](https://render.githubusercontent.com/render/math?math=G\\_{id}[j]) that is generated by classify HASH function and its corresponding traffic volume ![](https://render.githubusercontent.com/render/math?math=D\\_{id}[j]). The solution w is the distribution of the ![](https://render.githubusercontent.com/render/math?math=G\\_{id}[j]) in EEs. 

The different group distribution contained in the EE generate the total traffic throughput performance demand. The goal of the algorithm is to make demand of each EE as balanced as possible, and does not exceed the maximum processing capacity  of each EE (![](https://render.githubusercontent.com/render/math?math=P_{max})), which is a predictable constant.

### 2.1.The initialization of the SA algorithm.

a) Check if there is a ![](https://render.githubusercontent.com/render/math?math=D\\_{id}[j]) that exceeds the ![](https://render.githubusercontent.com/render/math?math=P_{max}), it need to duplicate into ![](https://render.githubusercontent.com/render/math?math=N) copies (![](https://render.githubusercontent.com/render/math?math=N\leq{K})) and put them on different EE. The throughput demand of each sub-group ![](https://render.githubusercontent.com/render/math?math={\dfrac{D\\_{id}[j]}{N}}\leq{P_{max}}).

b) Randomly distribute the ![](https://render.githubusercontent.com/render/math?math=G\\_{id}[j]) and duplicated repeated combinations into ![](https://render.githubusercontent.com/render/math?math=K) sets to form an initial solution ![](https://render.githubusercontent.com/render/math?math=w).



### 2.2.Generate new candidate solution in the search area.

A solution is a flow group allocation. To generate new neiboring solution, after the init step of the algorithm, it randomly select a flow group from any one EE(i) to another EE(j).

### 2.3.The evaluation function in SA.

The defination of the evaluation function,![](https://render.githubusercontent.com/render/math?math=J(w)):

![](https://render.githubusercontent.com/render/math?math=D\\_{id}[j])
is the traffic volume of one of the flow groups, ![](https://render.githubusercontent.com/render/math?math=j\in[1,256]).

The total traffic of Execution Engine(i) ![](https://render.githubusercontent.com/render/math?math={}=\\sum{D\\_id[j]},(i\in[1,K],j\in{EE_i})).

The evaluation function ![](https://render.githubusercontent.com/render/math?math=J(w)=\\sum^{K}_{i=1}(D^{2}_{i}-D^{2}_{average})^{\dfrac{1}{2}}).
this equation represents the traffic load balancing of the table allocation.

