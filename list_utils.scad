
// Flatten an a list of lists to only contain the inner lists contents directly.
// It can handle outer lists of mixed values!
// If there are three or more levels of nested lists, only the middle (second) level is removed.
// If you want to flatten ALL levels of the list, use flatten_completely() instead
function flatten(list) = [ for(l = list) each l ];

//  Test cases
//  echo(flatten([]));
//  echo(flatten([[]]));
//  echo(flatten([[0], 1]));
//  echo(flatten([[0], [1]]));
//  // preserve additional levels of lists!
//  echo(flatten([[0], [[1]]]));

// Flatten an a list of lists to only contain non-list values in a single list directly.
// It can handle outer lists of mixed values!
// If there are three or more levels of nested lists, all levels of the list are recursively flattened.
// If you want to flatten only one level of the list, use flatten() instead!
function flatten_completely(list) = [ for(l = list) each is_list(list) ? flatten_completely(l) : l];

//  Test cases
//  echo(flatten_completely([]));
//  echo(flatten_completely([[]]));
//  echo(flatten_completely([[0], 1]));
//  echo(flatten_completely([[0], [1]]));
//  echo(flatten_completely([[0], [[[[1]]]]]));
//  echo(flatten_completely([[[[[[0]]]]], [[1], 2,[[[3]]]]]));

// Inverse operation of Flatten.
// Each value in the input list is wrapped in a list and added to the output
function expand(list) = [ for(l = list) [l]];

//  Test cases
assert(expand([]) == []);
assert(expand([[]]) == [[[]]]);
assert(expand([0, 1]) == [[0],[1]]);


// Preped elem to the list as the new first element
function prepend(list, elem) = flatten([ elem, list]);

//  Test cases
assert(prepend([], 4) == [4]);
assert(prepend([0], 4) == [4,0]);

// Insert elem at position index into the list.
// If index is negative or zero the element is added as the first element (use prepend instead)
// If the index is larger than the list length, then elem will simply be appended as the last element (use append instead)
function insert(list, index, elem) = flatten([
    index <= 0 ? [] : subrange(list, 0, min(index-1, len(list) - 1)),
    elem,
    index > len(list) - 1 ? [] : subrange(list, max(0, index), len(list) - 1)
]);
//  Test cases
assert(insert([0,1,2,3], -1,4) == [4,0,1,2,3]);
assert(insert([0,1,2,3],  0,4) == [4,0,1,2,3]);
assert(insert([0,1,2,3],  1,4) == [0,4,1,2,3]);    
assert(insert([0,1,2,3],  2,4) == [0,1,4,2,3]);    
assert(insert([0,1,2,3],  3,4) == [0,1,2,4,3]);   
assert(insert([0,1,2,3],  4,4) == [0,1,2,3,4]);   
assert(insert([0,1,2,3],  5,4) == [0,1,2,3,4]);   
  
// Append an additional  value to a list
function append(list, elem) = flatten([list, elem]);

//  Test cases
assert(append([], 4) == [4]);
assert(append([0], 4) == [0,4]);

function replace(list, index, elem) = let(last_index = len(list) - 1) flatten([
    index <= 0 ? [] : subrange(list, 0, min(index-1, last_index)),
    index >= 0 && index <= last_index ? elem : [],
    index >= last_index ? [] : subrange(list, max(index == 0 ? 1 : 0, index+1), len(list) - 1)
]);
    
assert(replace([0,1,2,3], -1,4) == [0,1,2,3]);
assert(replace([0,1,2,3],  0,4) == [4,1,2,3]);
assert(replace([0,1,2,3],  1,4) == [0,4,2,3]);    
assert(replace([0,1,2,3],  2,4) == [0,1,4,3]);    
assert(replace([0,1,2,3],  3,4) == [0,1,2,4]);   
assert(replace([0,1,2,3],  4,4) == [0,1,2,3]);   
assert(replace([0,1,2,3],  5,4) == [0,1,2,3]);  
    
function remove(list, index) = let(last_index = len(list) - 1, b1 = max(0, min(index, last_index)))
    flatten([
        b1 > 0  ? [for(i1 = [0 : b1 - 1]) list[i1]] : [],
        /b1 < last_index ? [for(i2 = [b1+1 : last_index]) list[i2]] : []
    ]);
        
echo(remove([0,1,2,3], -1));
assert(remove([0,1,2,3], -1) == [0,1,2,3]);
echo(remove([0,1,2,3], 0));
assert(remove([0,1,2,3],  0) == [1,2,3]);
echo(remove([0,1,2,3], 1));
assert(remove([0,1,2,3],  1) == [0,2,3]);    
assert(remove([0,1,2,3],  2) == [0,1,3]);    
assert(remove([0,1,2,3],  3) == [0,1,2]);   
echo(remove([0,1,2,3],  4)); 
assert(remove([0,1,2,3],  4) == [0,1,2,3]);   
assert(remove([0,1,2,3],  5) == [0,1,2,3]);       
function subrange(list, start_i, end_i) = end_i < start_i ? [] : [ for(i = [start_i : end_i]) list[i] ];
 