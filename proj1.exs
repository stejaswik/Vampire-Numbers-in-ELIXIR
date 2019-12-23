# Supervisor is creating 1000 workers
defmodule Proj1 do
  use Supervisor

  def start_link(limits) do
    Supervisor.start_link(__MODULE__, [limits])
  end

  def init(limits) do
    workers = 999
    children = Enum.map(0..workers, fn(worker_id) ->
      worker(Worker, [worker_id] ++ limits, [id: worker_id, restart: :permanent])
    end)

    supervise(children, strategy: :one_for_one)
  end
end

# Each worker is handling workload
defmodule Worker do
  use GenServer

  def start_link(worker_id, limits) do
    GenServer.start_link(__MODULE__, [worker_id] ++ limits)
  end
  
  # Initialising workers and assigning workload
  def init(stack) do
    work(stack)
    {:ok, stack}
  end

  def work(stack) do
    GenServer.cast(self(), {:disp, stack})
  end
 
  # Using handle_cast (asynchronous) to iterate over workload
  def handle_cast({:disp, value}, stack) do
    [worker_id | tail] = value
    [n1 | n2] = tail
    loop(worker_id, n1, n2)
    {:noreply, stack}
  end

  # Processing and redirecting display to Dispop
  def loop(worker_id, n1, n2_lis) do
    n2 = List.first(n2_lis)
    z = Integer.digits(n2-n1)

    # Computing workload dynamically from input 
    dig = Enum.chunk_every(z,3) |> List.last()
    workload = case dig do
        [0,0,0] -> round((n2-n1)/1000)
        _ ->
        number = 1000 - String.to_integer(Enum.join(dig))
        n2 = n2 + number
        round((n2-n1)/1000)
    end
    
    # Creating list of numbers from worker_id, workload, and sending them 
    # to check_initial
    case worker_id do
      x when x < 1000 ->
        start = n1+ worker_id*workload
        en = n1+ (worker_id+1)*workload
        new = for c <- start..en, c<=n2, do: c    

        w = if (length(new) < workload) or (worker_id == 999) do
              length(new) - 1
            else
              length(new) - 2
            end

        Enum.each(0..w, fn(j) ->
        num = Enum.at(new,j)
        if num != nil do
          check_initial(num)
        end
        end)
      _->
        nil
      end
  end

  # Perfoming initial checks on the number and passing
  # it to get_min_max function
  def check_initial(n) do
    z = Integer.digits(n)
    new_list = for c <- z, c>0, do: c
    case {length(z), length(new_list)} do
      {x,y} when x-y < x-2 and rem(x,2) == 0 ->
        get_min_max(new_list, z)
      _ ->
        nil
      end
  end

  # Passing minimum and maximum digits list to get_fangs()
  def get_min_max(new_list, n) do
    min_digit = [Enum.min(new_list)]
    len = round(length(n)/2)-1
    min_list = min_digit++ List.duplicate(0, len)
    max_digit = [Enum.max(new_list)]
    max_list = max_digit++ List.duplicate(9, len)
    get_fangs(min_list, max_list, n)
  end

  # Making a list of all the vampire numbers and fangs,
  # passing it to Dispop.save()
  def get_fangs(min, max, n) do
    min_num = String.to_integer(Enum.join(min))
    max_num = String.to_integer(Enum.join(max))
    num = String.to_integer(Enum.join(n))
    x_new = for x <- min_num..max_num, rem(num,x) == 0, do: x
    list_new = for x <- x_new, vampire(x,n) == 1, do: x
    f1 = Enum.map(list_new, fn y -> y end)
    f2 = Enum.map(f1, fn y -> round(num/y) end)
    fangs = []
    fangs = for c <- 0..length(f1)-1 do
        fangs ++ [Enum.at(f1,c)] ++ [Enum.at(f2,c)]
      end
    fangs = List.flatten(fangs)
    if is_list(f1) and length(f1) > 0 do
      val = Enum.join(fangs, " ")
      str = "#{num} " <> val
      Dispop.save(str)
    else
      nil
    end
  end

  # Checking if a given number is a vampire number
  def vampire(y,n) do
    num = String.to_integer(Enum.join(n))  
    fang = round(num/y)
    y_digits = Integer.digits(y)
    fang_digits = Integer.digits(fang)
    rem_digits = n -- y_digits
    val_fang = Enum.count(fang_digits -- rem_digits) == 0
    val_y = Enum.count(y_digits -- n) == 0
    case {fang, y} do
      {x,m} when x>m and val_fang and val_y and (rem(x,10)!=0 or rem(m,10)!=0) ->
      1
      _ ->
      0
    end  
  end
end

# Using genserver to store and print the vampire numbers and fangs
defmodule Dispop do
  use GenServer

  def start_link(stack) do
    GenServer.start_link(__MODULE__, stack, name: __MODULE__)
  end

  def init(stack) do
    {:ok, stack}
  end

  # Being invoked everytime a vampire number is generated
  def save(value) do
    GenServer.cast(__MODULE__, {:saveval, [value]})
  end

  # Making a list of all the vampire numbers by appending values
  # to the existing state each time it is invoked
  def handle_cast({:saveval, list}, stack) do
    {:noreply, list ++ stack}
  end

  # Used to print all the vampire numbers
  def print() do
    GenServer.call(__MODULE__, :printval)
  end

  # Synchronously prints all the vampire-fang pairs
  def handle_call(:printval, _from, stack) do
    {:reply, stack, stack}
  end
end
 
# Parsing CLI arguments
n = Enum.at(System.argv(),0)
k = Enum.at(System.argv(),1)
n1 = String.to_integer(n,10)
n2 = String.to_integer(k,10)

# Assigning default value to Dispop
Dispop.start_link([])

# Starting the supervisor, which will assign tasks to workers
{:ok, _pid} = Proj1.start_link([n1,n2])

# Accessing Dispop and printing the final result
Enum.each(Dispop.print(), fn y -> IO.puts(y) end)


