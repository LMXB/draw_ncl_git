a = new( (/ 2, 2, 2 /), float)
x=0
do i=0,1,1
do j=0,1,1
do k=0,1,1
a(i,j,k)=x
x=x+1
end do
end do
end do
print(a)
;write_matrix(a, "3f6.2", False)
