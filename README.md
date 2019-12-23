# Proj1

1. Print vampire numbers from 100000 to 200000

2. to\path\proj1>mix run proj1.exs 100000 200000

3. Number of workers created = 1000

4. Size of work unit for each worker = 100
   We determined the work unit size by trying combinations of total number of workers 
   and workload of each worker. 1000 workers with 100 workload size gave the optimum results
   for the range 100000 200000
   (maximum user+sys/real time ratio)

5. Result of running the program:
   
to\path\proj1>mix run proj1.exs 100000 200000
117067 167 701
120600 201 600
125500 251 500
115672 152 761
102510 201 510
105750 150 705
108135 135 801
125248 152 824
135828 231 588
135837 351 387
110758 158 701
105210 210 501
133245 315 423
131242 311 422
129775 179 725
118440 141 840
136525 215 635
150300 300 501
126027 201 627
153436 356 431
152608 251 608
145314 351 414
132430 323 410
125433 231 543
134725 317 425
123354 231 534
146137 317 461
140350 350 401
116725 161 725
126846 261 486
129640 140 926
105264 204 516
125460 204 615 246 510
136948 146 938
146952 156 942
124483 281 443
156915 165 951
152685 261 585
192150 210 915
172822 221 782
163944 396 414
104260 260 401
180225 225 801
175329 231 759
193257 327 591
156240 240 651
186624 216 864
182250 225 810
193945 395 491
197725 275 719
173250 231 750
182650 281 650
190260 210 906
174370 371 470
156289 269 581
162976 176 926

6. Number of cores used:

   real 0m3.204s
   user 0m8.765s
   sys  0m0.363s

   (user+sys)/real = (8.765+0.363)/3.204 = 2.848 cores

7. Largest vampire number we managed to print for ranges [100000, 1000000] - vampire number - 939658 953 986
							 [10000000, 20000000] - vampire number - 16330752 3072 5316


NOTES:

# Supervisor will create multiple workers(genserver) concurrently who will be handling the computation of a range
  of vampire numbers individually(sequentially). Workload depends on the range of numbers given.
  We are using handle_cast to collect and append all the data, and handle_call once to print all the vampire numbers.

# Computing the workload (total numbers of tasks per worker):

  Ex 1: n1=100000, n2=200000, workload = 200000-100000/1000 = 100 tasks
  Ex 2: It also handles corner cases in case the range provided (n2-n1) is not a multiple of 1000.
        We are rounding off in certain way such that it doesn't lose number range.
        n1=100000, n2=794088, workload = 695

# To compute the factors of a number in order to check if it is a vampire number, we are checking the minimum and maximum 
  digit of the number. 
  Eg: If the number to be checked (if it is vampire no. or not) is 135621
  Number of digits of factors of this number = 6/2 = 3
  Minimum digit is 1 , maximum digit is 6. 

  Minimum three digit no. starting from 1 -> 100
  Maximum three digit no. starting from 6 -> 699

  Hence, we can check for factors of 135621 from 100 to 699, since the digits of the factors should be 
  same as the digits of the number. The factors will lie in this range only.
  
  This comes handy for optimising the computation time of larger numbers.



