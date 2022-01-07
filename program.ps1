$dados = Get-content dado.txt #variavel recebe todo o conteudo do arquivo de texto
Write-Output "Eu vou descobrir em qual animal voc� est� pensando.`n`n`n" #frase de efeito
[string]$x="" #teste
[int]$global:indice=0 #indice da linha no arquivo texto
[int]$global:ultima=0 #indice da ultima linha
$global:numeropadronizado=""
[string]$global:simounao=""
[int]$global:linhaDaPergunta=99999
$global:linhareconstruida=""



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
    else{#caso o aplicativo tenha errado a resposta final dada ao usuário
        $nomeAnimal= Read-Host "Digite o nome do animal que voce estava pensando"

        #por enquanto, o app considera que essa pergunta tem resposta "sim" para o animal que acabou de ser citado e resposta "não" para o animal que o usuário digitou
        $pergunta= Read-Host "Digite uma pergunta-de-sim-ou-nao que diferencie esse animal do animal citado anteriormente"

        achaUltima
        [string]$valor=""#comporta os números padronizados do índice da última linha do texto
        $valor=$dados[$global:ultima][0] + $dados[$global:ultima][1] + $dados[$global:ultima][2]
        
        [int]$proximaresposta=$global:ultima + 3
        [int]$proximapergunta=$global:ultima + 2

        padroniza $proximapergunta
        reconstruir $global:numeropadronizado


        #esta parte do código se faz desnecessária ao se fazer possível retorno de funções
        [string]$p="" #variável temporária
        [int]$n=$proximaresposta #variável temporária #talvez $n seja desnecessária
        $p=([string]$n).PadLeft(3,'0') #padroniza o int em uma string de 3 caracteres



        $dados = $dados + "$global:numeropadronizado|$pergunta|$temp|$p|" #nova pergunta inserida
        $dados = $dados + "$p|$nomeAnimal|*|*|" #novo animal inserido

        
        $dados[$global:linhaDaPergunta]=$global:linhareconstruida
        Clear-Content -Path dado.txt #limpa o arquivo texto
        Add-Content -Value $dados -Path dado.txt
        
    }
}
function reconstruir ([string]$s){#reconstroi a linha da última pergunta para mudar os índices 
#Esta função pode ser eliminada quando eu encontrar um jeito de mudar caracteres individuais de uma string

    $temp=$dados[$global:linhaDaPergunta]
    $t=""
    $cont=0
    while ($cont -ne $temp.Length-9) {#adiciona caracter por caracter dentro da variavel t
        $t+=$temp[$cont]
        $cont++
    }

    $camposim=$temp[$temp.Length-8]
    $camposim+=$temp[$temp.Length-7]
    $camposim+=$temp[$temp.Length-6]

    $camponao=$temp[$temp.Length-4]
    $camponao+=$temp[$temp.Length-3]
    $camponao+=$temp[$temp.Length-2]

    
    
    if($global:simounao -eq "s"){
        $camposim=$s
    }
    else {
        $camponao=$s
    }
    
    




    
    $global:linhareconstruida="$t|$camposim|$camponao|"
    

}

function padroniza ([int]$numero){#recebe um inteiro e o padroniza em string com zeros à esquerda #eliminar essa função depois
    $global:numeropadronizado=([string]$numero).PadLeft(3,'0')
}
        



foreach ($linha in $dados){#Percorre o texto linha a linha e acha a primeira pergunta

    if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em quest�o for uma pergunta
    break }       
}

[int]$asi=0
$asi=$dados.Lenght
Write-Output "imprimindo lenght $asi"



    
    [string]$temp=""
    $interruptor=0
    while ($interruptor -eq 0){

        #cls
        if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em quest�o for uma pergunta


            achaLinha $linha
            $global:linhaDaPergunta=$global:indice #salva o índice da pergunta onde o programa está
            #serve para modificar a pergunta posteriormente
        
            exibePergunta
            $global:simounao= Read-Host "Digite `"S`" para SIM, `"N`" para N�O ou digite `"F`" para finalizar"
            switch ($global:simounao){
            "s"{ #Caso o usu�rio responda sim para a pergunta

                $temp=$linha[$linha.Length-8] #adiciona o campo que cont�m o n�mero da linha na vari�vel temp
                $temp+=$linha[$linha.Length-7]
                $temp+=$linha[$linha.Length-6]
                achaLinha $temp
                $linha=$dados[$global:indice]
                
            }

            "n" { #Caso o usu�rio responda n�o para a pergunta

                $temp=$linha[$linha.Length-4] #adiciona o campo que cont�m o n�mero da linha na vari�vel temp
                $temp+=$linha[$linha.Length-3]
                $temp+=$linha[$linha.Length-2]
                achaLinha $temp

                $linha=$dados[$global:indice]
                
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

    
    
    



