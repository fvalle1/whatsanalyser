module whatsapp

export preprocess, process_words, process_chat

function preprocess(string)
    string = lowercase(string)
    skip_header = false
    if occursin(r"\[[0-9]{0,2}\/[0-9]{0,2}\/[0-9]{0,2}\, [0-9]{0,2}\:[0-9]{0,2}\:[0-9]{0,2}\]",string)
        skip_header=true
    end
    for symbol in ["." "," ";" "?" "!" ":" ":D" "  " "(" ")" "'" "-" "**" "🤣" ":D"]
       string = replace(string, symbol=>"")
    end
    if skip_header
        return split(string," ")[5:end]
    else
       return split(string," ")
    end
end

function process_words(line, voc)
    for word in line
        if haskey(voc, word)
            voc[word]+=1
        else
            voc[word]=1
        end
    end
end

function process_chat(chat_file="_chat.txt")
    voc = Dict()
    h = []
    M = []
    open(chat_file,"r") do io
        #global h, M
        while ! eof(io)
            message = readline(io)
            processed_message = preprocess(message)
            process_words(processed_message, voc)
            h = [h; length(unique(processed_message))]
            M = [M; length(processed_message)]
        end
    end
    f = collect(values(voc))
    f = sort!(f, rev=true);
    f = f ./ sum(f);
    return voc, h, M ,f
end

end