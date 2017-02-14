import os, time, serial

def getfiles(path, keyword):
    """Input a path and a keyword, will list the files in that directory
    with that keyword in the order that they were modified."""
    files = [x for x in os.listdir(path) if keyword in x]
    files.sort(key=lambda x: os.path.getmtime(os.path.join(path, x)))
    return files

def check_template_match(rec_file):
    """checks for the phrase 'FB' in the input .rec file (meaning that
    feedback was given, and there was a template match)."""
    return True if 'FB' in open(rec_file).read() else False
    

def signal_new_song(device):
    ser = serial.Serial(device, 9600)
    rec_file = getfiles('.', '.rec')

    while True:
        temp_rec_file = getfiles('.', '.rec')

        if len(temp_rec_file) > len(rec_file):
            if check_template_match(temp_rec_file[len(temp_rec_file)-1]) == True:
                ser.write('T')
                print('new song!')
                print(temp_rec_file[len(temp_rec_file)-1])
                print('\n')
    
        rec_file = temp_rec_file

        time.sleep(1)
