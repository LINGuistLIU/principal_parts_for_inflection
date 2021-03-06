# sourceForm1 sourceMSD1 # sourceForm2 sourceMSD2 # targetMSD => targetForm

import os, sys, json, inspect

current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)
sys.path.insert(0, parent_dir)

import readdata

def reformat(trainlist, devlist, finname, foutname):
    with open(finname, 'w') as fin, open(foutname, 'w') as fout:
        for paradigm, devparadigm in zip(trainlist, devlist):
            # print(len(paradigm), len(devparadigm))
            if len(devparadigm) != 0:
                lemmaform, lemmamsd = paradigm[0]
                for item in devparadigm:
                    tgtmsd = item[1]
                    # tgtform = devdict[item]
                    tgtform = '-'
                    # output = [letter for letter in tgtform]
                    if len(paradigm) == 1:
                        srcform1, srcmsd1 = paradigm[0]
                        srcform2, srcmsd2 = paradigm[0]
                        input = [letter for letter in srcform1] \
                                + [tag for tag in srcmsd1.split(';')] \
                                + ['#'] \
                                + [letter for letter in srcform2] \
                                + [tag for tag in srcmsd2.split(';')] \
                                + ['#'] \
                                + [tag for tag in tgtmsd.split(';')]
                        output = [letter for letter in tgtform]
                        fin.write(' '.join(input) + '\n')
                        fout.write(' '.join(output) + '\n')
                    else:
                        for i in range(0, len(paradigm) - 1):
                            srcform1, srcmsd1 = paradigm[i]
                            for srcform2, srcmsd2 in paradigm[i + 1:]:
                                input = [letter for letter in srcform1] \
                                        + [tag for tag in srcmsd1.split(';')] \
                                        + ['#'] \
                                        + [letter for letter in srcform2] \
                                        + [tag for tag in srcmsd2.split(';')] \
                                        + ['#'] \
                                        + [tag for tag in tgtmsd.split(';')]
                                output = [letter for letter in tgtform]
                                fin.write(' '.join(input) + '\n')
                                fout.write(' '.join(output) + '\n')

if __name__ == "__main__":

    lang_fam_dict = json.load(open('src/lang2fam.json'))
    lang_dir_dict = json.load(open('src/lang2dir.json'))

    lang = sys.argv[1]

    paradigmdir = "paradigms/"

    fname = paradigmdir + lang + '.paradigm'
    trainlist, devlist, testlist = readdata.train_dev_test_list(fname)

    outputdir = './'
    if not os.path.exists(outputdir):
        os.makedirs(outputdir)

    testin = outputdir + 'test.' + lang + '.input'
    testout = outputdir + 'test.' + lang + '.output'

    reformat(trainlist, testlist, testin, testout)
