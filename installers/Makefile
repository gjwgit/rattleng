all:
	icons	From rattl02_trans.png gnerate the icons for app.

# rattle02_trans is the editted version to clean up as much as
# possible.

icons: 32x32.icon 48x48.icon 128x128.icon 256x256.icon 512x512.icon

%.icon: rattle02_trans.png
	convert $^ -resize $* rattle02_trans_$*.png
	cp rattle02_trans_$*.png ~/.local/share/icons/hicolor/$*/apps/rattle.png

# 20241024 gjw Using github actions to generate zip and exe
# distributions for Linux/MacOS/Windows, then download locally, rename
# etc, and upload to togaware.com.

ginstall:
	bash update.sh
