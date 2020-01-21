local policeClothings = {
    cloth0 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Hat_LPR",
    cloth1 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Police_Shirt-Long_LPR",
    cloth2 = nil,
    cloth3 = nil,
    cloth4 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_FormalPants_LPR",
    cloth5 = "/Game/CharacterModels/SkeletalMesh/Outfits/HZN_Outfit_Piece_BusinessShoes_LPR"
}

function ApplyPoliceClothings(player)
    local SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Body")
    SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset("/Game/CharacterModels/SkeletalMesh/BodyMerged/HZN_CH3D_Normal04_LPR"))
    SkeletalMeshComponent:SetMaterial(0, UMaterialInterface.LoadFromAsset("/Game/CharacterModels/Materials/HZN_Materials/M_HZN_Body_NoShoesLegsTorso"))
    
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing0")
    if policeClothings.cloth0 ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(policeClothings.cloth0)) 
    else
        SkeletalMeshComponent:SetSkeletalMesh(nil)
    end
    
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing1")
    if policeClothings.cloth1 ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(policeClothings.cloth1)) 
    else
        SkeletalMeshComponent:SetSkeletalMesh(nil)
    end
    
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing4")
    if policeClothings.cloth4 ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(policeClothings.cloth4)) 
    else
        SkeletalMeshComponent:SetSkeletalMesh(nil)
    end
    
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing5")
    if policeClothings.cloth5 ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(policeClothings.cloth5)) 
    else
        SkeletalMeshComponent:SetSkeletalMesh(nil)
    end
    
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing3")
    if policeClothings.cloth3 ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(policeClothings.cloth3)) 
    else
        SkeletalMeshComponent:SetSkeletalMesh(nil)
    end
    
    SkeletalMeshComponent = GetPlayerSkeletalMeshComponent(player, "Clothing2")
    if policeClothings.cloth2 ~= nil then
        SkeletalMeshComponent:SetSkeletalMesh(USkeletalMesh.LoadFromAsset(policeClothings.cloth2)) 
    else
        SkeletalMeshComponent:SetSkeletalMesh(nil)
    end
    
    AddPlayerChat("police cloth applyed for " .. player)

end

AddRemoteEvent("police:applycloths", ApplyPoliceClothings)
