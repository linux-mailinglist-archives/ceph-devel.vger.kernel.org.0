Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67454CD919
	for <lists+ceph-devel@lfdr.de>; Sun,  6 Oct 2019 22:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfJFUFm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 6 Oct 2019 16:05:42 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45575 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfJFUFl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 6 Oct 2019 16:05:41 -0400
Received: by mail-io1-f67.google.com with SMTP id c25so24116372iot.12
        for <ceph-devel@vger.kernel.org>; Sun, 06 Oct 2019 13:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ln1PD8BsJJdkh0teMBQwGNhCGzrQRxpCVDmE/zE2goc=;
        b=OPGPc/LWZ3Glpc+WVgBM7XzrpvXmTZwrGW/6ELSU2saaGxk2UwFQaq+5xS7HFgbxR5
         P48a+VyG6z7MuLOdhDfgj0P6WK76iR1yaRrNvx/Wr9Fkz3ljC+jwqB7hVrj6lk4cNPhG
         ecny+snnNNRlVmw+aKHlVyRen/ZAAuyTlTyqB+aaNQsR9+t9gT9WGyQAOMfZYEe7knoV
         rXlo+JrHTqR2GqpdCtkvkVgMW9Tot2g5rmURXuvVV1Zauo6+QqP8FepjubT3DCtNsla0
         /2W0+34NmeWeVNx2QES8dWjz+mcVnKGFy6ecNnxdGaPbHNXjjdH2n7lz3VqWDx0tRYQr
         w8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ln1PD8BsJJdkh0teMBQwGNhCGzrQRxpCVDmE/zE2goc=;
        b=Sa5XBmJHn3dmUNky7PijJl2TPl/KveOqFmMHURWCOm6lU4UmaDY8ipBvlarwTC/wQ/
         5UPjKWBX0YA2Wd/syl2q/rxbdFfyz800OTNCcAROsT+pvvUZf1nOcrbCqUp5C+8Oy8xv
         4Yi5MTwHfM548rne0AKLCm3g56ulIxE7axLvjf8vOUyBvLfLILzSNqROXnjJpWDi1Btm
         FVEttMvUC2+gVlVOUYqci4rdwS9d8JM4bJ1of4OODv8qO1btJvJMixM+UMCeSxLpuZKy
         OJTE/UnXusZIb+ePhzSfVe1Oz8O3wk+S/O7drwgqoDz/kZ7o9uIVzYsysFTLwR01gG4I
         eW3Q==
X-Gm-Message-State: APjAAAVFnObJke18OoXVCsPhjL4OEM4a5powQYwEr/8BseygYrbDuOkg
        dodLYEWVOyL9PNJn8OGC1xJc2MlNdjYJgxRAgRvTOtZ0
X-Google-Smtp-Source: APXvYqxKEcaJunEODm+C1tyfj+jn86cAaVfn2i5pUDBY2B+jWsxD2803FyO8gN77OGjwwPg9BZ2dHfq0gggJnae1+zQ=
X-Received: by 2002:a6b:6d18:: with SMTP id a24mr10022929iod.112.1570392340648;
 Sun, 06 Oct 2019 13:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <1569598402-28609-1-git-send-email-dongsheng.yang@easystack.cn>
In-Reply-To: <1569598402-28609-1-git-send-email-dongsheng.yang@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 6 Oct 2019 22:05:42 +0200
Message-ID: <CAOi1vP8esNkzaXAxwRm4erM0Cu6Rg7bb+pEaj+HnJVFeY-qeSA@mail.gmail.com>
Subject: Re: [PATCH] rbd: cancel lock_dwork before unlocking in cleanup path
 of do_rbd_add()
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000009f85b5059443752a"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

--0000000000009f85b5059443752a
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2019 at 5:35 PM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
> There is a warning message[1] in my test with below steps:
>   # rbd bench --io-type write --io-size 4K --io-threads 1 --io-pattern ra=
nd test &
>   # sleep 5
>   # pkill -9 rbd
>   # rbd map test &
>   # sleep 5
>   # pkill rbd
>
> The reason is that the rbd_add_acquire_lock() is interruptable,
> that means, when we kill the waiting on ->acquire_wait, the lock_dwork
> could be still running.
>
> 1. do_rbd_add()                                                 2. lock_d=
work
> rbd_add_acquire_lock()
>   - queue_delayed_work()
>                                                                 lock_dwor=
k queued
>     - wait_for_completion_killable_timeout()  <-- kill happen
> rbd_dev_image_unlock()  <-- UNLOCKED now, nothing to do.
> rbd_dev_device_release()
> rbd_dev_image_release()
>   - ...
>                                                                 lock succ=
essed here
>      - cancel_delayed_work_sync(&rbd_dev->lock_dwork)
>
> Then when we reach the rbd_dev_free(), lock_state is not RBD_LOCK_STATE_U=
NLOCKED.
>
> To fix it, this commit make sure the lock_dwork was finished before calli=
ng
> rbd_dev_image_unlock().
>
> On the other hand, this would not happend in do_rbd_remove(), because
> after rbd mapped, lock_dwork will only be queued for IO request, and
> request will continue unless lock_dwork finished. when we call
> rbd_dev_image_unlock() in do_rbd_remove(), all requests are done.
> that means, lock_state should not be locked again after rbd_dev_image_unl=
ock().
>
> [1]:
> [  116.043632] rbd: rbd0: no lock owners detected
> [  117.745975] rbd: rbd0: failed to acquire exclusive lock: -512
> [  121.055286] rbd: image test: no lock owners detected
> [  126.066977] rbd: image test: no lock owners detected
> [  131.103870] rbd: image test: no lock owners detected
> [  132.360374] rbd: image test: no lock owners detected
> [  132.369202] rbd: image test: breaking header lock owned by client24204
> [  132.903969] rbd: image test: failed to unwatch: -512
> [  137.905601] ------------[ cut here ]------------
> [  137.906922] WARNING: CPU: 18 PID: 4545 at drivers/block/rbd.c:5576 rbd=
_dev_free+0xa5/0xc0 [rbd]
> [  137.908957] Modules linked in: nbd(OE) rbd(OE) libceph(OE) dns_resolve=
r tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag sg cfg8=
0211 rfkill snd_hda_codec_generic ledtrig_audio kvm_intel kvm irqbypass crc=
t10dif_pclmul cirrus crc32_pclmul drm_kms_helper snd_hda_intel ghash_clmuln=
i_intel ext4 syscopyarea snd_hda_codec sysfillrect nfsd mbcache sysimgblt s=
nd_hda_core fb_sys_fops jbd2 drm snd_hwdep aesni_intel snd_seq crypto_simd =
cryptd glue_helper snd_seq_device auth_rpcgss snd_pcm nfs_acl snd_timer loc=
kd i2c_piix4 snd i2c_core pcspkr virtio_balloon soundcore grace sunrpc ip_t=
ables xfs libcrc32c virtio_console virtio_blk(O) 8139too ata_generic pata_a=
cpi serio_raw ata_piix libata virtio_pci crc32c_intel 8139cp virtio_ring mi=
i floppy(O) virtio dm_mirror dm_region_hash dm_log dm_mod dax [last unloade=
d: libceph]
> [  137.926270] CPU: 18 PID: 4545 Comm: rbd Tainted: G           OE     5.=
3.0-rc1+ #15
> [  137.928091] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
> [  137.931081] RIP: 0010:rbd_dev_free+0xa5/0xc0 [rbd]
> [  137.932240] Code: 00 00 75 05 e8 1c ad ff ff 48 8b bb e0 00 00 00 e8 c=
0 99 ba e5 48 89 df 5b e9 b7 99 ba e5 48 c7 c7 98 90 6d c0 e8 69 20 a4 e5 <=
0f> 0b e9 75 ff ff ff 48 c7 c7 98 90 6d c0 e8 56 20 a4 e5 0f 0b e9
> [  137.936783] RSP: 0018:ffffb0f9c2f53dc8 EFLAGS: 00010282
> [  137.938161] RAX: 0000000000000024 RBX: ffff97f68636f000 RCX: 000000000=
0000000
> [  137.939922] RDX: 0000000000000000 RSI: ffff97f69fa97b18 RDI: ffff97f69=
fa97b18
> [  137.941673] RBP: ffff97f68636f000 R08: 0000000000000000 R09: 000000000=
0000000
> [  137.943469] R10: 0000000000000000 R11: 0000000000000000 R12: ffff97f68=
636f7c0
> [  137.944970] R13: ffff97f693dad270 R14: 0000000000000000 R15: ffff97f68=
fc76800
> [  137.946292] FS:  00007f3de0e7bb00(0000) GS:ffff97f69fa80000(0000) knlG=
S:0000000000000000
> [  137.948207] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  137.949720] CR2: 00007f1281623000 CR3: 00000007f0ec2005 CR4: 000000000=
00206e0
> [  137.951469] Call Trace:
> [  137.952417]  rbd_dev_release+0x41/0x60 [rbd]
> [  137.953651]  device_release+0x27/0x80
> [  137.954792]  kobject_release+0x68/0x190
> [  137.955954]  do_rbd_add.isra.67+0x970/0xf60 [rbd]
> [  137.957253]  kernfs_fop_write+0x109/0x190
> [  137.958484]  vfs_write+0xbe/0x1d0
> [  137.959566]  ksys_write+0xa4/0xe0
> [  137.960643]  do_syscall_64+0x60/0x270
> [  137.961749]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> [  137.963119] RIP: 0033:0x7f3dd455469d
> [  137.964245] Code: cd 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f0 f=
f ff 73 31 c3 48 83 ec 08 e8 4e fd ff ff 48 89 04 24 b8 01 00 00 00 0f 05 <=
48> 8b 3c 24 48 89 c2 e8 97 fd ff ff 48 89 d0 48 83 c4 08 48 3d 01
> [  137.968699] RSP: 002b:00007ffd91490010 EFLAGS: 00000293 ORIG_RAX: 0000=
000000000001
> [  137.970559] RAX: ffffffffffffffda RBX: 0000000000000086 RCX: 00007f3dd=
455469d
> [  137.972254] RDX: 0000000000000086 RSI: 000055790f5f5338 RDI: 000000000=
0000009
> [  137.974030] RBP: 00007ffd91490050 R08: 0000000000000004 R09: 000000000=
000004d
> [  137.975806] R10: 00007ffd9148fbe0 R11: 0000000000000293 R12: 000055790=
f5c8e58
> [  137.977528] R13: 000055790f3479b8 R14: 0000000000000001 R15: 000000000=
0000001
> [  137.979250] irq event stamp: 61780
> [  137.980421] hardirqs last  enabled at (61779): [<ffffffffa610f403>] co=
nsole_unlock+0x503/0x5f0
> [  137.982397] hardirqs last disabled at (61780): [<ffffffffa600379a>] tr=
ace_hardirqs_off_thunk+0x1a/0x20
> [  137.984495] softirqs last  enabled at (61776): [<ffffffffa6c00343>] __=
do_softirq+0x343/0x447
> [  137.986504] softirqs last disabled at (61769): [<ffffffffa609a1b7>] ir=
q_exit+0xe7/0xf0
> [  137.988417] ---[ end trace 10917ffd2e2f48ca ]---
>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> ---
>  drivers/block/rbd.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index 5bb98f5..44dd7a0 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -7807,6 +7807,7 @@ static ssize_t do_rbd_add(struct bus_type *bus,
>         return rc;
>
>  err_out_image_lock:
> +       cancel_delayed_work_sync(&rbd_dev->lock_dwork);
>         rbd_dev_image_unlock(rbd_dev);
>         rbd_dev_device_release(rbd_dev);
>  err_out_image_probe:

Hi Dongsheng,

I didn't pay much attention to the interrupt/timeout case because it
can't work properly with blocking lock, unlock, etc calls anyway.  That
said this is a valid race!

I think it would be better to do that in rbd_add_acquire_lock(), only
if the wait is interrupted.  Please see the attachment.

Thanks,

                Ilya

--0000000000009f85b5059443752a
Content-Type: text/x-patch; charset="US-ASCII"; name="cancel_delayed_work_sync.diff"
Content-Disposition: attachment; filename="cancel_delayed_work_sync.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_k1ff1aq20>
X-Attachment-Id: f_k1ff1aq20

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svcmJkLmMgYi9kcml2ZXJzL2Jsb2NrL3JiZC5jCmlu
ZGV4IDhjNzdjNGRhODcyNy4uZGFhYWZkNjQ0YjI0IDEwMDY0NAotLS0gYS9kcml2ZXJzL2Jsb2Nr
L3JiZC5jCisrKyBiL2RyaXZlcnMvYmxvY2svcmJkLmMKQEAgLTY2NjMsMTAgKzY2NjMsMTMgQEAg
c3RhdGljIGludCByYmRfYWRkX2FjcXVpcmVfbG9jayhzdHJ1Y3QgcmJkX2RldmljZSAqcmJkX2Rl
dikKIAlxdWV1ZV9kZWxheWVkX3dvcmsocmJkX2Rldi0+dGFza193cSwgJnJiZF9kZXYtPmxvY2tf
ZHdvcmssIDApOwogCXJldCA9IHdhaXRfZm9yX2NvbXBsZXRpb25fa2lsbGFibGVfdGltZW91dCgm
cmJkX2Rldi0+YWNxdWlyZV93YWl0LAogCQkJICAgIGNlcGhfdGltZW91dF9qaWZmaWVzKHJiZF9k
ZXYtPm9wdHMtPmxvY2tfdGltZW91dCkpOwotCWlmIChyZXQgPiAwKQorCWlmIChyZXQgPiAwKSB7
CiAJCXJldCA9IHJiZF9kZXYtPmFjcXVpcmVfZXJyOwotCWVsc2UgaWYgKCFyZXQpCi0JCXJldCA9
IC1FVElNRURPVVQ7CisJfSBlbHNlIHsKKwkJY2FuY2VsX2RlbGF5ZWRfd29ya19zeW5jKCZyYmRf
ZGV2LT5sb2NrX2R3b3JrKTsKKwkJaWYgKCFyZXQpCisJCQlyZXQgPSAtRVRJTUVET1VUOworCX0K
IAogCWlmIChyZXQpIHsKIAkJcmJkX3dhcm4ocmJkX2RldiwgImZhaWxlZCB0byBhY3F1aXJlIGV4
Y2x1c2l2ZSBsb2NrOiAlbGQiLCByZXQpOwo=
--0000000000009f85b5059443752a--
