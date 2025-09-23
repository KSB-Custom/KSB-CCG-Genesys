--Prank-Kids Meow-Meow-Muw
--GENESYS FORMAT
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure: 1 Level 4 or lower "Prank-Kids" monster
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(nil),1,99,s.exmatfilter)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_PRANK_KIDS))
	e1:SetValue(300)
	c:RegisterEffect(e1)
	--Add 2 "Prank-Kids" cards from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E|TIMING_MAIN_END)
	e2:SetCondition(s.thcon)
	e2:SetCost(aux.CostWithReplace(Cost.SelfTribute,CARD_PRANKKIDS_MEOWMU))
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_PRANK_KIDS}
s.listed_names={id}
function s.exmatfilter(c,scard,sumtype,tp)
	return c:IsSetCard(SET_PRANK_KIDS,lc,sumtype,tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsTurnPlayer(tp)
end
function s.thfilter(c,e)
	return c:IsSetCard(SET_PRANK_KIDS) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function s.thcheck(sg,e,tp)
	return sg:GetClassCount(Card.GetCode)==2
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return aux.SelectUnselectGroup(g,e,tp,2,2,s.thcheck,0) end
	local tg=aux.SelectUnselectGroup(g,e,tp,2,2,s.thcheck,1,tp,HINTMSG_ATOHAND)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,#tg,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
	--"Prank-Kids" monsters cannot be destroyed by opponent's card effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE|PHASE_END)
	e1:SetTarget(s.indtg)
	e1:SetValue(aux.indoval)
	Duel.RegisterEffect(e1,tp)
end
function s.indtg(e,c)
	return c:IsSetCard(SET_PRANK_KIDS)
end