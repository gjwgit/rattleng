
# 20240720

To check if the file includes a LICENSE

```bash
find . -type f -exec sh -c 'sed -n "3,\$p" "{}" | grep -q "# Copyright" || echo "{}"' \;
```

To add the LICENSE to the top of files where it is not already there:

```bash
for file in $(find . -type f -exec sh -c 'sed -n "3,\$p" "{}" | grep -q "# Copyright" || echo "{}"' \;); do cat TMP "$file" > "$file.tmp" && mv "$file.tmp" "$file"; done
```
