--[[
		Rotation Matrix (provided as CFrame) to unit quaternion
		by Sheppard's voting scheme method
]]--
function Utils.MatrixToQuaternionSheppard( cf )
	local _, _, _, xx, yx, zx, xy, yy, zy, xz, yz, zz = cf:components()
	local tr = xx + yy + zz
	local qx,qy,qz,qw = 0,0,0,1
	local qv = nil
	if tr > 0 then
		local k = 0.5 / math.sqrt(1+tr)
		qx = k * (yz-zy)
		qy = k * (zx-xz)
		qz = k * (xy-yx)
		qw = 0.25 / k
	elseif (xx > yy) and (xx > zz) then
		local k = 0.5 / math.sqrt(1+xx-yy-zz)
		qx = 0.25/k
		qy = k * (yx+xy)
		qz = k * (zx+xz)
		qw = k * (yz-zy)
	elseif (yy > zz) then
		local k = 0.5 / math.sqrt(1+yy-xx-zz)
		qx = k * (yx+xy)
		qy = 0.25 / k
		qz = k * (yz+zy)
		qw = k * (zx-xz)
	else
		local k = 0.5 / math.sqrt(1+zz-xx-yy)
		qx = k * (zx+xz)
		qy = k * (zy+yz)
		qz = 0.25 / k
		qw = k * (xy-yx)
	end
	return {w=qw,x=qx,y=qy,z=qz}
end

--[[
		Rotation Matrix (provided as CFrame) to unit quaternion
		by Sarabandi's method
		
		Slower but more numerically accurate than Shepard's method
]]--
function Utils.MatrixToQuaternionSarabandi( cf )
	local _,_,_,xx,yx,zx,xy,yy,zy,xz,yz,zz = cf:GetComponents()
	local A = (yz-zy)*(yz-zy)
	local B = (zx-xz)*(zx-xz)
	local C = (xy-yx)*(xy-yx)
	local D = (yz+zy)*(yz+zy)
	local E = (xz+zx)*(xz+zx)
	local F = (xy+yx)*(xy+yx)
	local G = (1+xx+yy+zz)*(1+xx+yy+zz) 
	local H = (1+xx-yy-zz)*(1+xx-yy-zz)
	local I = (1+yy-xx-zz)*(1+yy-xx-zz)
	local J = (1+zz-xx-yy)*(1+zz-xx-yy)
	local qw = 0.25 * math.sqrt(A+B+C+G)
	local qx = 0.25 * math.sqrt(A+E+F+H) * (if yz-zy>0 then 1 else -1)
	local qy = 0.25 * math.sqrt(B+D+F+I) * (if zx-xz>0 then 1 else -1)
	local qz = 0.25 * math.sqrt(C+D+E+J) * (if xy-yx>0 then 1 else -1)
	return {w=qw,x=qx,y=qy,z=qz}
end
