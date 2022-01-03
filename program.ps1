$dados = Get-content dado.txt #variavel recebe todo o conteudo do arquivo de texto
Write-Output "Eu vou descobrir em qual animal voc� est� pensando.`n`n`n" #frase de efeito
[string]$x="" #teste
[int]$global:indice=0 #indice da linha no arquivo texto
[int]$global:ultima=0 #indice da ultima linha

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

function achaUltima{ #acha o indice da ultima linha ignorando linhas em branco
    $i=0
    foreach ($candidato in $dados){
        if ($candidato.Length -gt 2){ #2? verificar
            $global:ultima=$i
        }
        $i++
    }
}

function resposta {
    Write-Output "O animal que voc� escolheu �:"
    exibePergunta
    Write-Output "Acertei?"
    $x= Read-Host "Digite `"S`" para SIM, `"N`" para N�O"
    if($x -eq "s" -or $x -eq "S"){
        Write-Output "Obrigado por jogar!"
        pause
        exit
    }
    else{
        $x= Read-Host "Digite o nome do animal que voce estava pensando"
        $pergunta= Read-Host "Digite uma pergunta-de-sim-ou-nao que diferencie esse animal do animal citado anteriormente"
        #em desenvolvimento
        achaUltima
        [string]$valor=""
        $valor=$dados[$global:ultima][0] + $dados[$global:ultima][1] + $dados[$global:ultima][2]
        write-output "imprimindo valor $valor" #apagar
        $dados = $dados + "999|$x|*|*|" #fazer uma função pra definir um índice
        $dados = $dados + "999|$pergunta|997|998|" #fazer o código para redefinir os "ponteiros"
        Clear-Content -Path 1.txt #limpa o arquivo texto
        Add-Content -Value $dados -Path 1.txt
        
    }
}



foreach ($linha in $dados){#Percorre o texto linha a linha e acha a primeira pergunta

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

    
    
    



