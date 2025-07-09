import subprocess
import os
import time

path_sep = f"\\" * (os.name == "nt") + f"/" * (os.name == "posix")


def downloader(link, output_file):
    command = " ".join(["ffmpeg", "-i", link, "-bsf:a aac_adtstoasc -vcodec copy -c copy", f"{os.path.dirname(os.path.abspath(__file__))}{path_sep}{output_file}"])
    print(command)
    turn_off_flag = True if input("Turn the computer Off arter downloading?.. (y/n)").strip().lower() == "y" else False 
    if input("Start downloading?.. (y/n) ").strip().lower() == "y":
        time_start = time.time()
        subprocess.run(command)


        timer = round(time.time() - time_start)
        print("Script running time:" + f" {timer//3600}h " * (timer>=3600) + f"{(timer//60)%60}m " * (timer>=60 or timer>=3600) + f"{timer%60}s")

        if turn_off_flag:
            os.system('shutdown -s')

    else:
        print("Aborted.")



def main():

    link = ""
    outputfile = ""

    link_ = link.strip() if link else input("Enter .m3u8 link.. ").strip()
    outputfile_ = outputfile.strip() if outputfile else input("Enter output file name..  ").strip()


    if outputfile_ and link_:
        if outputfile_.endswith(".mp4"):
            if link_.endswith(".m3u8") and link_.startswith("http"):
                downloader(link = link_, output_file = outputfile_)
            else:
                print('Incorrect link format(not .m3u8)')
        else:
            print("Incorrect output file format(not .mp4)")
    else: 
        print("Parameters cannot be empty")


if __name__ == "__main__":
    main()