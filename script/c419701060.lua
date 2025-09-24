--Prank-Kids Meow-Meow-Muw
--GENESYS FORMAT
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Link Summon procedure: 1 Level 4 or lower "Prank-Kids" monster
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,1,s.exmatfilter)
	--You can only Link Summon "Prank-Kids Meow-Meow-Mu" once per turn
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(function(e) return e:GetHandler():IsSynchroSummoned() end)
	e0:SetOperation(s.regop)
	c:RegisterEffect(e0)
	--If a "Prank-Kids" monster you control would Tribute itself to activate its effect during your opponent's turn, you can banish this card you control or from your GY instead
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(CARD_PRANKKIDS_MEOWMU)
	e1:SetRange(LOCATION_MZONE|LOCATION_GRAVE)
	e1:SetTargetRange(1,0)
	e1:SetCountLimit(1,id)
	e1:SetCondition(function(e) return e:GetHandler():IsAbleToRemoveAsCost() end)
	e1:SetValue(s.repval)
	e1:SetOperation(s.repop)
	c:RegisterEffect(e1)
	--Increase or Decrease its Level by 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.lvtg)
	e2:SetOperation(s.lvop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_PRANK_KIDS}
s.listed_names={id}
function s.exmatfilter(c,scard,sumtype,tp)
	return c:IsSetCard(SET_PRANK_KIDS,lc,sumtype,tp)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	--You cannot Link Summon "Prank-Kids Meow-Meow-Mu" for the rest of this turn
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(function(e,c,sump,sumtype,sumpos,targetp,se) return c:IsCode(id) and sumtype&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK end)
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.repval(base,e,tp,eg,ep,ev,re,r,rp,chk,extracon)
	local c=e:GetHandler()
	return Duel.IsTurnPlayer(1-tp) and c:IsSetCard(SET_PRANK_KIDS) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
		and (extracon==nil or extracon(base,e,tp,eg,ep,ev,re,r,rp))
end
function s.repop(base,e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Remove(base:GetHandler(),POS_FACEUP,REASON_COST|REASON_REPLACE)
end
--
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:HasLevel() end
	Duel.SetOperationInfo(0,CATEGORY_LVCHANGE,c,1,tp,1)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsFaceup() and c:IsRelateToEffect(e) and c:HasLevel()) then return end
	local b1=true
	local b2=c:IsLevelAbove(2)
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,2)}, --Increase its Level by 1
		{b2,aux.Stringid(id,3)}) --Decrease its Level by 1
	local value=(op==1 and op) or -1
	---Increase or decrease its Level by 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(value)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
end