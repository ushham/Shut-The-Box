module play_game
   implicit none
contains
   function roll_dice()
      integer          :: roll_dice
      real             :: dice_1
      real             :: dice_2

      call random_number(dice_1)
      call random_number(dice_2)
      roll_dice = floor(dice_1 * 6) + 1 + floor(dice_2 * 6) + 1

   end function roll_dice

   function possible_drop(arr, n, drops, m, len) result(in_arr)
      integer, intent(in)  :: n, len
      integer, dimension(n),intent(in) :: arr
      integer, intent(in)  :: m
      integer, dimension(m),intent(in) :: drops
      logical :: in_arr

      integer              :: i,j,k
      k = 0
      do i = 1,n
         do j = 1,len
            if (arr(i) == drops(j)) then
               k = k + 1
            end if
         end do
      end do
      in_arr = (k == len)
   end function possible_drop

   function drop_tiles(arr, n, drops, m, len) result(arr_out)
      integer, intent(in)  :: n, len
      integer, dimension(n),intent(in) :: arr
      integer, intent(in)  :: m
      integer, dimension(m), intent(in) :: drops
      integer, dimension(n) :: arr_out
      logical              :: in_it
      integer              :: i,j

      do i = 1,n
         in_it = .false.
         do j = 1,len
            if (arr(i) == drops(j)) then
               in_it = .true.
            end if
         end do
         arr_out(i) = arr(i)
         if (in_it) then
            arr_out(i) = 0
         end if
      end do

   end function drop_tiles

   recursive subroutine combo_gen(numbers, n, target, rows, cols, partial, m, partial_sum, res, res_idx)
      implicit none
      integer, intent(in)  :: n, m
      integer, intent(inout) :: res_idx, rows, cols
      integer, intent(inout)  :: target, partial_sum
      integer, dimension(n), intent(in)   :: numbers
      integer, dimension(m), intent(in)   :: partial
      integer, dimension(rows, cols), intent(out) :: res
      integer, dimension(m+1)             :: partial_new
      integer, dimension(15)   :: remaining
      integer                  :: i

      if (partial_sum == target) then
         !res = [res, [partial]]
         res(res_idx, 1:(size(partial)+1)) = [size(partial), partial]
         return
      end if
      
      if (partial_sum > target) then
         return
      end if
            
      do i = 1, n
         remaining(1:(n - i)) = numbers(1:(n - i))
         partial_new = [partial, numbers(n - i + 1)]
         partial_sum = sum(partial_new)
         if (partial_sum == target) then
            res_idx = res_idx + 1
         end if
         call combo_gen(remaining(1:n - i), (n - i), target, rows, cols, partial_new, m + 1, partial_sum, res, res_idx)
      end do
   end subroutine combo_gen

   function play(arr, max_tile, combos, i, j, k) result(round_score)
      integer, intent(inout) :: max_tile
      integer, intent(in)    :: i, j, k
      integer, intent(in), dimension(max_tile) :: arr
      integer, intent(in), dimension(i, j, k) :: combos
      integer, dimension(max_tile + 1) :: round_score
      
      integer, dimension(max_tile) :: arr_copy
      integer, dimension(k) :: drops
      logical :: game_going, combo_looking, poss_drop
      integer :: idx, dice, n, len, final_score

      game_going = .true.

      arr_copy = arr
      idx = 1
      round_score(idx) = sum(arr_copy)
      do while(sum(arr_copy) > 0 .and. game_going)
         dice = roll_dice()

         combo_looking = .false.
         n = 1
         
         do while ((.not. combo_looking) .and. combos(dice, min(n, j), 1) > 0 .and. n <= j) 
            len = combos(dice, n, 1)
            drops(1:len) = combos(dice, n, 2:len+1)

            poss_drop = possible_drop(arr_copy, max_tile, drops, k, len)
            !print*, n, poss_drop, arr_copy, drops(1:len)
            if (poss_drop) then
               idx = idx + 1
               
               arr_copy = drop_tiles(arr_copy, max_tile, drops, k, len)
         
               round_score(idx) = sum(arr_copy)
               combo_looking = .true.
            end if
            n = n + 1
         end do
         game_going = combo_looking
      end do

      final_score = round_score(idx)
      idx = idx + 1

      do n = idx, max_tile + 1
         round_score(n) = final_score
      end do
   end function play

end module play_game

program game_play
   use play_game
   real :: start, finish

   integer, parameter   :: tile_num = 9
   integer, parameter   :: rows = 12
   integer, parameter   :: cols = 5

   integer, parameter   :: games = 10000000
   
   integer, dimension(tile_num) :: arr

   integer, dimension(12, rows, cols)        :: combos_out
   integer                                   :: partial_sum, res_len, targ
   integer, dimension(rows, cols)            :: res

   integer                                   :: i, j, k, r, c, n

   integer, dimension(10):: score
   real :: perc_win

   call cpu_time(start)

   perc_win = 0

   arr = [1,2,3,4,5,6,7,8,9]

   !Make combinations
   do i = 1, 12
      partial_sum = 0
      res_len = 0
      targ = i
      r = rows
      c = cols
      call combo_gen(arr, tile_num, targ, r, c, [integer::], 0, partial_sum, res, res_len)

      do j = 1, rows
         do k = 1, (res(j, 1)+1)
            combos_out(i, j, k) = res(j, k)
         end do
      end do
   end do

   !Play game
   do n = 1, games
      i = tile_num
      score = play(arr, i, combos_out, 12, rows, cols)
      
      if (score(10) == 0) then
         !print*, score
         perc_win = perc_win + 1
      end if
   end do

   perc_win = perc_win / games * 100
   print *, perc_win

   call cpu_time(finish)
   print '("Time = ",f6.3," seconds.")',finish-start
end program game_play
