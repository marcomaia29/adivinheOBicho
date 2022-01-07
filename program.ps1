$dados = Get-content dado.txt #variï¿½vel recebe todo o conteudo do arquivo de texto
Write-Output "Eu vou descobrir em qual animal vocï¿½ estï¿½ pensando.`n`n`n" #frase de efeito
[int]$global:indice=0 #Ãndice da linha no arquivo texto
[int]$ind=0 #Ãndice da linha no arquivo texto
[int]$global:ultima=0 #Ãndice da ultima linha
$global:numeropadronizado=""
[string]$global:simounao=""
[int]$global:linhaDaPergunta=99999
$global:linhareconstruida=""

function exibePergunta{#exibe o segundo campo da linha, sendo pergunta ou resposta

    $pergunta = $linha[4]#recebe a primeira letra do texto da pergunta
    $cont = 5
    while ($linha[$cont] -ne "|") {#adiciona caracter por caracter dentro da variï¿½vel pergunta
        $pergunta += $linha[$cont]
        $cont++
    }

    Write-Output "$pergunta" #Saï¿½da para o usuï¿½rio


}

function achaLinhaMM([string]$linha){#acha o ï¿½ndice no arquivo texto que contï¿½m o texto em questï¿½o
    [int]$cont=0
    foreach ($linhaPesquisada in $dados){
        if($linhaPesquisada[0] -eq $linha[0] -and 
           $linhaPesquisada[1] -eq $linha[1] -and 
           $linhaPesquisada[2] -eq $linha[2]) 
        {
            #$global:indice=$cont #variÃ¡vel global recebe o Ã­ndice
            #achaLinhaMM = $cont
            achaLinhaMM = $cont
            #break
        }
        $cont++
        
    }
}

function achaLinha([string]$s){#acha o ï¿½ndice no arquivo texto que contï¿½m o texto em questï¿½o
    [int]$cont=0
    foreach ($linhaa in $dados){
        if($linhaa[0] -eq $s[0] -and $linhaa[1] -eq $s[1] -and $linhaa[2] -eq $s[2]) {
            $global:indice=$cont #variï¿½vel global recebe o ï¿½ndice
            break
        }
        $cont++
        
    }
}

function achaUltima{ #acha o ï¿½ndice da ï¿½ltima linha ignorando linhas em branco
    $i=0
    foreach ($candidato in $dados){
        if ($candidato.Length -gt 2){ #2? verificar
            $global:ultima=$i
        }
        $i++
    }
}


function resposta {
    Write-Output "O animal que você escolheu é:"
    exibePergunta
    Write-Output "Acertei?"
    $x= Read-Host "Digite `"S`" para SIM, `"N`" para NÃO"
    if($x -eq "s" -or $x -eq "S"){
        Write-Output "Obrigado por jogar!"
        pause
        exit
    }
    else{#caso o aplicativo tenha errado a resposta final dada ao usuï¿½rio
        $nomeAnimal= Read-Host "Digite o nome do animal que você estava pensando"

        #por enquanto, o app considera que essa pergunta tem resposta "sim" para o animal que acabou de ser citado e resposta "nï¿½o" para o animal que o usuï¿½rio digitou
        $pergunta= Read-Host "Digite uma pergunta-de-sim-ou-não que diferencie esse animal do animal citado anteriormente"

        $simnaopergunta= Read-Host "Para o animal que você acabou de digitar, a resposta dessa pergunta é sim ou não? `n Digite `"S`" para SIM, `"N`" para NÃO"
        
        achaUltima
        [string]$valor=""#comporta os nï¿½meros padronizados do ï¿½ndice da ï¿½ltima linha do texto
        $valor=$dados[$global:ultima][0] + $dados[$global:ultima][1] + $dados[$global:ultima][2]
        
        [int]$proximaresposta=$global:ultima + 3
        [int]$proximapergunta=$global:ultima + 2

        padroniza $proximapergunta
        reconstruir $global:numeropadronizado


        #esta parte do cï¿½digo se faz desnecessï¿½ria ao se fazer possï¿½ï¿½vel retorno de funï¿½ï¿½es
        [string]$p="" #variï¿½vel temporï¿½ria
        [int]$n=$proximaresposta #variï¿½vel temporï¿½ria #talvez $n seja desnecessï¿½ria
        $p=([string]$n).PadLeft(3,'0') #padroniza o int em uma string de 3 caracteres


        if ($simnaopergunta -eq "n" -or $simnaopergunta -eq "N"){
            $dados = $dados + "$global:numeropadronizado|$pergunta|$temp|$p|" #nova pergunta inserida
        }
        else{#posteriormente adicionar cï¿½digo para impedir o usuï¿½rio de digtar uma entrada invï¿½lida
            $dados = $dados + "$global:numeropadronizado|$pergunta|$p|$temp|"
        }
        
        $dados = $dados + "$p|$nomeAnimal|*|*|" #novo animal inserido

        
        $dados[$global:linhaDaPergunta]=$global:linhareconstruida
        Clear-Content -Path dado.txt #limpa o arquivo texto
        Add-Content -Value $dados -Path dado.txt
        
    }
}
function reconstruir ([string]$s){#reconstroi a linha da ï¿½ltima pergunta para mudar os ï¿½ndices 
#Esta funï¿½ï¿½o pode ser eliminada quando eu encontrar um jeito de mudar caracteres individuais de uma string

    $temp=$dados[$global:linhaDaPergunta]
    $t=""
    $cont=0
    while ($cont -ne $temp.Length-9) {#adiciona caracter por caracter dentro da variï¿½vel t
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

function padroniza ([int]$numero){#recebe um inteiro e o padroniza em string com zeros ï¿½ esquerda #eliminar essa funï¿½ï¿½o depois
    $global:numeropadronizado=([string]$numero).PadLeft(3,'0')
}
        



foreach ($linha in $dados){#Percorre o texto linha a linha e acha a primeira pergunta

    if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em questï¿½o for uma pergunta
    break }       
}

    
    [string]$temp=""
    $interruptor=0
    while ($interruptor -eq 0){

        #cls
        if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em questï¿½?o for uma pergunta


            achaLinha $linha
            $ind = achalinhaMM($linha) 
            #$global:linhaDaPergunta=$global:indice #salva o Ã­ndice da pergunta onde o programa estÃ¡
            $global:linhaDaPergunta=$ind #salva o Í­ndice da pergunta onde o programa estÃ¡
            #serve para modificar a pergunta posteriormente
        
            exibePergunta
            $global:simounao= Read-Host "Digite `"S`" para SIM, `"N`" para Nï¿½O ou digite `"F`" para finalizar"
            switch ($global:simounao){
            "s"{ #Caso o usuï¿½?rio responda sim para a pergunta

                $temp=$linha[$linha.Length-8] #adiciona o campo que contï¿½?m o nï¿½?mero da linha na variï¿½?vel temp
                $temp+=$linha[$linha.Length-7]
                $temp+=$linha[$linha.Length-6]
                achaLinha $temp
                $linha=$dados[$global:indice]
                
            }

            "n" { #Caso o usuï¿½?rio responda nï¿½?o para a pergunta

                $temp=$linha[$linha.Length-4] #adiciona o campo que contï¿½?m o nï¿½?mero da linha na variï¿½?vel temp
                $temp+=$linha[$linha.Length-3]
                $temp+=$linha[$linha.Length-2]
                achaLinha $temp

                $linha=$dados[$global:indice]
                
            }
            
            "f" {exit}

            default {"Entrada invï¿½lida"}

            }

            
        

        }


        else{ #Se a linha em questï¿½o for uma resposta

            
            
            resposta
            $interruptor=1 #quebra o while acima
        }
        

        

        

    }

    
    
    



