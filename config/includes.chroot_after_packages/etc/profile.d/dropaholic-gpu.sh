# RF411: Intel HD 3000 e a regra por padrao (economiza bateria).
# Para rodar um jogo na GT 540M (nouveau):  dgpu <comando>
dgpu() { DRI_PRIME=1 "$@"; }
