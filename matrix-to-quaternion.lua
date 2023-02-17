--[[
		Rotation Matrix (provided as CFrame) to unit quaternion
		by Sheppard's voting scheme method
]]--
function Utils.MatrixToQuaternionSheppard( cf )
	local tx, ty, tz, xx, xy, xz, yx, yy, yz, zx, zy, zz = cf:components()
	local tr = xx + yy + zz
	local qx,qy,qz,qw = 0,0,0,1
	local qv = nil
	if tr > 0 then
		local k = 0.5 / math.sqrt(1+tr)
		qx = k * (zy-yz)
		qy = k * (xz-zx)
		qz = k * (yx-xy)
		qw = 0.25 / k
	elseif (xx > yy) and (xx > zz) then
		local k = 0.5 / math.sqrt(1+xx-yy-zz)
		qx = 0.25/k
		qy = k * (xy+yx)
		qz = k * (xz+zx)
		qw = k * (zy-yz)
	elseif (yy > zz) then
		local k = 0.5 / math.sqrt(1+yy-xx-zz)
		qx = k * (xy+yx)
		qy = 0.25 / k
		qz = k * (zy+yz)
		qw = k * (xz-zx)
	else
		local k = 0.5 / math.sqrt(1+zz-xx-yy)
		qx = k * (xz+zx)
		qy = k * (yz+zy)
		qz = 0.25 / k
		qw = k * (yx-xy)
	end
	return {w=qw,x=qx,y=qy,z=qz}
end

--[[
		Rotation Matrix (provided as CFrame) to unit quaternion
		by Sarabandi's method
		
		Slower but more numerically accurate than Shepard's method
]]--
function Utils.MatrixToQuaternionSarabandi( cf )
	local _,_,_,xx,xy,xz,yx,yy,yz,zx,zy,zz = cf:GetComponents()
	local A = (zy-yz)*(zy-yz)
	local B = (xz-zx)*(xz-zx)
	local C = (yx-xy)*(yx-xy)
	local D = (zy+yz)*(zy+yz)
	local E = (zx+xz)*(zx+xz)
	local F = (yx+xy)*(yx+xy)
	local G = (1+xx+yy+zz)*(1+xx+yy+zz) 
	local H = (1+xx-yy-zz)*(1+xx-yy-zz)
	local I = (1+yy-xx-zz)*(1+yy-xx-zz)
	local J = (1+zz-xx-yy)*(1+zz-xx-yy)
	local qw = 0.25 * math.sqrt(A+B+C+G)
	local qx = 0.25 * math.sqrt(A+E+F+H) * (if zy-yz>0 then 1 else -1)
	local qy = 0.25 * math.sqrt(B+D+F+I) * (if xz-zx>0 then 1 else -1)
	local qz = 0.25 * math.sqrt(C+D+E+J) * (if yx-xy>0 then 1 else -1)
	return {w=qw,x=qx,y=qy,z=qz}
end
