#!/bin/sh
##
channel=HAZEM-WAHBA
version=motor

# اسم الملف الفعلي على السيرفر
REMOTE_FILENAME="channels_backup_OpenBlackhole_20260227_HAZEMWAHBA.tar.gz"
# اسم الملف الذي سيتم تحميله محلياً (للتبسيط)
LOCAL_FILENAME="enigma2_backup.tar.gz"

echo "*********************************************************"
echo "*     Downloading $channel $version Channels List    *"
echo "*********************************************************"
echo "> Please Wait ......"
sleep 2s

# الانتقال إلى المجلد المؤقت
cd /var/volatile/tmp

# تحميل الملف مع عرض التقدم
echo "> Downloading from GitHub..."
wget -O $LOCAL_FILENAME "https://raw.githubusercontent.com/Ham-ahmed/2802/refs/heads/main/$REMOTE_FILENAME" 2>&1

# التحقق من نجاح التحميل
if [ $? -eq 0 ] && [ -s $LOCAL_FILENAME ]; then
    echo "> Download completed successfully!"
else
    echo "> Download failed! Please check your internet connection."
    exit 1
fi

echo ""
echo "> Removing old channel lists..."
# حذف الملفات القديمة (مع التأكد من وجودها)
rm -rf /etc/enigma2/lamedb
rm -rf /etc/enigma2/*.tv
rm -rf /etc/enigma2/*.radio
rm -rf /etc/enigma2/blacklist
rm -rf /etc/enigma2/whitelist
rm -rf /etc/enigma2/userbouquet.*
rm -rf /etc/tuxbox/*.xml

echo ""
echo "*********************************************************"
echo "*     Installing $channel $version Channels List     *"
echo "*********************************************************"
echo "> Extracting files... Please Wait ......"
sleep 2s

# فك الضغط مباشرة في المسار الصحيح (/)
# الخيار -C / يعني استخراج الملفات إلى المجلد الجذر (/) حيث توجد المجلدات etc, usb, الخ
tar -xzf $LOCAL_FILENAME -C /

# التحقق من نجاح التثبيت
if [ $? -eq 0 ]; then
    echo "> Installation completed successfully!"
else
    echo "> Installation failed! The file might be corrupted."
    # تنظيف الملف التالف
    rm -f $LOCAL_FILENAME
    exit 1
fi

# تنظيف الملف المؤقت
rm -f $LOCAL_FILENAME

echo ""
echo "> Reloading Services - Please Wait..."
# إعادة تحميل القنوات
wget -qO - http://127.0.0.1/web/servicelistreload?mode=0 > /dev/null 2>&1
sleep 3

echo ""
echo "*********************************************************"
echo "*            Enigma2 GUI Restarting...                 *"
echo "*********************************************************"
echo "> Please wait for the interface to restart..."
sleep 2

# إعادة تشغيل الواجهة الرسومية
init 4
sleep 2
init 3

echo ""
echo "*********************************************************"
echo "*     Channel list installation completed successfully! *"
echo "*     Enjoy your $channel $version channels!            *"
echo "*********************************************************"

exit 0