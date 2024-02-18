let
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgqmNYiR5uEzDRy/sPyTUF3qmA8wCp82JPchVDHeh/y0TR04oh8vm0YBmoO/k4W+koRW1GWrFPCBmVsLTf+6x2kXOQW9emHUy/iVG95Wu9jkjB1tmVKhkgYLb9s/MZ4LPa+jAm4U8yN4At+2isDXQganOkKGMkPRuG8jt49q9+zclSJGUqTUsOOJk09OZq0hnVNMlLP7t604uPBVkyM+bWpb9xwA817uBXqc1KGuf4AVIAGgnK4YLAAiUxvBxiu5gFtZkZ0OMRnKVCbRFXG/bOKV80EgQF+ZmDAJMDrkPALP4euYnRX8aoEYwmh5TCl3brq5oULeEPzNHtJN2Wg5l1 mauglee@probook"
  ];
in
{
	"test1.age".publicKeys = keys;
	"test2.age".publicKeys = keys;
}
