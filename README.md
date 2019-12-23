# Print Vampire Numbers in ELIXIR

1. Print vampire numbers from 100000 to 200000 <br />

2. to\path\proj1>mix run proj1.exs 100000 200000 <br />

3. Number of workers created = 1000 <br />

4. Size of work unit for each worker = 100 <br />
   We determined the work unit size by trying combinations of total number of workers <br />
   and workload of each worker. 1000 workers with 100 workload size gave the optimum results <br />
   for the range 100000 200000 <br />
   (maximum user+sys/real time ratio) <br />

5. Result of running the program:
   
to\path\proj1>mix run proj1.exs 100000 200000 <br />
117067 167 701 <br />
120600 201 600 <br />
125500 251 500 <br />
115672 152 761 <br />
102510 201 510 <br />
105750 150 705 <br />
108135 135 801 <br />
125248 152 824 <br />
135828 231 588 <br />
135837 351 387 <br />
110758 158 701 <br />
105210 210 501 <br />
133245 315 423 <br />
131242 311 422 <br />
129775 179 725 <br />
118440 141 840 <br />
136525 215 635 <br />
150300 300 501 <br />
126027 201 627 <br />
153436 356 431 <br />
152608 251 608 <br />
145314 351 414 <br />
132430 323 410 <br />
125433 231 543 <br />
134725 317 425 <br />
123354 231 534 <br />
146137 317 461 <br />
140350 350 401 <br />
116725 161 725 <br />
126846 261 486 <br />
129640 140 926 <br />
105264 204 516 <br />
125460 204 615 246 510 <br />
136948 146 938 <br />
146952 156 942 <br />
124483 281 443 <br />
156915 165 951 <br />
152685 261 585 <br />
192150 210 915 <br />
172822 221 782 <br />
163944 396 414 <br />
104260 260 401 <br />
180225 225 801 <br />
175329 231 759 <br />
193257 327 591 <br />
156240 240 651 <br />
186624 216 864 <br />
182250 225 810 <br />
193945 395 491 <br />
197725 275 719 <br />
173250 231 750 <br />
182650 281 650 <br />
190260 210 906 <br />
174370 371 470 <br />
156289 269 581 <br />
162976 176 926 <br />

6. Number of cores used: <br />

   real 0m3.204s <br />
   user 0m8.765s <br />
   sys  0m0.363s <br />
<br />
   (user+sys)/real = (8.765+0.363)/3.204 = 2.848 cores <br />

7. Largest vampire number we managed to print for ranges [100000, 1000000] - vampire number - 939658 953 986 <br />
							 [10000000, 20000000] - vampire number - 16330752 3072 5316 <br />


NOTES: <br />

# Supervisor will create multiple workers(genserver) concurrently who will be handling the computation of a range <br />
  of vampire numbers individually(sequentially). Workload depends on the range of numbers given. <br />
  We are using handle_cast to collect and append all the data, and handle_call once to print all the vampire numbers. <br />

# Computing the workload (total numbers of tasks per worker): <br />

  Ex 1: n1=100000, n2=200000, workload = 200000-100000/1000 = 100 tasks <br />
  Ex 2: It also handles corner cases in case the range provided (n2-n1) is not a multiple of 1000. <br />
        We are rounding off in certain way such that it doesn't lose number range. <br />
        n1=100000, n2=794088, workload = 695 <br />

# To compute the factors of a number in order to check if it is a vampire number, we are checking the minimum and maximum 
  digit of the number.  <br />
  Eg: If the number to be checked (if it is vampire no. or not) is 135621 <br />
  Number of digits of factors of this number = 6/2 = 3 <br />
  Minimum digit is 1 , maximum digit is 6.  <br />

  Minimum three digit no. starting from 1 -> 100 <br />
  Maximum three digit no. starting from 6 -> 699 <br />

  Hence, we can check for factors of 135621 from 100 to 699, since the digits of the factors should be 
  same as the digits of the number. The factors will lie in this range only. <br />
  
  This comes handy for optimising the computation time of larger numbers. <br />



