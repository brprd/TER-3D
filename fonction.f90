Module fonction
  Implicit none
  !Fonction TER
  !On choisit LC tibia comme origine du repère


  Integer,parameter :: Pr=8
  Real(Pr),parameter :: Pi=4._8*atan(1._Pr)
  Type quaternion
     Real(Pr) :: a,b,c,d

  end type quaternion

  Real(Pr),dimension(3) :: u,v,w
  Real(Pr),dimension(5) :: l
  Type(quaternion) :: LCT,MCT,ACLT,PCLT,MCLT,LCF,MCF,ACLF,PCLF,MCLF,test

!!$
!!$  !Initialisation des points du tibia
!!$  LCT%a=0._Pr
!!$  LCT%b=0._Pr
!!$  LCT%c=0._Pr
!!$  LCT%d=0._Pr
!!$
!!$  MCT%a=0._Pr
!!$  MCT%b=Real(-15.95-10.58,Pr)
!!$  MCT%c=Real(53.53+51.69,Pr)
!!$  MCT%d=Real(-20.37-19.26,Pr)
!!$
!!$  ACLT%a=0._Pr
!!$  ACLT%b=Real(14.03-10.58,Pr)
!!$  ACLT%c=Real(-1.21+51.69,Pr)
!!$  ACLT%d=Real(-3.72-19.26,Pr)
!!$
!!$  PCLT%a=0._Pr
!!$  PCLT%b=Real(-17.24-10.58,Pr)
!!$  PCLT%c=Real(-12.15+51.69,Pr)
!!$  PCLT%d=Real(15.60-19.26,Pr)
!!$
!!$  MCLT%a=0._Pr
!!$  MCLT%b=Real(4.55-10.58,Pr)
!!$  MCLT%c=Real(-72.62+51.69,Pr)
!!$  MCLT%d=Real(-16.23-19.26,Pr)
!!$
!!$  !Initialisation du fémur pour theta=55°
!!$
!!$  LCF%a=0._Pr
!!$  LCF%b=Real(0,Pr)
!!$  LCF%c=Real(0,Pr)
!!$  LCF%d=Real(0,Pr)
!!$
!!$  MCF%a=0._Pr
!!$  MCF%b=Real(-6.45-1.75,Pr)
!!$  MCF%c=Real(-4.24+1.67,Pr)
!!$  MCF%d=Real(-22.93-30.09,Pr)
!!$
!!$  ACLF%a=0._Pr
!!$  ACLF%b=Real(-8.60-1.75,Pr)
!!$  ACLF%c=Real(-1.43+1.67,Pr)
!!$  ACLF%d=Real(7.28-30.09,Pr)
!!$
!!$  PCLF%a=0._Pr
!!$  PCLF%b=Real(-3.66-1.75,Pr)
!!$  PCLF%c=Real(-7.93+1.67,Pr)
!!$  PCLF%d=Real(-5.94-30.09,Pr)
!!$
!!$  MCLF%a=0._Pr
!!$  MCLF%b=Real(-7.25-1.75,Pr)
!!$  MCLF%c=Real(-2.90+1.67,Pr)
!!$  MCLF%d=Real(-38.05-30.09,Pr)

  

  !remplissage vecteur ligament (en mm)

  !ACL
  l(1)=33.05
  !PCL
  l(2)=41.46
  !MCL
  l(3)=100.79
  !LC
  l(4)=78.77
  !MC
  l(5)=31.11

  test%b=3
  test%c=4
  test%d=5
  u=(/1,0,0/)
  v=(/0,1,0/)
  w=(/0,0,1/)
  test=rota(Pi/4._8,test,u)
  test=rota(Pi/2._8,test,v)
  test=rota(Pi/6._8,test,w)
  Print*,test
  Contains

    function distance(x)Result(d)
      !calcul la distance d'un vecteur (on prend a=0 dans le quaternion)
      
    !déclaration variable
   Type(quaternion),Intent(in) :: x
    Real(Pr) :: d,som
    !instructions
    som=0
    som= som + x%b**2 +x%c**2 +x%d**2
    d=sqrt(som)
  end function distance





  
  function prodquat(u,v)Result(r)
    !produit scalaire de 2 quaternons

    !déclaration variable entrée/sortie
    Type(quaternion),intent(in) :: u,v
    Real(Pr) :: r

    !instructions
    r=(u%b*v%b) + (u%c*v%c) + (u%d*v%d) 
  end function prodquat




  
  function prodvecquat(u,v)Result(w)
 !produit scalaire de 2 quaternions

    !déclaration variable entrée/sortie
    Type(quaternion),intent(in) :: u,v
    Type(quaternion) :: w

    !instructions

    w%b=u%c*v%d - (u%d*v%c)
    w%c=u%d*v%b - (u%b*v%d)
    w%d=u%b*v%c - (u%c*v%b)
     
  end function prodvecquat





  
  function invquat(u)Result(v)
    !inverse quaternion

    !déclaration variable entrée/sortie
    Type(quaternion),intent(in) :: u
    Type(quaternion) :: v

    !déclaration variable
    Real(Pr) :: som
    integer :: i


    !instructions
    som= u%a**2 + (u%b**2 + u%c**2 + u%d**2)
    v%a=u%a/som
    v%b=-u%b/som
    v%c=-u%c/som
    v%d=-u%d/som
    

  end function invquat






  function prodhamilton(u,v)Result(w)
    Type(quaternion),intent(in) :: u,v
    Type(quaternion) :: w
    Type(quaternion) :: q


    !instruction
    q=prodvecquat(u,v)
    w%a= u%a*v%a -prodquat(u,v)
    w%b= u%a*v%b + v%a*u%b + q%b
    w%c= u%a*v%c + v%a*u%c + q%c
    w%d= u%a*v%d + v%a*u%d + q%d
    
  end function prodhamilton
    
    




  
  function rota(theta,v,u)Result(vp)
    !calcul de la rotation d'un vecteur autour d'un axe u d'angle theta
    
    !déclaration variable entrée/sortie
    Real(Pr),intent(in) :: theta
    Type(quaternion),intent(in) :: v
    Type(quaternion) :: vp
    Real(Pr),dimension(3),intent(in) :: u

    !déclaration variable
    Type(quaternion) :: q,qinv


    !instructions
    q%a=cos(theta/2)
    q%b=sin(theta/2)*u(1)
    q%c=sin(theta/2)*u(2)
    q%d=sin(theta/2)*u(3)

    !calcul de qvq⁻¹
    qinv=invquat(q)
    vp= prodhamilton(q,v)
    vp= prodhamilton(vp,qinv)
  end function  rota




  

  function f(theta,x,y,z,phi,psi)result(V)
    !Réalise la rotation d'un vecteur et renvoie le vecteur après rotation
    !déclaration variable
    Real(Pr),intent(in) :: x,y,z,phi,psi,theta
    Real(Pr),dimension(5) :: V
    Real(Pr),dimension(3) :: thetarot,phirot,psirot

    thetarot=((/1,0,0/))
    psirot=((/0,1,0/))
    phirot= ((/0,0,1/))


    !Translation des 5 points
    
    LCF%a=0._Pr
  LCF%b=Real(0,Pr)+x
  LCF%c=Real(0,Pr)+y
  LCF%d=Real(0,Pr)+z

  MCF%a=0._Pr
  MCF%b=Real(-6.45-1.75,Pr)+x
  MCF%c=Real(-4.24+1.67,Pr)+y
  MCF%d=Real(-22.93-30.09,Pr)+z

  ACLF%a=0._Pr
  ACLF%b=Real(-8.60-1.75,Pr)+x
  ACLF%c=Real(-1.43+1.67,Pr)+y
  ACLF%d=Real(7.28-30.09,Pr)+z

  PCLF%a=0._Pr
  PCLF%b=Real(-3.66-1.75,Pr)+x
  PCLF%c=Real(-7.93+1.67,Pr)+y
  PCLF%d=Real(-5.94-30.09,Pr)+z

  MCLF%a=0._Pr
  MCLF%b=Real(-7.25-1.75,Pr)+x
  MCLF%c=Real(-2.90+1.67,Pr)+y
  MCLF%d=Real(-38.05-30.09,Pr)+z


  !rotation des 5 points

  
  LCF= rota(theta,LCF,thetarot)
  LCF= rota(theta,LCF,psirot)
  LCF= rota(theta,LCF,phirot)

  MCF= rota(theta,MCF,thetarot)
  MCF= rota(theta,MCF,psirot)
  MCF=rota(theta,MCF,phirot)

  ACLF=rota(theta,ACLF,thetarot)
  ACLF=rota(theta,ACLF,psirot)
  ACLF=rota(theta,ACLF,phirot)

  PCLF= rota(theta,PCLF,thetarot)
  PCLF=rota(theta,PCLF,psirot)
  PCLF=rota(theta,PCLF,phirot)

  MCLF= rota(theta,MCLF,thetarot)
  MCLF=rota(theta,MCLF,psirot)
  MCLF =rota(theta,MCLF,phirot)


  !calcul des distances entre fémur et tibia - longueur du ligament associé
  
  V(1)=distance(sous(ACLF,ACLT))-l(1)
  V(2)=distance(sous(PCLF,PCLT))-l(2)
  V(3)=distance(sous(MCLF,MCLT))-l(3)
  V(4)=distance(sous(LCF,LCT))-l(4)
  V(5)=distance(sous(MCF,MCT))-l(5)
  
end function f

function sous(a,b)result(y)
  !soustraction quaternion

  Type(quaternion),intent(in) :: a,b
  Type(quaternion) :: y

  y%a=a%a-b%a
  y%b=a%b-b%b
  y%c=a%c-b%c
  y%d=a%d-b%d
end function sous
end Module fonction
