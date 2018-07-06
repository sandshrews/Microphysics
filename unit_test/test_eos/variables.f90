!
! A module to provide integer indices into the various storage arrays
! for accessing the different variables by name.
!
module variables

  use amrex_fort_module, only : rt => amrex_real

  use network, only: nspec, spec_names

  implicit none

  integer, parameter :: MAX_NAME_LEN=20

  type plot_t
     integer :: irho = -1
     integer :: itemp = -1
     integer :: ih = -1
     integer :: ie = -1
     integer :: ip = -1
     integer :: is = -1
     integer :: ispec = -1

     integer :: ierr_T_eos_rh = -1
     integer :: ierr_rho_eos_tp = -1
     integer :: ierr_T_eos_rp = -1
     integer :: ierr_T_eos_re = -1
     integer :: ierr_rho_eos_ps = -1
     integer :: ierr_T_eos_ps = -1
     integer :: ierr_rho_eos_ph = -1
     integer :: ierr_T_eos_ph = -1
     integer :: ierr_rho_eos_th = -1

     integer :: n_plot_comps = 0

     character(len=MAX_NAME_LEN), allocatable :: names(:)

   contains
     procedure :: next_index => get_next_plot_index

  end type plot_t

  type(plot_t) :: p

contains

  function get_next_plot_index(this, num) result (next)

    ! return the next starting index for a plotfile quantity, and
    ! increment the counter of plotfile quantities, n_plot_comps, by
    ! num

    class(plot_t), intent(inout) :: this
    integer, intent(in) :: num
    integer :: next

    next = this%n_plot_comps + 1
    this%n_plot_comps = this%n_plot_comps + num

    return
  end function get_next_plot_index

  subroutine init_variables() bind(C, name="init_variables")

    integer :: n

    ! variable information
    p % irho      = p % next_index(1)
    p % itemp     = p % next_index(1)
    p % ih        = p % next_index(1)
    p % ie        = p % next_index(1)
    p % ip        = p % next_index(1)
    p % is        = p % next_index(1)
    p % ispec     = p % next_index(nspec)

    p % ierr_T_eos_rh   = p % next_index(1)
    p % ierr_rho_eos_tp = p % next_index(1)
    p % ierr_T_eos_rp = p % next_index(1)
    p % ierr_T_eos_re = p % next_index(1)
    p % ierr_rho_eos_ps = p % next_index(1)
    p % ierr_T_eos_ps = p % next_index(1)
    p % ierr_rho_eos_ph = p % next_index(1)
    p % ierr_T_eos_ph = p % next_index(1)
    p % ierr_rho_eos_th = p % next_index(1)

    allocate(p%names(p%n_plot_comps))

    p % names(p % irho) = "density"
    p % names(p % itemp) = "temperature"
    p % names(p % ih) = "specific_enthalpy"
    p % names(p % ie) = "specific_energy"
    p % names(p % ip) = "pressure"
    p % names(p % is) = "specific_entropy"
    do n = 0, nspec-1
       p % names(p % ispec + n) = "X_" // adjustl(trim(spec_names(n+1)))
    enddo

    p % names(p % ierr_T_eos_rh)   = "err_T_eos_rh"
    p % names(p % ierr_rho_eos_tp) = "err_rho_eos_tp"
    p % names(p % ierr_T_eos_rp)   = "err_T_eos_rp"
    p % names(p % ierr_T_eos_re)   = "err_T_eos_re"
    p % names(p % ierr_rho_eos_ps) = "err_rho_eos_ps"
    p % names(p % ierr_T_eos_ps)   = "err_T_eos_ps"
    p % names(p % ierr_rho_eos_ph) = "err_rho_eos_ph"
    p % names(p % ierr_T_eos_ph)   = "err_T_eos_ph"
    p % names(p % ierr_rho_eos_th) = "err_rho_eos_th"

  end subroutine init_variables

  subroutine get_ncomp(ncomp_in) bind(C, name="get_ncomp")

    integer, intent(inout) :: ncomp_in

    ncomp_in = p % n_plot_comps

  end subroutine get_ncomp

  subroutine get_name_len(nlen_in) bind(C, name="get_name_len")

    integer, intent(inout) :: nlen_in

    nlen_in = MAX_NAME_LEN

  end subroutine get_name_len

  subroutine get_var_name(cstring, idx) bind(C, name="get_var_name")

    use iso_c_binding

    implicit none
    type(c_ptr), intent(inout) :: cstring
    integer, intent(in) :: idx

    ! include space for the NULL termination
    character(MAX_NAME_LEN+1), pointer :: fstring
    integer :: len

    allocate(fstring)

    ! C++ is 0-based, so add 1 to the idx
    fstring = p % names(idx+1)
    len = len_trim(fstring)
    fstring(len+1:len+1) = c_null_char

    cstring = c_loc(fstring)

  end subroutine get_var_name

end module variables
