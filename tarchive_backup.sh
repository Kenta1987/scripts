#!/bin/bash
# @filename tarchive_backup.sh

# ログ内容の送信先メールアドレス
MAILADD=mail@test.com

# ホスト名
HOSTNAME=`hostname`

# バックアップ先
BAKDIR="/mnt/nfs/backup/${HOSTNAME}";

# バックアップ対象
SRCDIRS=(bin dev home lost+found misc net proc sbin srv tmp var boot etc lib media opt root selinux sys usr)

# バックアップ先がなければ作成
[ ! -d ${BAKDIR} ] && mkdir -p ${BAKDIR};

# ログファイル
TMPLOG=/var/log/tarcbackup_tmp.log 
 
# ログファイルの存在チェック。存在しなければ作成
if [ ! -e $TMPLOG ]; then
    echo "$TMPLOG NOT found." >> $TMPLOG
    touch $TMPLOG # touchコマンドを利用してログ用の空ファイルを作成
    echo -e "$TMPLOG was created.\n" >>$TMPLOG
    # 「-e」はエスケープコード（\nなど）を使用可能にするためのオプション
fi

# バックアップ実行
echo "`date` backup start" >> $TMPLOG
cd /;
for dirs in ${SRCDIRS[@]}; do
    # 実行コマンドの保存
    echo -e "tar -cpzf ${BAKDIR}/`date +%Y%m%d`.$dirs.tar.gz $dirs \n"  >> $TMPLOG
    # コマンド実行
    tar -cpzf ${BAKDIR}/`date +%Y%m%d`.$dirs.tar.gz $dirs >> $TMPLOG 2>&1;
done

echo -e "`date` backup end  \n" >> $TMPLOG

# ログメールの送信
cat $TMPLOG | mail -s "tarbackuplog from $HOSTNAME" $MAILADD
rm -f $TMPLOG
