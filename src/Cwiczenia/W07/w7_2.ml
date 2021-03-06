module type QUEUE_MUT =
  sig
    type 'a t
    (* The type of queues containing elements of type ['a]. *)
    exception Empty of string
    (* Raised when [first q] is applied to an empty queue [q]. *)
    exception Full of string
    (* Raised when [enqueue(x,q)] is applied to a full queue [q]. *)
    val empty: int -> 'a t
    (* [empty n] returns a new queue of length [n], initially empty. *)
    val enqueue: 'a * 'a t -> unit
    (* [enqueue (x,q)] adds the element [x] at the end of a queue [q]. *)
    val dequeue: 'a t -> unit
    (* [dequeue q] removes the first element in queue [q] *)
    val first: 'a t -> 'a
    (* [first q] returns the first element in queue [q] without removing
    it from the queue, or raises [Empty] if the queue is empty. *)
    val isEmpty: 'a t -> bool
    (* [isEmpty q] returns [true] if queue [q] is empty,
    otherwise returns [false]. *)
    val isFull: 'a t -> bool
    (* [isFull q] returns [true] if queue [q] is full,
    otherwise returns [false]. *)
  end;;
module Queue : QUEUE_MUT =
	struct
    exception Empty of string
    exception Full of string
		type 'a t = {
			mutable queue: 'a option array; 
			mutable f:int; mutable r:int; mutable s:int}
		
		let empty size = { queue = Array.make (size+1) None; 
			f = 0; r = 0; s = size}
		
		let isFull q = q.r - q.f = 1 || q.r - q.f = q.s;;
		let isEmpty q = q.r = q.f;;
		let inc v q = if v = q.s then 0 else v+1;;

		let enqueue (v,q) = 
			if isFull q then raise (Full "Full queue")
			else ( q.queue.(q.r)<- Some v; q.r <- (inc q.r q));;

		let dequeue q = 
			if isEmpty q then () else q.f <- (inc q.f q);;

		let first q = 
			if isEmpty q then raise (Empty "Empty queue")
			else match q.queue.(q.f) with
				| None -> failwith "Unexpected Error"
				| Some v -> v;;	
	end;;