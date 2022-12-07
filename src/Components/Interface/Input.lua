local Input = {}
local UserInputService = game:GetService("UserInputService")

function Input.GetMoveInput(): Vector2
	local xDirection = -(UserInputService:IsKeyDown(Enum.KeyCode.A) and 1 or 0) + (UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0);
	local yDirection = -(UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0) + (UserInputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0);


	return Vector2.new(xDirection,yDirection);
end


return Input