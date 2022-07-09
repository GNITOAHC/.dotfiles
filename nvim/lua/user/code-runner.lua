
local status_ok, code_runner = pcall(require, "code_runner")
if not status_ok then
    return
end

code_runner.setup {
    mode = "float",
    startinsert = true,
    float = {
        border = "solid",
        blend = 0,
    },
    term = {
        -- position = "vertical",
    },
    filetype = {
        python = "cd $dir && python3 $fileName",
        cpp = "cd $dir && g++ $fileName && ./a.out && rm a.out",
        c= "cd $dir && gcc $fileName && ./a.out && rm a.out",
        cs = "cd $dir && csc $fileName -out:main.exe && mono main.exe && rm main.exe"
    }
}
