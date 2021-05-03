module play_game
   implicit none
contains
   function roll_dice(arr, n) result(dice)
      integer, intent(in)  :: n
      integer, dimension(n),intent(in) :: arr
      integer          :: dice
      real             :: dice_1
      real             :: dice_2
      integer          :: arr_val
      arr_val = sum(arr)

      call random_number(dice_1)
      if (arr_val > 6) then
         call random_number(dice_2)
         dice = floor(dice_1 * 6) + 1 + floor(dice_2 * 6) + 1
      else
         dice = floor(dice_1 * 6) + 1
      end if

   end function roll_dice

   function possible_drop(arr, n, drops, m) result(in_arr)
      integer, intent(in)  :: n
      integer, dimension(n),intent(in) :: arr
      integer, intent(in)  :: m
      integer, dimension(m),intent(in) :: drops
      logical :: in_arr

      integer              :: i,j,k

      do i = 1,n
         do j = 1,m
            if (arr(i) == drops(j)) then
               k = k + 1
            end if
         end do
      end do
      in_arr = (k == m)
   end function possible_drop

   function drop_tiles(arr, n, drops, m) result(arr_out)
      integer, intent(in)  :: n
      integer, dimension(n),intent(in) :: arr
      integer, intent(in)  :: m
      integer, dimension(m),intent(in) :: drops
      integer, dimension(n) :: arr_out
      logical              :: in_it
      integer              :: i,j

      do i = 1,n
         in_it = .false.
         do j = 1,m
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

   recursive subroutine combo_gen(numbers, n, target, partial, m, partial_sum, res, res_idx)
      implicit none
      integer, intent(in)  :: n, m
      integer, intent(inout) :: res_idx
      integer, intent(inout)  :: target, partial_sum
      integer, dimension(n), intent(in)   :: numbers
      integer, dimension(m), intent(in)   :: partial
      integer, dimension(10, 5), intent(out) :: res
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
         remaining(1:(n - i - 1)) = numbers(1:(n - i - 1))
         partial_new = [partial, numbers(n - i)]
         partial_sum = sum(partial_new)
         !print *, numbers(n - i), remaining(1:(n - i - 1))
         if (partial_sum == target) then
            res_idx = res_idx + 1
         end if
         call combo_gen(remaining(1:n - i - 1), (n - i - 1), target, partial_new, m + 1, partial_sum, res, res_idx)
      end do
   end subroutine combo_gen
end module play_game

program game_play
   use play_game
   integer, parameter   :: tile_num = 9
   integer, dimension(tile_num) :: arr

   integer              :: targ, partial_sum, res_len, i

   integer, dimension(10, 5) :: res

   arr = [1,2,3,4,5,6,7,8,9]
   targ = 8
   partial_sum = 0
   res_len = 0
   call combo_gen(arr, 9, targ, [integer::], 0, partial_sum, res, res_len)

   do i = 1, 5
      print *, res(i, 2:res(i, 1)+1)
   end do

end program game_play
