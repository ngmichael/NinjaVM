pushn
pushn
refeq
drop 1

pushc 10
dup
refeq
drop 1

pushc 2
pushc 2
refeq
drop 1

pushn
pushn
refne

pushc 2
dup
refne
drop 1

pushc 10
pushc 10
refne
drop 1

halt
