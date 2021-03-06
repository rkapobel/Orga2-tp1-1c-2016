#!/bin/bash
clear

echo " "
echo "**Compilando"

make tester
if [ $? -ne 0 ]; then
  echo "  **Error de compilacion"
  exit 1
fi

echo " "
echo "**Corriendo Valgrind"
#--undef-value-errors=no //si no lo pongo, me lo toma como error de memoria.
#--track-origins=yes
valgrind --show-reachable=yes --leak-check=full --error-exitcode=1 ./tester
if [ $? -ne 0 ]; then
  echo "  **Error de memoria"
  exit 1
fi

echo " "
echo "**Corriendo diferencias con la catedra"

DIFFER="diff -d -a --suppress-common-lines -y"
ERRORDIFF=0
#Los archivos de la catedra difieren al formato pedido para la salida de los registros clave-valor
$DIFFER salida.caso.chico.txt Catedra.salida.caso.chico.txt > /tmp/diff1
#$DIFFER salida.caso.chico.txt Catedra.salida.caso.chico.txt > diffCC.txt
if [ $? -ne 0 ]; then
  echo "  **Discrepancia en el caso CHICO: salida.caso.chico.txt vs Catedra.salida.caso.chico.txt"
  ERRORDIFF=1
fi

$DIFFER salida.caso.grande.txt Catedra.salida.caso.grande.txt > /tmp/diff2
#$DIFFER salida.caso.grande.txt Catedra.salida.caso.grande.txt > diffCG.txt
if [ $? -ne 0 ]; then
  echo "  **Discrepancia en el caso GRANDE: salida.caso.grande.txt vs Catedra.salida.caso.grande.txt"
  ERRORDIFF=1
fi

echo " "
if [ $ERRORDIFF -eq 0 ]; then
  echo "**Todos los tests pasan"
fi
echo " "
