= リテラル

  * [[ref:num]]
  * [[ref:string]]
  * [[ref:backslash]]
  * [[ref:exp]]
  * [[ref:command]]
  * [[ref:here]]
  * [[ref:regexp]]
  * [[ref:array]]
  * [[ref:hash]]
  * [[ref:range]]
  * [[ref:symbol]]
  * [[ref:percent]]

数字の1や文字列"hello world"のようにRubyのプログラムの中に直接
記述できる値の事をリテラルといいます。

===[a:num] 数値リテラル

: 123
: 0d123

  整数

: -123

  符号つき整数 [[trap:Numeric]]

: 123.45

  浮動小数点数
  .1 など "." で始まる浮動小数点数は許されなくなりました。0.1 と書く必
  要があります。

: 1.2e-3

  浮動小数点数
: 0xffff

  16進整数
: 0b1011

  2進整数
: 0377
: 0o377

  8進整数
#@since 2.1.0
: 42r
: 3.14r

  有理数。
  ただし、誤解を招く恐れがあるため、6.022e+23r のような指数部に有理数リ
  テラルを含む形式は指定できません。
: 42i
: 3.14i

  複素数
: 42ri
: 3.14ri

  虚数部が有理数の複素数
#@end
: ?a

#@since 1.9.1
  文字 a を表す String
#@else
  文字 a のコード (97)
#@end

  空白類を指定する場合は、?\s, ?\t などとする
  必要があります。

: ?\C-a

#@since 1.9.1
  コントロール a を表す String
#@else
  コントロール a のコード(1)
#@end
: ?\M-a

#@since 1.9.1
  メタ a を表す String
#@else
  メタ a のコード(225)
#@end
: ?\M-\C-a

#@since 1.9.1
  メタ-コントロール a を表す String
#@else
  メタ-コントロール a のコード(129)
#@end

? 表現では全ての[[ref:backslash]]が有効です。

文字コード以外の数値リテラルには、`_' を含めることができます。
ruby インタプリタは `_' を単に無視し、特別な解釈は何もしません。
これは、大きな数値の桁数がひと目でわかるように記述するのに便利です。
リテラルの最初と、最後には _ を書くことはできません。(リテラルの
前(符号(+,-)の直後を含む)に _を置くとローカル変数やメソッド呼び
出しと解釈されます)

_ は、0x などの prefix の直後に書くことはできません。また、_ を連続して
書いてもエラーになります。他、細かい部分でこのあたりの規則は見直され統
一されました。

        1_000_000_000  => 1000000000
        0xffff_ffff  => 0xffffffff

===[a:string] 文字列リテラル

例:

          "this is a string expression\n"
          'this is a string expression\n'
          %q!I said, "You said, 'She said it.'"!
          %!I said, "You said, 'She said it.'"!
          %Q('This is it.'\n)
          "this is multi line
          string"

文字列はダブルクォートまたはシングルクォートで囲まれています。
ダブルクォートで囲まれた文字列では[[ref:backslash]]と[[ref:exp]](後述)が有効になります。
シングルクォートで囲まれた文字列では、
\\ (バックスラッシュそのもの)と \' (シングルクォート)
を除いて文字列の中身の解釈は行われません。
シングルクォートで囲まれた文字列では行末の \ は \ そのものとして解釈されます。
#@#[[ruby-dev:21339]]

複数行にわたって書くこともできます。
この場合含まれる改行文字は常に\nになります。
実際のソースファイルの改行コードとは無関係です。

空白を間に挟んだ文字列リテラルは、コンパイル時に1つの文字列
リテラルと見倣されます。

          p "foo" "bar"
          => "foobar"

[[ref:percent]] による別形式の文字列表現もあります。

文字列式は評価されるたびに毎回新しい文字列オブジェクトを生成します。

====[a:backslash] バックスラッシュ記法

文字列中でバックスラッシュ(環境によっては￥記号で表示されます)の後に記
述する文字によっては特別な意味を持たせる事ができます。

: \t
  タブ(0x09)

: \v
  垂直タブ(0x0b)

: \n
  改行(0x0a)

: \r
  キャリッジリターン(0x0d)

: \f
  改ページ(0x0c)

: \b
  バックスペース (0x08)

: \a
  ベル (0x07)

: \e
  エスケープ (0x1b)

: \s
  空白 (0x20)

: \nnn
  8 進数表記 (n は 0-7)

: \xnn
  16 進数表記 (n は 0-9,a-f)

: \cx
: \C-x
  コントロール文字 (x は ASCII 文字)

: \M-x
  メタ x (c | 0x80)

: \M-\C-x
  メタ コントロール x

: \x
  文字 x そのもの

#@since 1.9.1
: \unnnn
  Unicode 文字(n は 0-9,a-f,A-F、16進数4桁で指定)。

: \u{nnnn}
  Unicode 文字列(n は 0-9,a-f,A-F)。nnnnは16進数で1桁から6桁まで指定可能。
  スペースかタブ区切りで複数の Unicode 文字を指定できる。
  例: "\u{30eb 30d3 30fc a}" # => "ルビー\n"
  
#@end

: \改行

  文字列中に改行を含めずに改行

====[a:exp] 式展開

例:
       ($ruby = "RUBY"の場合)

          "my name is #{$ruby}" #=> "my name is RUBY"
          'my name is #{$ruby}' #=> "my name is #{$ruby}"

ダブルクォート(")で囲まれた文字列式、コマンド文
字列および正規表現の中では#{式}という形式で式
の内容(を文字列化したもの)を埋め込むことができます。式が変数
記号($,@)で始まる変数の場合には
{}を省略して、#変数名という形式で
も展開できます。文字#に続く文字が
{,$,@でなければ、その
まま文字#として解釈されます。明示的に式展開を止
めるには#の前にバックスラッシュを置きます。

式展開中の式は、ダブルクォートなども含めて Ruby の式をそのまま書くこと
ができます。コメントも許されます。

        p "#{ "string" # comment }"   # => "string"

式展開中のコメントは、# から } まででなく改行までです。上記の例は

        p "#{ "string" # comment
          }"                          # => "string"

と書く必要があります。

===[a:command] コマンド出力

例:

          `date`
          %x{ date }

バッククォート(`)で囲まれた文字列は、ダブルクォー
トで囲まれた文字列と同様に[[ref:backslash]]
の解釈と[[ref:exp]]
が行なわれた後、コマンドとして実行され、その標準出力が文字列
として与えられます。コマンドは評価されるたびに実行されます。
コマンドの終了ステータスを得るには、[[m:$?]] を
参照します。

[[ref:percent]] による別形式のコマンド出力もあります。

===[a:here] ヒアドキュメント (行指向文字列リテラル)

文法:

        <<[-]["'`]識別子["'`]
           ...
        識別子

普通の[[ref:string]]はデリミタ(", ', ` など)で囲まれた
文字列ですが、ヒアドキュメントは `<<識別子' を含む行の次の行から `識別
子' だけの行の直前までを文字列とする行指向のリテラルです。例えば、

        print <<EOS      # 識別子 EOS までがリテラルになる
          the string
          next line
        EOS

これは以下と同じです。

        print "  the string\n  next line\n"

ヒアドキュメントでは、開始ラベル `<<識別子' が文法要素としての式
にあたります。これは、開始ラベルを使ってヒアドキュメント全体を引数に渡
したりレシーバにしたりすることができるということを意味します。

        # 式の中に開始ラベルを書く
        # method の第二引数には "    ヒアドキュメント\n" が渡される
        method(arg1, <<LABEL, arg2)
            ヒアドキュメント
        LABEL

        # ヒアドキュメントをレシーバにメソッドを呼ぶ
        p  <<LABEL.upcase
        the lower case string
        LABEL

        # => "THE LOWER CASE STRING"

開始ラベルの次の行は常にヒアドキュメントとなります。例えば、以下のよう
な記述は文法エラーになります

        printf('%s%d',
               <<EOS,
               3055 * 2 / 5)   # <- この行はヒアドキュメントに含まれてしまう
        This line is a here document.
        EOS

開始ラベルを `<<-識別子' のように `-' を付けて書くことで終端
行をインデントすることができます。これ以外では、終端行に、余
分な空白やコメントさえも書くことはできません。

        if need_define_foo
          eval <<-EOS   # '<<-' を使うと……
            def foo
              print "foo\n"
            end
          EOS
          #↑終端行をインデントできます。
        end

一行に複数のヒアドキュメントを書くこともできます。

        print <<FIRST, <<SECOND
           これは一つめのヒアドキュメントです。
           まだ一つめです。
        FIRST
           この行からは二つめのヒアドキュメントです。
           この行で終わります。
        SECOND

開始ラベル `<<識別子' の `識別子' を(""、''、``)のいずれかで囲む
ことで、ヒアドキュメントとなる文字列リテラルの性質は対応する文字列リテ
ラルと同じ扱いになります。ただし、文字列中に " や ' はバックスラッシュ
エスケープせずにそのまま書けます(エスケープする必要がありません)。シングルクォー
トで囲ったヒアドキュメントの場合、' をエスケープする必要がないというこ
とは、\の特別扱いも必要ないということになります。つまり、シングルクォート
で囲ったヒアドキュメントは完全に書いたままの文字列になります。以下の例
を参照してください。`識別子' がクォートで囲まれていないときはダブルクォー
トでくくられているのと同じです。

        # バックスラッシュ記法、式展開が有効
        print <<"EOS"
        The price is #{$price}.
        EOS

        # 上のものと同じ結果
        print <<EOS
        The price is #{$price}.
        EOS

        # 式展開はできない
        print <<'EOS'
        The price is #{$price}.
        EOS

        # コマンドを実行
        print <<`EOC`
        date
        diff test.c.org test.c
        EOC

文字列リテラルのそれぞれの性質に関しては
[[ref:string]]、
[[ref:exp]]、
[[ref:backslash]]、
[[ref:command]]
を参照してください。

===[a:regexp] 正規表現リテラル

例:

          /^Ruby the OOPL/
          /Ruby/i
          /my name is #{myname}/o
          %r|Ruby|

/で囲まれた文字列は正規表現です。正規表現として解釈される
メタ文字については[[d:spec/regexp]]を参照してください。

終りの/の直後の文字は正規表現に対するオプションになります。
オプションの機能は以下の通りです。


: i

  正規表現はマッチ時に大文字小文字の区別を行わない

: o

  一番最初に正規表現の評価が行われた時に
  一度だけ[[ref:exp]]を行う

: x

  正規表現中の空白(改行も含む)を無視する。また、バックスラッシュでエス
  ケープしない`#' から改行までをコメントとみなして無視する(ただ
  し、コメント中に / を含めると構文解析に失敗するので注意)
//emlist{
  /foo        # コメント
  bar/x
//}
  これは /foobar/ と同じ。

  空白を含めるには \  のようにエスケープします。

: m

  複数行モード。正規表現 "." が改行にもマッチするようになる

#@since 1.9.1
正規表現中の文字は特に指定がない場合、スクリプトエンコーディングの値に
従って処理されます。
#@else
Ruby は日本語化されているので、[[m:$KCODE]] の値に従って正
規表現中の日本語文字を正しく扱います。$KCODE = "n" の場合、日本
語文字を一切認識せずにバイト列として扱います。これはデフォルトの動作で
す。
#@end

オプションとして n, e, s, u のいずれかを指定することで正規表現の文字コードを
#@since 1.9.1
スクリプトエンコーディングに
#@else
[[m:$KCODE]] の値に
#@end
関係なく個々の正規表現リテラルに指定することもできます。

[[ref:percent]] による別形式の正規表現も指定できます。

正規表現の中では文字列と同じ[[ref:backslash]]や
[[ref:exp]]も有効です。

正規表現リテラルはその中に[[ref:exp]]を含まなければ、何度評
価されても同一の正規表現オブジェクトを返します。
[[ref:exp]]を含む場合は評価のたびに(式展開の結果を元に)正規
表現がコンパイルされ正規表現オブジェクトが生成されます(ただし上記の
o オプションを指定すれば、同一の正規表現オブジェクトを返します)

===[a:array] 配列式

例:

          [1, 2, 3]
          %w(a b c)
          %W(a b c)

文法:

          `[' 式`,' ... `]'

それぞれの式を評価した結果を含む配列を返します。
配列は[[c:Array]]クラスのインスタンスです。

要素が文字列リテラルの場合に限り、[[ref:percent]] による別形式の
配列表現も指定できます。

配列式は評価されるたびに毎回新しい配列オブジェクトを生成します。

===[a:hash] ハッシュ式

#@since 1.9.1
例:

          { 1 => 2, 2 => 4, 3 => 6}
          { :a => "A", :b => "B", :c => "C" }
          { a:"A", b:"B", c:"C" } # 一つ上の例と同じ。キーがシンボルの場合はこのように書ける。

文法:

          `{' 式 `=>' 式 `,' ... `}'

#@else
例:

          { 1 => 2, 2 => 4, 3 => 6}

文法:

          `{' 式 `=>' 式 `,' ... `}'
          `{' 式 `,' 式 `,' ... `}'

#@end

それぞれの式を評価した結果をキーと値とするハッシュオブジェク
トを返します。ハッシュとは任意のオブジェクトをキー(添字)として持
つ配列で、[[c:Hash]]クラスのインスタンスです。

メソッドの引数の末尾に要素が1つ以上のハッシュを渡す場合は、{,
}を省略することができます。ただし、obj[...]  形式のメソッ
ド呼び出しと[[ref:array]]では、要素全体がハッシュの場合に限り、
{, }を省略することができます。

例:

        method(1,2,3=>4)      # method(1,2,{3=>4})
        obj[1=>2,3=>4]        # obj[{1=>2,3=>4}]
        [1=>2,3=>4]           # [{1=>2, 3=>4}]

ハッシュ式は評価されるたびに毎回新しいハッシュオブジェクトを生成します。

===[a:range] 範囲オブジェクト

[[ref:d:spec/operator#range]]を参照

範囲式はその両端が数値リテラルであれば、何度評価されても同じオブジェク
トを返します。そうでなければ評価されるたびに新しい範囲オブジェクトを生
成します。

===[a:symbol] シンボル

例:

    (シンボルの例)

          :class
          :lvar
          :method!
          :andthisis?
          :$gvar
          :@ivar
          :@@cvar
          :+

文法:

          `:' 識別子
          `:' 変数名
          `:' 演算子

[[c:Symbol]]クラスのインスタンス。
ある文字列とSymbolオブジェクトは一対一に対応します。

Symbol リテラルに指定できる演算子はメソッドとして再定義できる演算子だ
けです。[[d:spec/operator]] を参照して下さい。

以下の記法も使えます。
  p :'foo-bar' #=> :"foo-bar"
  p :"foo-bar" #=> :"foo-bar"
  p %s{foo-bar} #=> :"foo-bar"

この記法では、任意のシンボルを定義することができます。
#@until 1.9.1
ただし、"\0" を含めることはできません。
#@end

:"..." の形式は、[[ref:backslash]]や
[[ref:exp]]が有効です。

シンボルは常に一意のオブジェクトで、(式展開を含んでいてもその結果が同
じ文字列であれば)何度評価されても同じオブジェクトを返します。

===[a:percent] %記法

[[ref:string]]、[[ref:command]]、[[ref:regexp]]、[[ref:array]]、[[ref:symbol]]では、
%で始まる形式の記法を用いることができます。
文字列や正規表現では、`"', `/' など(通常のリテラルの区切り文字)を要素
に含めたい場合にバックスラッシュの数をコードから減らす効果があります。
また配列式では文字列の配列を簡単に表現できます。それぞれ以下のように対
応します。

  * %!STRING!  : ダブルクォート文字列
  * %Q!STRING! : 同上
  * %q!STRING! : シングルクォート文字列
  * %x!STRING! : コマンド出力
  * %r!STRING! : 正規表現
  * %w!STRING! : 要素が文字列の配列(空白区切り)
  * %W!STRING! : 要素が文字列の配列(空白区切り)。式展開、バックスラッシュ記法が有効
  * %s!STRING! : シンボル。式展開、バックスラッシュ記法は無効
#@since 2.0.0
  * %i!STRING! : 要素がシンボルの配列(空白区切り)
  * %I!STRING! : 要素がシンボルの配列(空白区切り)。式展開、バックスラッシュ記法が有効
#@end

!の部分には改行を含めた任意の非英数字を使うことができます
#@since 2.0.0
(%w、%W、%i、%I は区切りに空白、改行を用いるため、!の部分には使うことができません)。
#@else
(%w、%Wは区切りに空白、改行を用いるため、!の部分には使うことができません)。
#@end
始まりの区切り文字が括弧(`(',`[',`{',`<')である時には、終りの区切り文字は
対応する括弧になります。括弧を区切り文字にした場合、対応が取れていれば
区切り文字と同じ括弧を要素に含めることができます。

            %(()) => "()"

配列式の%記法はシングルクォートで囲んだ文字列を空白文字で分割したのと
同じです。たとえば、

          %w(foo bar baz)

は['foo', 'bar', 'baz']と等価です。

バックスラッシュを使って空白を要素に含むこともできます。

          %w(foo\ bar baz)

          => ["foo bar", "baz"]

%W は、%w と同様ですが、ダブルクォートで囲んだ文字列のように、式展開、
バックスラッシュ記法が使用できます。空白による分割は式展開を評価する前
に行われます。

          v = "c d"
          %W(a\ b #{v}e\sf #{})

          => ["a b", "c de f", ""]
