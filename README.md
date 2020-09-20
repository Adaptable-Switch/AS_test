

# Adaptable_Switch_Test

## Hardware Design.

In HDL folder, it's hardware design VHDL code files, as figure below shown.

![image](https://github.com/qiaosiyi/qiaosiyi.github.io/blob/master/figs/bpu2.jpg)

An opensourced packet generator can be find in the project of [PacketGenerator](https://github.com/NetFPGA/netfpga/wiki/PacketGenerator), the packet data can be read from PCAP files.

The key contribution in PL part is the Dispatch module that is combined from source files (1)input_arb.v, (2)crossbar.v and (3)selector.v.

Also we implemented the key module in SS, the module of (1)MMU.v.


Besides, other important modules are the data BUS converter and the output BUS: (1)c8to512.v, (2)lookup.v.

Use cases are implemented in files: (1)statefull.v (2)ndp48.v (3)ndpqs.v (4)measure.v

## Software Design.

The SA-based heuristic algorithm is following the processing graph below.

![image](https://github.com/qiaosiyi/qiaosiyi.github.io/blob/master/figs/saprocess.png)

The algorithm is implemented in heuristic.py file.

### Generate new candidate solution in the search area.

A solution is a flow group allocation. To generate new neiboring solution, after the init step of the algorithm, it randomly select a flow group from any one EE(i) to another EE(j).

### The evaluation function in SA.

The defination of the evaluation function,![](https://render.githubusercontent.com/render/math?math=J(w)):

![](https://render.githubusercontent.com/render/math?math=D\\_{id}[j])
is the traffic volume of one of the flow groups, ![](https://render.githubusercontent.com/render/math?math=j\in[1,256]).

The total traffic of Execution Engine(i) ![](https://render.githubusercontent.com/render/math?math={}=\\sum{D\\_id[j]},(i\in[1,K],j\in{EE_i})).

The evaluation function ![](https://render.githubusercontent.com/render/math?math=J(w)=\\sum^{K}_{i=1}(D^{2}_{i}-D^{2}_{average})^{\dfrac{1}{2}}).
this equation represents the traffic load balancing of the table allocation.

