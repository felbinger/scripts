### Dummy Output
You can create the dummy output device for example to record using open broadcaster software, without hearing the audio.
```shell
pacmd load-module module-null-sink sink_name=dummy
pacmd update-sink-proplist dummy device.description=dummy
pacmd load-module module-loopback sink=dummy
```

### Noice Canceling
I couldn't test this yet! - see:
[https://www.linuxuprising.com/2020/09/how-to-enable-echo-noise-cancellation.html](https://www.linuxuprising.com/2020/09/how-to-enable-echo-noise-cancellation.html)  
```shell
echo "load-module module-echo-cancel" >> /etc/pulse/default.pa
```
