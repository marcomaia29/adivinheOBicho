$dados = Get-content dado.txt #variïável recebe todo o conteudo do arquivo de texto
Write-Output "Eu vou descobrir em qual animal você está pensando.`n`n`n" #frase de efeiton
$global:numeropadronizado=""
[string]$global:simounao=""
[int]$global:linhaDaPergunta=99999


function exibe{#exibe o segundo campo da linha, sendo pergunta ou resposta

    $pergunta = $linha[4]#recebe a primeira letra do texto da pergunta
    $cont = 5
    while ($linha[$cont] -ne "|") {#adiciona caracter por caracter dentro da variável pergunta
        $pergunta += $linha[$cont]
        $cont++
    }

    Write-Output "$pergunta" #Saída para o usuário

}

function achaLinha([string]$s){#acha o índice no arquivo texto que contém o texto em questão
    $s1= $s[0] + $s[1] + $s[2]
    return ([int]$s1) -1
}

function achaUltima{ #acha o índice da última linha ignorando linhas em branco
    $i=0
    [int]$u=0
    foreach ($candidato in $dados){
        if ($candidato.Length -gt 2){ #2? verificar
            $u=$i
        }
        $i++
    }
    return $u
}



function resposta {
    Write-Output "O animal que você escolheu é:"
    exibe
    Write-Output "Acertei?"
    $x= Read-Host "Digite `"S`" para SIM, `"N`" para NÃO"
    if($x -eq "s" -or $x -eq "S"){
        Write-Output "Obrigado por jogar!"
        pause
        exit
    }
    else{#caso o aplicativo tenha errado a resposta final dada ao usuário
        $nomeAnimal= Read-Host "Digite o nome do animal que você estava pensando"
        if($nomeAnimal.Length -lt 1){
            do{
            Write-Output "Entrada inválida, necessário pelo menos 1 caractere"
            $nomeAnimal= Read-Host "Digite o nome do animal que você estava pensando"
            }while($nomeAnimal.Length -lt 1)
        }

        $pergunta= Read-Host "Digite uma pergunta-de-sim-ou-não que diferencie esse animal do animal citado anteriormente"
        if($pergunta.Length -lt 1){
            do{
            Write-Output "Entrada inválida, necessário pelo menos 1 caractere"
            $pergunta= Read-Host "Digite uma pergunta-de-sim-ou-não que diferencie esse animal do animal citado anteriormente"
            }while($nomeAnimal.Length -lt 1)
        }

        $simnaopergunta= Read-Host "Para o animal que você acabou de digitar, a resposta dessa pergunta é sim ou não? `n Digite `"S`" para SIM, `"N`" para NÃO"
        if($simnaopergunta.Length -lt 1){
            do{
            Write-Output "Entrada inválida, necessário pelo menos 1 caractere"
            $simnaopergunta= Read-Host "Para o animal que você acabou de digitar, a resposta dessa pergunta é sim ou não? `n Digite `"S`" para SIM, `"N`" para NÃO"
            }while($nomeAnimal.Length -lt 1)
        }

        [int]$ultima=achaUltima
        [string]$valor=""#comporta os números padronizados do índice da última linha do texto
        $valor=$dados[$ultima][0] + $dados[$ultima][1] + $dados[$ultima][2]
        
        [int]$proximaresposta=$ultima + 3
        [int]$proximapergunta=$ultima + 2

        padroniza $proximapergunta
        $linhareconstruida= reconstruir $global:numeropadronizado


        #esta parte do código se faz desnecessária ao se fazer possível retorno de funções
        [string]$r="" #variável temporária
        [int]$n=$proximaresposta #variável temporária #talvez $n seja desnecessária
        $r=([string]$n).PadLeft(3,'0') #padroniza o int em uma string de 3 caracteres

        
        if ($simnaopergunta -eq "n" -or $simnaopergunta -eq "N"){
            $dados = $dados + "$global:numeropadronizado|$pergunta|$temp|$r|" #nova pergunta inserida
        }
        else{#posteriormente adicionar código para impedir o usuário de digtar uma entrada inválida
            $dados = $dados + "$global:numeropadronizado|$pergunta|$r|$temp|"
        }
        
        $dados = $dados + "$r|$nomeAnimal|*|*|" #novo animal inserido

        $dados[$global:linhaDaPergunta]=$linhareconstruida
        Clear-Content -Path dado.txt #limpa o arquivo texto
        Add-Content -Value $dados -Path dado.txt
        
    }
}
function reconstruir ([string]$s){#reconstroi a linha da última pergunta para mudar os índice 
#Esta função pode ser eliminada quando eu encontrar um jeito de mudar caracteres individuais de uma string

    $temp=$dados[$global:linhaDaPergunta]
    $t=""
    $cont=0
    while ($cont -ne $temp.Length-9) {#adiciona caracter por caracter dentro da variável t
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
    
    $recons="$t|$camposim|$camponao|"
    return $recons
    #$global:linhareconstruida="$t|$camposim|$camponao|"
}

function padroniza ([int]$numero){#recebe um inteiro e o padroniza em string com zeros à esquerda #eliminar essa função depois
    $global:numeropadronizado=([string]$numero).PadLeft(3,'0')
}
     





#Início da aplicação
foreach ($linha in $dados){#Percorre o texto linha a linha e acha a primeira pergunta

    if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em questão for uma pergunta
    break }       
}

    [string]$temp=""
    $interruptor=0
    while ($interruptor -eq 0){

        #cls
        if ($linha[$linha.Length-2] -ne "*"){ #Se a linha em questão for uma pergunta

            $indice=achaLinha $linha
            $global:linhaDaPergunta=$indice #salva o índice da pergunta onde o programa está
            #serve para modificar a pergunta posteriormente
        
            exibe
            $global:simounao= Read-Host "Digite `"S`" para SIM, `"N`" para NÃO ou digite `"F`" para finalizar"
            switch ($global:simounao){
            "s"{ #Caso o usuário responda sim para a pergunta

                $temp=$linha[$linha.Length-8] #adiciona o campo que contém o número da linha na variável temp
                $temp+=$linha[$linha.Length-7]
                $temp+=$linha[$linha.Length-6]
                $indice=achaLinha $temp
                $linha=$dados[$indice]
            }

            "n" { #Caso o usuário responda não para a pergunta

                $temp=$linha[$linha.Length-4] #adiciona o campo que contém o NÚMERO da linha na variável temp
                $temp+=$linha[$linha.Length-3]
                $temp+=$linha[$linha.Length-2]
                $indice=achaLinha $temp
                $linha=$dados[$indice]
            }
            
            "f" {exit}

            default {"Entrada invï¿½lida"}

            }

        }

        else{ #Se a linha em questão for uma resposta
            resposta
            $interruptor=1 #quebra o while acima
        }

    }

    
    
    



