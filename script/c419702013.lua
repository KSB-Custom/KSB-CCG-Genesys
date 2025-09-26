--Majespecter Gust
--GENESYS FORMAT
local s,id=GetID()
function s.initial_effect(c)
	--Fusion 1 "Cubic" fusion monster
	--Use monsters from hand or field as fusion materials
	c:RegisterEffect(Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,SET_MAJESPECTER)))
end
s.listed_series={SET_MAJESPECTER}
