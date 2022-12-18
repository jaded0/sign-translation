# Import smtplib for the actual sending function.
import yagmail
yag = yagmail.SMTP('jaden.lorenc', 'roxhaxekeimcapys')


def send_email(directory, files_chosen, msg):
    contents = [msg,
            'You can find an gif file attached.']
    for x in files_chosen:
        contents.append('The sign: ' + x)
        contents.append(yagmail.inline(directory + x))
    yag.send('jaden.lorenc@gmail.com', 'sent from script', contents)