import lz4.block
import sys

# Extract and compress mozilla lz4 files

mozlz4_header = b"mozLz40\0" #mozlz4 header magic

def extract(file_in, file_out):
    with open(file_in, "rb") as f_in:
        header = f_in.read(8)
        if header != mozlz4_header:
            print("invalid header")
            exit()
        
        raw = f_in.read()
        data = lz4.block.decompress(raw)

        with open(file_out, "wb") as f_out:
            f_out.write(data)

def compress(file_in, file_out):
    with open(file_in, "rb") as f_in:
        raw = f_in.read()
        data = mozlz4_header + lz4.block.decompress(raw)

        with open(file_out, "wb") as f_out:
            f_out.write(data)

if __name__=="__main__":
    if len(sys.argv) > 2:
        if sys.argv[1] == "x":
            extract(sys.argv[2], sys.argv[3])
            print("extraction done!")
            exit()

        if sys.argv[1] == "c":
            compress(sys.argv[2], sys.argv[3])
            print("compression done!")
            exit()

    print("invalid arguments")
    print("usage: mozlz4.py mode file_input file_output")
    exit()
