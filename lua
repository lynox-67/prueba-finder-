local petFinder = false

local function findPet()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name == CONFIG.TargetPet then
            return v
        end
    end
end

task.spawn(function()
    while true do
        if petFinder then
            local pet = findPet()
            if pet then
                warn("🐾 PET ENCONTRADO:", pet.Name)
                autoJoin = false
                autoJoinBtn.Text = "AUTO JOIN: OFF"
            end
        end
        task.wait(CONFIG.CheckDelay)
    end
end)

petFinderBtn.MouseButton1Click:Connect(function()
    petFinder = not petFinder
    petFinderBtn.Text = petFinder and "PET FINDER: ON" or "PET FINDER: OFF"
end)
