# simulated annealing for table allocation
import time
import random
import math
import sys
import copy


# parameter define
num_pipeline = 8

num_id = 256

TIME_LIMIT = 20 #limit heuristic algorithm running time to TIME_LIMIT seconds

Pmax = 5000 #maximum processing performance of one EE, this can be re-defined by any end users, according to the hardware spec.

# The local search looks for a more balanced solution by searching the allocation of flows in each group, within a bit more of 
# the neighboring space, while the global search allows searching with a random walk in the entire space with 
# a small probability, in order to avoid local search trap.
Prandomwalk = 0.000001 


# A example for testing: the traffic volume of each flow set, which can be changed in run-time.
# Users can use their own data sets for doing more evaluation.
load = [988 , 988 , 984 , 983 , 982 , 981 , 975 , 973 , 970 , 968 , 966 , 962 , 948 , 946 , 944 , 936 , 933 , 931 , \
926 , 918 , 917 , 914 , 912 , 908 , 908 , 908 , 906 , 899 , 897 , 895 , 893 , 884 , 883 , 875 , 872 , 869 , 867 , 864 , \
858 , 850 , 850 , 841 , 839 , 831 , 829 , 816 , 812 , 811 , 798 , 798 , 791 , 784 , 784 , 778 , 776 , 775 , 770 , 764 , \
762 , 757 , 757 , 750 , 745 , 743 , 737 , 734 , 733 , 730 , 723 , 720 , 710 , 709 , 708 , 706 , 703 , 703 , 700 , 698 , \
695 , 677 , 676 , 672 , 672 , 672 , 671 , 663 , 661 , 661 , 655 , 649 , 641 , 641 , 640 , 639 , 637 , 629 , 624 , 623 , \
620 , 620 , 616 , 616 , 615 , 613 , 605 , 603 , 600 , 596 , 595 , 584 , 574 , 572 , 566 , 565 , 564 , 560 , 559 , 551 , \
539 , 538 , 535 , 534 , 531 , 530 , 525 , 517 , 517 , 515 , 514 , 512 , 507 , 503 , 496 , 496 , 493 , 488 , 487 , 484 , \
482 , 480 , 477 , 476 , 467 , 460 , 455 , 453 , 452 , 451 , 446 , 427 , 426 , 420 , 415 , 414 , 403 , 401 , 399 , 398 , \
391 , 388 , 384 , 376 , 374 , 368 , 360 , 358 , 340 , 336 , 326 , 325 , 318 , 316 , 310 , 308 , 306 , 299 , 297 , 294 , \
287 , 283 , 282 , 278 , 262 , 261 , 255 , 254 , 254 , 253 , 247 , 247 , 244 , 242 , 242 , 237 , 237 , 236 , 234 , 230 , \
229 , 224 , 216 , 215 , 214 , 213 , 210 , 209 , 209 , 202 , 202 , 199 , 195 , 178 , 170 , 165 , 165 , 161 , 160 , 155 , \
148 , 142 , 140 , 139 , 139 , 130 , 129 , 128 , 127 , 125 , 119 , 108 , 103 , 98 , 91 , 89 , 81 , 72 , 67 , 65 , 62 , \
58 , 57 , 57 , 55 , 54 , 54 , 54 , 37 , 36 , 33 , 30 , 30 , 19 , 16 , 15 , 5 , 4]

## the diction "duplica" is to store the duplication information, 
## e.g. duplica['18'] = [256,257,258], 
## this means that the flow group 18 is duplicated to 4 replica, 
## these 4 replica is stored in the location of '18,256,257,258' in the 'load' list.
duplica = {}

# A example of real traffic of LTE trace.
realload = [5297,13160,6698,4638,3588,2584,3959,3652,7981,3543,2657,2458,2467,5199,2797,3052,2698,4827,3120,3822,2945,\
3667,2632,2276,4997,3475,1315,3168,2574,3419,3001,9353,3794,5412,2442,4036,2796,2663,3662,5292,2538,1844,3476,4596,2574,\
13857,4720,4283,2326,5817,5147,7982,13291,3490,4729,4769,2576,2111,8983,4622,4614,3437,10158,2999,4381,2765,4469,9393,\
3102,3688,2370,2380,2597,8875,4225,2467,4253,11774,3509,1981,2498,2963,10837,3628,2627,2399,1570,2472,4924,8552,8183,\
3126,5934,4401,2528,2657,10668,2206,10609,3113,4872,11293,7089,2644,2034,6660,5628,5035,2360,5659,7716,5885,2873,3131,\
4227,1571,3096,6107,8987,2886,6300,2745,7278,1765,2884,3222,8474,15179,7456,4225,3071,2360,2933,5741,2198,10353,2193,\
3877,8188,2267,3999,2163,21061,18910,9314,6599,4682,8976,1961,3045,10880,2481,3067,7797,2263,3390,3227,8173,2239,3649,\
5620,2596,6032,3407,4753,4842,10483,4717,2230,3734,4146,2387,2979,3929,2160,2639,6177,3159,2654,7427,3088,1903,4193,2777,\
2216,7734,3371,2728,4794,4061,7332,5160,4852,5510,6340,6099,2103,9184,14665,5941,3762,3279,3018,4276,6641,4877,6966,2444,\
16700,3266,3375,8781,2953,3255,6048,2929,4251,7491,2056,2501,4857,4592,2849,2518,1209,3321,4706,4299,2094,3243,6830,6005,\
2773,4854,4122,3876,13849,2881,2743,2623,4160,3676,13426,4054,7938,6552,2071,3273,1662,8567,4510,2370,3835,10418,7044,1889]

# Generate a load set for testing.
def gen_random_load():
  load = []
  
  for i in range(num_id):
    a = int(random.random() * 1000)
    load.append(a)
    
  for j in load:
    print j,",",
  print "-------------"
  load.sort(reverse=True)
  for j in load:
    print j,",",

# Calcutaing the traffic balancing index, if err is smaller, the more balance.
def J(Y0):
  l = len(Y0)
  a = []
  suma = []
  
  for i in range(l):
    a.append(Y0[i])
    suma.append(sum(a[i]))
  # print "J()",a,b,c,d
  avg = (sum(suma))/l
  err = 0
  
  for i in range(l):
    err = err + (avg - suma[i])*(avg - suma[i])
  err = err
  # err = (avg - a)*(avg - a) + (avg - b)*(avg - b) + (avg - c)*(avg - c) + (avg - d)*(avg - d)
  # print "==",a,b,c,d
  # print err
  return err

def find_min_list(intputlist):
  l = len(intputlist)
  flag = 1
  out = 0
  
  for i in range(l):
    if flag:
      minn =i
      flag = 0
    if intputlist[i] < minn:
      minn = intputlist[i]
      out = i
  return out

########################################## heuristic: init
def init_real():

  for i in load:
    if i > Pmax: # to find if the flow group should be duplicated into multiple processing pipeline.
      temp = Pmax
      N = 0      # N is to indecate the number of replica.
      while True:
        N = N + 1
        temp = temp / N
        if temp < Pmax:
          break
        else:
          temp = temp * N
      num_last_list = len(load)
      traffic = i / N
      diction = [] #the replica information, it will be stored in the 'replica' diction data structure
      for j in range(N):
        load.append(traffic)
        diction.append(num_last_list)
        num_last_list = num_last_list + 1
        duplica[i] = diction #the replica information, stored in the 'replica' diction data structure

  a = []
  summ = []
  each = num_id / num_pipeline



  for i in range(num_pipeline):
    a.append([])
    summ.append([])

  for i in realload:
    for i in range(summ):
      summ[i] = sum(a[i])

def init_without_opt(num_pipeline):

  for i in load:
    if i > Pmax: # to find if the flow group should be duplicated into multiple processing pipeline.
      temp = Pmax
      N = 0      # N is to indecate the number of replica.
      while True:
        N = N + 1
        temp = temp / N
        if temp < Pmax:
          break
        else:
          temp = temp * N
      num_last_list = len(load)
      traffic = i / N
      diction = [] #the replica information, it will be stored in the 'replica' diction data structure
      for j in range(N):
        load.append(traffic)
        diction.append(num_last_list)
        num_last_list = num_last_list + 1
        duplica[i] = diction #the replica information, stored in the 'replica' diction data structure
  a = []

  each = num_id / num_pipeline#64

  for i in range(num_pipeline):
    a.append(load[each*i:each*i+each])
  return a

def init_without_opt_real(num_pipeline):

  for i in load:
    if i > Pmax: # to find if the flow group should be duplicated into multiple processing pipeline.
      temp = Pmax
      N = 0      # N is to indecate the number of replica.
      while True:
        N = N + 1
        temp = temp / N
        if temp < Pmax:
          break
        else:
          temp = temp * N
      num_last_list = len(load)
      traffic = i / N
      diction = [] #the replica information, it will be stored in the 'replica' diction data structure
      for j in range(N):
        load.append(traffic)
        diction.append(num_last_list)
        num_last_list = num_last_list + 1
        duplica[i] = diction #the replica information, stored in the 'replica' diction data structure
  a = []
  each = num_id / num_pipeline#64
  # print "len real",len(realload)
  for i in range(num_pipeline):
    a.append(realload[each*i:each*i+each])
  return a
########################################## heuristic: init


def switch(a,ai,b,bi):
  tmp = a[ai]
  a[ai] = b[bi]
  b[bi] = tmp
  return a,b
    
def get_2_groupID(num_pipeline,Y):
  sum_k = []
  sum_k_revers = []
  sum_k_1 = []
  sum_k_1_revers = []
  sum_k_1_cdf = []
  sum_k_1_cdf_revers = []

  for i in Y:
    sum_k.append(sum(i))

  sum_total = sum(sum_k)
  # The more workload an execution engine has, the larger probability it gets a flow group moving out; 
  # while a destination execution engine for the moving group is selected with probability that is inversely proportional to the workload of the execution engine.
  #
  for i in sum_k:
    sum_k_1.append(i*1.0/sum_total)
    sum_k_revers.append(1.0/i)
  sum_total_revers = sum(sum_k_revers)

  for i in sum_k_revers:
    sum_k_1_revers.append(i/sum_total_revers)

  cdfsum = 0
  cdfsum_revers = 0
  for i in sum_k_1:
    cdfsum += i
    sum_k_1_cdf.append(cdfsum)
  sum_k_1_cdf[-1] = 1

  for i in sum_k_1_revers:
    cdfsum_revers += i
    sum_k_1_cdf_revers.append(cdfsum_revers)
  sum_k_1_cdf_revers[-1] = 1
  
  
  # generating the number of source EE, according to the probability LIST "sum_k_1_cdf"
  random_result_source = random.random()
  remove_source = -1
  for i in sum_k_1_cdf:
    remove_source += 1
    if random_result_source < i:
      break
  
  # generating the number of destination EE, according to the probability LIST "sum_k_1_cdf_revers"
  random_result_destination = random.random()
  remove_destination = -1
  for i in sum_k_1_cdf_revers:
    remove_destination += 1
    if random_result_destination < i:
      break
  
  if remove_destination == remove_source:
    remove_destination += 1
    if remove_destination == len(Y):
      remove_destination = 0

  each = num_id / num_pipeline#

  item_in_source = int(random.random()*each)
  item_in_dest = int(random.random()*each)

  return remove_source,item_in_source,remove_destination,item_in_dest


##########################################     heuristic: process.
##########################################     input: 1) the number of paralleled Execut Engines.
def run(num_pipeline,errbar):#############     input: 2) the balancing tolerance, for example 10% or 5%.
  Y = init_without_opt_real(num_pipeline)#     output:1) the table allocation solution.
  Yp1 = copy.deepcopy(Y)                 #           :2) the running time durition, indecated in seconds.
  jmin = 9999999999999
  times = 0
  err = 1
  timerstart = time.clock()
  timernow = time.clock()
  running_time = timernow - timerstart
  average = sum(realload)/num_pipeline
  
  while err > errbar and running_time < TIME_LIMIT:
    timernow = time.clock()
    running_time = timernow - timerstart
    times = times + 1
    a,ai,b,bi = get_2_groupID(num_pipeline, Yp1)
    # print "a,ai,b,bi",a,ai,b,bi
    l = num_pipeline
    switch(Yp1[a],ai,Yp1[b],bi)
    j0 = J(Y)
    j1 = J(Yp1)
    de = j0 - j1
    ptemp = random.random()
    if de > 0  or ptemp < Prandomwalk:
      Y = copy.deepcopy(Yp1)
      jmin = j1
      sum1 = []
      for i in range(l):
        sum1.append(sum(Yp1[i]))
      err = []
      # print sum1,average
      for i in range(l):
        err.append(abs((sum1[i] - average)*1.0/average))
      err = max(err)
      # print "jmin =",jmin,"de",de, "times",times,"err",err*100,"%".
      pass
  # print times, err*100
  print Yp1                                    # output:1) the table allocation solution.
  return times, err*100, running_time          # 2) the running time durition, indecated in seconds.
##########################################     heuristic: process.


# example test, 256 flow groups, 8 excution engines

times, err, running_time = run(8,0.05)
print "number of iter manner work round:", times,"| J(w):",err, "| Running Time:",running_time
