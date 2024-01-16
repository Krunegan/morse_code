--[[

The MIT License (MIT)
Copyright (C) 2024 Flay Krunegan

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or
substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

]]

local function text_to_morse(player_name, input_text)
    local morse = ""
    local morse_dict = {
        a = ".-", b = "-...", c = "-.-.", d = "-..", e = ".", f = "..-.",
        g = "--.", h = "....", i = "..", j = ".---", k = "-.-", l = ".-..",
        m = "--", n = "-.", o = "---", p = ".--.", q = "--.-", r = ".-.",
        s = "...", t = "-", u = "..-", v = "...-", w = ".--", x = "-..-",
        y = "-.--", z = "--..", [" "] = " "
    }
    for i = 1, #input_text do
        local char = input_text:sub(i, i):lower()
        if morse_dict[char] then
            morse = morse .. morse_dict[char] .. " "
        else
            minetest.chat_send_player(player_name, "Unsupported character: " .. char)
            return
        end
    end
    minetest.show_formspec(player_name, "morse_code:result",
        "size[8,8]"..
        "label[0,0;" .. "# "..minetest.colorize("orange", "TEXT TO MORSE").."]"..
        "box[-0.1,-0.1;8,0.7;black]"..
        "box[-0.1,0.7;8,7.4;#030303]"..
        "textarea[0.2,0.7;8,7.4;;;" .. morse .. "]"
    )
end

local function morse_to_text(player_name, input_morse)
    local text = ""
    local morse_dict = {
        [".-"] = "a", ["-..."] = "b", ["-.-."] = "c", ["-.."] = "d",
        ["."] = "e", ["..-."] = "f", ["--."] = "g", ["...."] = "h",
        [".."] = "i", [".---"] = "j", ["-.-"] = "k", [".-.."] = "l",
        ["--"] = "m", ["-."] = "n", ["---"] = "o", [".--."] = "p",
        ["--.-"] = "q", [".-."] = "r", ["..."] = "s", ["-"] = "t",
        ["..-"] = "u", ["...-"] = "v", [".--"] = "w", ["-..-"] = "x",
        ["-.--"] = "y", ["--.."] = "z", [" "] = " "
    }
    local morse_words = input_morse:split(" ")
    for _, morse_word in ipairs(morse_words) do
        if morse_dict[morse_word] then
            text = text .. morse_dict[morse_word]
        else
            minetest.chat_send_player(player_name, "Unsupported Morse sequence: " .. morse_word)
            return
        end
    end
    minetest.show_formspec(player_name, "morse_code:result",
        "size[8,8]"..
        "label[0,0;" .. "# "..minetest.colorize("orange", "MORSE TO TEXT").."]"..
        "box[-0.1,-0.1;8,0.7;black]"..
        "box[-0.1,0.7;8,7.4;#030303]"..
        "textarea[0.2,0.7;8,7.4;;;" .. text .. "]"
    )
end

minetest.register_chatcommand("morse", {
    params = "<text>",
    description = "Translate text to Morse code",
    func = function(name, param)
        text_to_morse(name, param)
    end,
})

minetest.register_chatcommand("unmorse", {
    params = "<morse sequence>",
    description = "Translate Morse code to text",
    func = function(name, param)
        morse_to_text(name, param)
    end,
})