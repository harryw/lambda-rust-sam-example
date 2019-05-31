
# convert any Windows newlines to Unix newlines
((Get-Content rustbuild.sh) -join "`n") + "`n" | Set-Content -NoNewline rustbuild.sh

# rebuild the Rust app in a Linux Docker container
rm -force -recurse -erroraction silentlycontinue lambda-rust-app\target
docker build . -t rustlambdabuild
$localVolumePath = "/$((pwd).Path.Substring(0,1).ToLower())" + `
                   "/$((pwd).Path.Substring(2).Replace("\","/"))"
docker run -it --rm `
    -v "${localVolumePath}/lambda-rust-app:/mnt/app" `
    rustlambdabuild /rustbuild.sh

# copy the bootstrap binary to this directory
cp lambda-rust-app\target\x86_64-unknown-linux-musl\release\bootstrap .
