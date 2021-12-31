$dados = Get-content dado.txt #variavel recebe todo o conteudo do arquivo de texto
Write-Output "Eu vou descobrir em qual animal voc� est� pensando.`n`n`n" #frase de efeito
[string]$x="" #teste
[int]$indice=0 #indice da linha no arquivo texto

function exibePergunta{#exibe o segundo campo da linha, sendo pergunta ou resposta

    $pergunta = $linha[4]#recebe a primeira letra do texto da pergunta
    $cont = 5
    while ($linha[$cont] -ne "|") {#adiciona caracter por caracter dentro da vari�vel pergunta
        $pergunta += $linha[$cont]
        $cont++
    }

    Write-Output "$pergunta" #Sa�da para o usu�rio  

}

function achaLinha([string]$s){#acha o �ndice no arquivo texto que cont�m o texto em quest�o
    [int]$cont=0
    foreach ($linhaa in $dados){
        if($linhaa[0] -eq $s[0] -and $linhaa[1] -eq $s[1] -and $linhaa[2] -eq $s[2]) {
            $global:indice=$cont #vari�vel global recebe o �ndice
            break
        }
        $cont++
        
    }
}

function resposta {
    Write-Output "O animal que voc� escolheu �:"
    exibePergunta
    Write-Output "Acertei?"
    $x= Read-Host "Digite `"S`" para SIM, `"N`" para N�O"
    if($x -eq "s" -or $x -eq "S"){
        Write-Output "Obrigado por jogar!"
        exit #ver isso aqui, talvez cause o fechamento da janela
    }
    else{
        $x= Read-Host "Digite o nome do animal que voc� estava pensando"
        #em desenvolvimento


    }

}

#testando

#ramo um
#ramo um de novo


foreach ($linha in $dados){#Percorre o texto linha a linha e acha a primeira pergunta

    Write-Output "exibindo a linha $linha"
    $x= Read-Host "pausa"


    if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em quest�o for uma pergunta
    break }       
}
    
    [string]$temp=""
    $interruptor=0
    while ($interruptor -eq 0){

    #cls
    if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em quest�o for uma pergunta
     
        exibePergunta
        $x= Read-Host "Digite `"S`" para SIM, `"N`" para N�O ou digite `"F`" para finalizar"
        switch ($x){
        "s"{ #Caso o usu�rio responda sim para a pergunta

            $temp=$linha[$linha.Length-8] #adiciona o campo que cont�m o n�mero da linha na vari�vel temp
            $temp+=$linha[$linha.Length-7]
            $temp+=$linha[$linha.Length-6]
            achaLinha $temp
            $linha=$dados[$indice]
        }

        "n" { #Caso o usu�rio responda n�o para a pergunta

            $temp=$linha[$linha.Length-4] #adiciona o campo que cont�m o n�mero da linha na vari�vel temp
            $temp+=$linha[$linha.Length-3]
            $temp+=$linha[$linha.Length-2]
            achaLinha $temp
            $linha=$dados[$indice]
        }
        
        "f" {exit}

        default {"Entrada inv�lida"}

        }

        
       

    }


    else{ #Se a linha em quest�o for uma resposta
        
        resposta
        $interruptor=1 #quebra o while acima
    }
    

    

    }

    
    
    



