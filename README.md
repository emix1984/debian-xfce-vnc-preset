# NoVNC-DebianXfce
dockerhub: consol/debian-xfce-vnc:v2.0.3

## NoVNC-DebianXfce used for python-dev with chromium_dirver
apt update && apt install -y curl && \
curl -fL -o Setup_DebianXfceVNC_PythonDev.sh https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/Setup_DebianXfceVNC_PythonDev.sh && \
chmod +x Setup_DebianXfceVNC_PythonDev.sh && \
bash Setup_DebianXfceVNC_PythonDev.sh y

## NoVNC-DebianXfce used for python-dev without chromium_dirver
apt update && apt install -y curl && \
curl -fL -o Setup_DebianXfceVNC_PythonDev.sh https://raw.githubusercontent.com/emix1984/debian-xfce-vnc-preset/refs/heads/main/Setup_DebianXfceVNC_PythonDev.sh && \
chmod +x Setup_DebianXfceVNC_PythonDev.sh && \
bash Setup_DebianXfceVNC_PythonDev.sh