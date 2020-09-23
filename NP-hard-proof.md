# Appendix

## Terminology and Definition:



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
   


## Proof
We aim at proofing that the Load-Balance-Based Table Division problem(LBBTD) is an NP-hard problem. We first introduce the Average-Division problem that is a classic NP-Complete problem, and then, we demonstrate that the LBBTD problem is a NP-hard problem by showing the reduction from the Average-Division problem to the LBBTD problem.

####  Terminology 



We say that a language ![](https://render.githubusercontent.com/render/math?math=L_1) is polynomial-time reducible to a language ![](https://render.githubusercontent.com/render/math?math=L_2), written ![](https://render.githubusercontent.com/render/math?math=L_1\leq_p{L_2}), if there exists a polynomial-time computable function ![](https://render.githubusercontent.com/render/math?math=f:\{0,1\}^*\rightarrow\{0,1\}^*) such that for all ![](https://render.githubusercontent.com/render/math?math=x\in\left\{0,1\right\}^{\ast}), ![](https://render.githubusercontent.com/render/math?math=x\in{L}_{1}) ![](https://render.githubusercontent.com/render/math?math=\Leftrightarrow{f})  ![](https://render.githubusercontent.com/render/math?math=(x)) ![](https://render.githubusercontent.com/render/math?math=\in{L}_{2}).

#### The Average-Division problem

Given a finite set ![](https://render.githubusercontent.com/render/math?math=S={1,2,\ldots,n}), and the weight function ![](https://render.githubusercontent.com/render/math?math=w:S\rightarrow\mathbb{Z}), we ask whether there is a subset ![](https://render.githubusercontent.com/render/math?math=S'\subseteq{S}) can satisfy:

![](https://render.githubusercontent.com/render/math?math=\sum_{X\in{S'}}w(x))=![](https://render.githubusercontent.com/render/math?math=\dfrac{1}{2}\sum_{X\in{S}}w(x))

We define the average division problem as a language:

#### AVG_DIV:=

{ ![](https://render.githubusercontent.com/render/math?math=\langle{S,w}\rangle:S\subset\mathbb{N}),

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=w) is function from ![](https://render.githubusercontent.com/render/math?math=\mathbb{N}\rightarrow\mathbb{Z}),

&emsp;&emsp;&emsp;&emsp;there exists a subset ![](https://render.githubusercontent.com/render/math?math=S'\subseteq{S}) such that 


&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=\sum_{X\in{S'}}w(x)) = ![](https://render.githubusercontent.com/render/math?math=\dfrac{1}{2}\sum_{X\in{S}}) ![](https://render.githubusercontent.com/render/math?math=w(x))&emsp;}

#### Lemma A:

The average division problem is NP-hard.

#### Theorem 1:

The LBBTD problem is NP-hard.

#### Proof:

We first introduce the decision problem of the LBBTD problem and define it as a language, and then give the reduction from the AVG_DIV to the LBBTD problem.

#### The decision problem of the LBBTD problem:


Given the set of ID group ![](https://render.githubusercontent.com/render/math?math=S=\{1,2,\ldots,n\}), the storing redundancy rate of the whole mechanism ![](https://render.githubusercontent.com/render/math?math=R_d), the number of the flow tables ![](https://render.githubusercontent.com/render/math?math=K), the capacity of each flow table ![](https://render.githubusercontent.com/render/math?math=C_k), the tolerance of the usage discrepancy of the table sizes ![](https://render.githubusercontent.com/render/math?math=T), the traffic distribution among the ID groups ![](https://render.githubusercontent.com/render/math?math=D\_id[j],j\in{S}), the number of compression entry of each flow table ![](https://render.githubusercontent.com/render/math?math=V_k), and real numbers ![](https://render.githubusercontent.com/render/math?math=q_1,q_2). We ask whether there exists an allocation scheme ![](https://render.githubusercontent.com/render/math?math=\{Q_i\}^{K}_{i=1})  that can satisfy the following restrictions:

&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=Q_k\subseteq{S},k\in[1,k],\cup{Q_k}=S,N\leq\sum^{K}_{k=1}C_k\leq{C_0}\cdot{R_d}) &emsp;&emsp; (1)
 
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=||\dfrac{Q_i}{C_{ki}}|-|\dfrac{Q_j}{C_{kj}}||\cdot{100percent\leq{T}}(i,j,ki,kj\in[1,k])) &emsp; &emsp; &emsp; (2)
 
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=BOOL(i,j)) =1 ![](https://render.githubusercontent.com/render/math?math=j\in{Q_i}) or 0 ![](https://render.githubusercontent.com/render/math?math=j\notin{Q_i}) &emsp; &emsp; &emsp; &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; (3)
  
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=G\left[j\right]=\sum^{k}_{i=1}BOOL)(i,j)=![](https://render.githubusercontent.com/render/math?math=1(j\in{S})) &emsp; &emsp; &emsp; &emsp;&emsp; &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; (4)
   
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=\sum_{j\in{S}}G\left[i\right]=2^{P}(j\in{S})) &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp;&emsp; &emsp; &emsp; &emsp;&emsp; &emsp;&emsp; (5)
   
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=D[k]=\sum_{j\in{Q_k}}D_{-}id[i](k=1,\ldots,K))&emsp; &emsp; &emsp; &emsp;&emsp; &emsp;&emsp;&emsp;&emsp;&emsp; (6)
   
&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=F_1k]=MAX(D[k])) ![](https://render.githubusercontent.com/render/math?math=-MlN(D[k]))![](https://render.githubusercontent.com/render/math?math=\leq{q_1})&emsp; &emsp; &emsp; &emsp;&emsp; &emsp; &emsp;&emsp;&emsp; (7)

&emsp;&emsp; ![](https://render.githubusercontent.com/render/math?math=F_2[k]=C_0-\sum^{K}_{k=1}V_k\leq{q_2})  &emsp; &emsp; &emsp; &emsp; &emsp;&emsp; &emsp; &emsp; &emsp; &emsp; &emsp; &emsp; (8)

#### Minimize a Pareto function:

&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=F[k]=(F_1[k],F_2[k])) ![](https://render.githubusercontent.com/render/math?math=k\in[1,K])

#### We define the LBBTD problem as a language:

LBBTD:=

{ ![](https://render.githubusercontent.com/render/math?math=\langle{S,K,R_d,C_k,T,D\_id,V_k,q_1,q_2}\rangle:)

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=S=\{1,2,\ldots,n\}) is the set of the ID groups,

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=K\in\mathbb{N}) is the number of the flow tables,

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=R_d) is the redundancy rate of the whole mechanism, 

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=T) is the tolerance of the usage discrepancy of the table sizes,

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=$D\_id) is a function from ![](https://render.githubusercontent.com/render/math?math=S\rightarrow\mathbb{R}), which is the traffic distribution among the ID groups,

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=C_k) is the capacity of each flow table,

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=V_k)is the number of compression entry of each flow table,

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=q_1,q_2\in\mathbb{R}), and there exists an allocation scheme  ![](https://render.githubusercontent.com/render/math?math=\{Q_i\}^{K}_{i=1})  that satisfies the eight restrictions given in the LBBTD decision problem. }

We now show that AVG_DIV ![](https://render.githubusercontent.com/render/math?math=\leq_p)LBBTD. Namely we show that AVG\_DIV can be reduced to LBBTD. Let ![](https://render.githubusercontent.com/render/math?math=\langle{S_1,w}\rangle)  be an instace of AVG_DIV, we construct an instance ![](https://render.githubusercontent.com/render/math?math=\langle{S,K,R_d,C_k,T,D\_id,V_k,q_1,q_2}\rangle) of LBBTD as follows:

#### Let:

![](https://render.githubusercontent.com/render/math?math=S=S_1,D\_id[i]=w(i)) ![](https://render.githubusercontent.com/render/math?math=(i\in{S_1})),![](https://render.githubusercontent.com/render/math?math=K=2,R_d=1,T=\infty,q_1=0,V_k=0,C_k=\dfrac{C_{0}}{K},q_2=C_0),because of ![](https://render.githubusercontent.com/render/math?math=T,q_2), the restriction(2,8) is now released, and using restriction (4,5), we get that ![](https://render.githubusercontent.com/render/math?math=Q_1\cap{Q_2}=\phi) and the restrictions are re-constructed as follow:

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=Q_1\cup{Q_2}=S_1)&emsp; &emsp; &emsp; &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; (I)

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=Q_1\cap{Q_2}=\phi)&emsp; &emsp; &emsp; &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; &emsp; (II)

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=D[j]:=\sum_{x\in{Q_j}}w(x))![](https://render.githubusercontent.com/render/math?math=(j=1,2))&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; &emsp; &emsp; &emsp;  (III)

&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=F_1:Max(D[j]))![](https://render.githubusercontent.com/render/math?math=-Min(D[j])=0)&emsp;&emsp; &emsp; &emsp;&emsp;&emsp;&emsp; &emsp; &emsp; &emsp; 

&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;![](https://render.githubusercontent.com/render/math?math=\Leftrightarrow{D}[1]=D[2]=\dfrac{1}{2}\sum_{x\in{S_1}}w(x))&emsp;&emsp;&emsp;&emsp; &emsp;&emsp; &emsp;&emsp; (IV)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5839.PNG)

![image](https://github.com/Adaptable-Switch/AS_test/blob/master/figs/IMG_5840.PNG)
