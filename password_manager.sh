echo "パスワードマネージャーへようこそ！"
echo -n "次の選択肢から入力してください(Add Password/Get Password/Exit)：" 

while true
do
    read Command

    if [ "$Command" = "Add Password" ] ; then #Add Password が入力された場合
        echo -n "サービス名を入力してください: "
        read Service_name
        echo -n "ユーザー名を入力してください: "
        read User_name
        echo -n "パスワードを入力してください: "
        read Password
        
        gpg --yes --passphrase kaxia_nowlearning -o list.txt -d list.txt.gpg 
        echo $Service_name:$User_name:$Password >> list.txt | gpg -e --yes -r kaxia list.txt
        rm list.txt
        
        echo "パスワードの追加は成功しました"
        echo -n "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    elif [ "$Command" = "Get Password" ] ; then #Get Password が入力された場合
        echo -n "サービス名を入力してください: "
        read Service_name
    
        Result=$(gpg -d --passphrase kaxia_nowlearning list.txt.gpg | grep $Service_name)
        if [ "$Result" = "" ] ; then #list.txtに保存されていない場合
            echo "そのサービス名は保存されていません。"
        else #list.txtにある場合
            nameArray=("サービス名" "ユーザー名" "パスワード")
            resultArray=(${Result//:/ }) #":"を" "に置き換えて、配列に代入
            
            for i in 1 2 3
            do
                echo ${nameArray[$i-1]}" : "${resultArray[$i-1]}
            done
        fi
        
        echo -n "次の選択肢から入力してください(Add Password/Get Password/Exit)："
    elif [ "$Command" = "Exit" ] ; then #Exit が入力された場合
        echo "Thank you!"
        break #プログラムが終了
    else #Add Password/Get Password/Exit 以外が入力された場合
        echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
    fi
done
