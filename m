Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29802CF54F
	for <lists+ceph-devel@lfdr.de>; Tue,  8 Oct 2019 10:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfJHIur (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 8 Oct 2019 04:50:47 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35112 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728866AbfJHIuq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 8 Oct 2019 04:50:46 -0400
Received: by mail-io1-f67.google.com with SMTP id q10so34867374iop.2
        for <ceph-devel@vger.kernel.org>; Tue, 08 Oct 2019 01:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h6gi+5XwnPjtqwa5lsK1DsiLtuDRTGSBcBy8EwF8VWE=;
        b=VdtYqzn4+GP/2kb8Y23IB+h4uDJCInvdBJWj15ZamsnVRlFCAzV21vv43MOS9QW0M/
         +oz5LMB6D1fOMgcUoYZrlSA3InlJfbYfzkkC1OgSdQOg5Q7tcrKlyJh0txRQaloFCvOm
         zFqJc6Z47oefya0K58TVhrP+TwhmTjJbtjfUPQdMRef4RL7/K2LqS4FGIzfUfe1rmzcp
         5qbUiCSg3CB6oNRsZttqNJD9RT/Ysj60AlVeE0zERgVLRxaly31lwa+pcmrpCX3kWeSF
         mX0VQnwgvattD2fxt7N4PPcAu4/ahWXRD2aExmU8tz+5BK/45hUsZbAeJ58cprydTd9m
         T4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h6gi+5XwnPjtqwa5lsK1DsiLtuDRTGSBcBy8EwF8VWE=;
        b=Oc1CHZQuEVUkHoLyVU+gZKQK6VKr5wZs4el91aK8Rpsc6E5/58EQ7l/o7uo8B7Cf4Y
         9S3cuGv0TkfomdC59r4f9BvKSCPTdXY1bTJOZfdbGCugUwI8L7SZ59IOMMZSJIQVe4OW
         RRDemU8DkZnuZOI/11tzgqvB0PH7r0o5MHZl9OoXm6wcZ8dP7HxBgx2WKWmJYljVdIGU
         CarzjnHHVKuGdoX9dTLbl10tWPGo97YjMuO80ooAAFVAALaNjVE5PXfAEZghxpNbxdf4
         PdgJmUGXDEEHY9q1XuRBZyFdxqQrHIo/Mt4jWb6tGInY7SDmSnJBQGcU/RO0oyTkw7pI
         waGg==
X-Gm-Message-State: APjAAAUi34iLpfAJyZgIJxYdFmMyibWF9FiKySPZYPaNfo5xEXWE/BQC
        Q0kK8OljxPip0NLjg8P+0m204VoGw9kp43WQ4rMvOGjP
X-Google-Smtp-Source: APXvYqxG3+3RE4BuQkn2jk7gpfXsDSP61b/6RNeiJXgSNATg9QDMmzijhDBVZCY80YaOgmSITZZlGnzOR7UwsCgVPxc=
X-Received: by 2002:a6b:6d18:: with SMTP id a24mr1714542iod.112.1570524645559;
 Tue, 08 Oct 2019 01:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <1569598402-28609-1-git-send-email-dongsheng.yang@easystack.cn>
 <CAOi1vP8esNkzaXAxwRm4erM0Cu6Rg7bb+pEaj+HnJVFeY-qeSA@mail.gmail.com> <5D9BE577.3010008@easystack.cn>
In-Reply-To: <5D9BE577.3010008@easystack.cn>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 8 Oct 2019 10:50:48 +0200
Message-ID: <CAOi1vP-YR-n-+BPZdx6o1bMeMQwAeZNvzTipsfsZSK-Pe5SKqg@mail.gmail.com>
Subject: Re: [PATCH] rbd: cancel lock_dwork before unlocking in cleanup path
 of do_rbd_add()
To:     Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 8, 2019 at 3:26 AM Dongsheng Yang
<dongsheng.yang@easystack.cn> wrote:
>
>
>
> On 10/07/2019 04:05 AM, Ilya Dryomov wrote:
> > On Fri, Sep 27, 2019 at 5:35 PM Dongsheng Yang
> > <dongsheng.yang@easystack.cn> wrote:
> >> There is a warning message[1] in my test with below steps:
> >>    # rbd bench --io-type write --io-size 4K --io-threads 1 --io-patter=
n rand test &
> >>    # sleep 5
> >>    # pkill -9 rbd
> >>    # rbd map test &
> >>    # sleep 5
> >>    # pkill rbd
> >>
> >> The reason is that the rbd_add_acquire_lock() is interruptable,
> >> that means, when we kill the waiting on ->acquire_wait, the lock_dwork
> >> could be still running.
> >>
> >> 1. do_rbd_add()                                                 2. loc=
k_dwork
> >> rbd_add_acquire_lock()
> >>    - queue_delayed_work()
> >>                                                                  lock_=
dwork queued
> >>      - wait_for_completion_killable_timeout()  <-- kill happen
> >> rbd_dev_image_unlock()  <-- UNLOCKED now, nothing to do.
> >> rbd_dev_device_release()
> >> rbd_dev_image_release()
> >>    - ...
> >>                                                                  lock =
successed here
> >>       - cancel_delayed_work_sync(&rbd_dev->lock_dwork)
> >>
> >> Then when we reach the rbd_dev_free(), lock_state is not RBD_LOCK_STAT=
E_UNLOCKED.
> >>
> >> To fix it, this commit make sure the lock_dwork was finished before ca=
lling
> >> rbd_dev_image_unlock().
> >>
> >> On the other hand, this would not happend in do_rbd_remove(), because
> >> after rbd mapped, lock_dwork will only be queued for IO request, and
> >> request will continue unless lock_dwork finished. when we call
> >> rbd_dev_image_unlock() in do_rbd_remove(), all requests are done.
> >> that means, lock_state should not be locked again after rbd_dev_image_=
unlock().
> >>
> >> [1]:
> >> [  116.043632] rbd: rbd0: no lock owners detected
> >> [  117.745975] rbd: rbd0: failed to acquire exclusive lock: -512
> >> [  121.055286] rbd: image test: no lock owners detected
> >> [  126.066977] rbd: image test: no lock owners detected
> >> [  131.103870] rbd: image test: no lock owners detected
> >> [  132.360374] rbd: image test: no lock owners detected
> >> [  132.369202] rbd: image test: breaking header lock owned by client24=
204
> >> [  132.903969] rbd: image test: failed to unwatch: -512
> >> [  137.905601] ------------[ cut here ]------------
> >> [  137.906922] WARNING: CPU: 18 PID: 4545 at drivers/block/rbd.c:5576 =
rbd_dev_free+0xa5/0xc0 [rbd]
> >> [  137.908957] Modules linked in: nbd(OE) rbd(OE) libceph(OE) dns_reso=
lver tcp_diag udp_diag inet_diag unix_diag af_packet_diag netlink_diag sg c=
fg80211 rfkill snd_hda_codec_generic ledtrig_audio kvm_intel kvm irqbypass =
crct10dif_pclmul cirrus crc32_pclmul drm_kms_helper snd_hda_intel ghash_clm=
ulni_intel ext4 syscopyarea snd_hda_codec sysfillrect nfsd mbcache sysimgbl=
t snd_hda_core fb_sys_fops jbd2 drm snd_hwdep aesni_intel snd_seq crypto_si=
md cryptd glue_helper snd_seq_device auth_rpcgss snd_pcm nfs_acl snd_timer =
lockd i2c_piix4 snd i2c_core pcspkr virtio_balloon soundcore grace sunrpc i=
p_tables xfs libcrc32c virtio_console virtio_blk(O) 8139too ata_generic pat=
a_acpi serio_raw ata_piix libata virtio_pci crc32c_intel 8139cp virtio_ring=
 mii floppy(O) virtio dm_mirror dm_region_hash dm_log dm_mod dax [last unlo=
aded: libceph]
> >> [  137.926270] CPU: 18 PID: 4545 Comm: rbd Tainted: G           OE    =
 5.3.0-rc1+ #15
> >> [  137.928091] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), =
BIOS rel-1.11.2-0-gf9626ccb91-prebuilt.qemu-project.org 04/01/2014
> >> [  137.931081] RIP: 0010:rbd_dev_free+0xa5/0xc0 [rbd]
> >> [  137.932240] Code: 00 00 75 05 e8 1c ad ff ff 48 8b bb e0 00 00 00 e=
8 c0 99 ba e5 48 89 df 5b e9 b7 99 ba e5 48 c7 c7 98 90 6d c0 e8 69 20 a4 e=
5 <0f> 0b e9 75 ff ff ff 48 c7 c7 98 90 6d c0 e8 56 20 a4 e5 0f 0b e9
> >> [  137.936783] RSP: 0018:ffffb0f9c2f53dc8 EFLAGS: 00010282
> >> [  137.938161] RAX: 0000000000000024 RBX: ffff97f68636f000 RCX: 000000=
0000000000
> >> [  137.939922] RDX: 0000000000000000 RSI: ffff97f69fa97b18 RDI: ffff97=
f69fa97b18
> >> [  137.941673] RBP: ffff97f68636f000 R08: 0000000000000000 R09: 000000=
0000000000
> >> [  137.943469] R10: 0000000000000000 R11: 0000000000000000 R12: ffff97=
f68636f7c0
> >> [  137.944970] R13: ffff97f693dad270 R14: 0000000000000000 R15: ffff97=
f68fc76800
> >> [  137.946292] FS:  00007f3de0e7bb00(0000) GS:ffff97f69fa80000(0000) k=
nlGS:0000000000000000
> >> [  137.948207] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [  137.949720] CR2: 00007f1281623000 CR3: 00000007f0ec2005 CR4: 000000=
00000206e0
> >> [  137.951469] Call Trace:
> >> [  137.952417]  rbd_dev_release+0x41/0x60 [rbd]
> >> [  137.953651]  device_release+0x27/0x80
> >> [  137.954792]  kobject_release+0x68/0x190
> >> [  137.955954]  do_rbd_add.isra.67+0x970/0xf60 [rbd]
> >> [  137.957253]  kernfs_fop_write+0x109/0x190
> >> [  137.958484]  vfs_write+0xbe/0x1d0
> >> [  137.959566]  ksys_write+0xa4/0xe0
> >> [  137.960643]  do_syscall_64+0x60/0x270
> >> [  137.961749]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >> [  137.963119] RIP: 0033:0x7f3dd455469d
> >> [  137.964245] Code: cd 20 00 00 75 10 b8 01 00 00 00 0f 05 48 3d 01 f=
0 ff ff 73 31 c3 48 83 ec 08 e8 4e fd ff ff 48 89 04 24 b8 01 00 00 00 0f 0=
5 <48> 8b 3c 24 48 89 c2 e8 97 fd ff ff 48 89 d0 48 83 c4 08 48 3d 01
> >> [  137.968699] RSP: 002b:00007ffd91490010 EFLAGS: 00000293 ORIG_RAX: 0=
000000000000001
> >> [  137.970559] RAX: ffffffffffffffda RBX: 0000000000000086 RCX: 00007f=
3dd455469d
> >> [  137.972254] RDX: 0000000000000086 RSI: 000055790f5f5338 RDI: 000000=
0000000009
> >> [  137.974030] RBP: 00007ffd91490050 R08: 0000000000000004 R09: 000000=
000000004d
> >> [  137.975806] R10: 00007ffd9148fbe0 R11: 0000000000000293 R12: 000055=
790f5c8e58
> >> [  137.977528] R13: 000055790f3479b8 R14: 0000000000000001 R15: 000000=
0000000001
> >> [  137.979250] irq event stamp: 61780
> >> [  137.980421] hardirqs last  enabled at (61779): [<ffffffffa610f403>]=
 console_unlock+0x503/0x5f0
> >> [  137.982397] hardirqs last disabled at (61780): [<ffffffffa600379a>]=
 trace_hardirqs_off_thunk+0x1a/0x20
> >> [  137.984495] softirqs last  enabled at (61776): [<ffffffffa6c00343>]=
 __do_softirq+0x343/0x447
> >> [  137.986504] softirqs last disabled at (61769): [<ffffffffa609a1b7>]=
 irq_exit+0xe7/0xf0
> >> [  137.988417] ---[ end trace 10917ffd2e2f48ca ]---
> >>
> >> Signed-off-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
> >> ---
> >>   drivers/block/rbd.c | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> >> index 5bb98f5..44dd7a0 100644
> >> --- a/drivers/block/rbd.c
> >> +++ b/drivers/block/rbd.c
> >> @@ -7807,6 +7807,7 @@ static ssize_t do_rbd_add(struct bus_type *bus,
> >>          return rc;
> >>
> >>   err_out_image_lock:
> >> +       cancel_delayed_work_sync(&rbd_dev->lock_dwork);
> >>          rbd_dev_image_unlock(rbd_dev);
> >>          rbd_dev_device_release(rbd_dev);
> >>   err_out_image_probe:
> > Hi Dongsheng,
> >
> > I didn't pay much attention to the interrupt/timeout case because it
> > can't work properly with blocking lock, unlock, etc calls anyway.  That
> > said this is a valid race!
>
> Hi Ilya,
>      Yes, it can't solve the problem with blocking ceph_osdc_call(). As
> what we discussed, the better solution should be rbd-level timeout.
> But I found the warning in my testing, so I think we should fix it
> currently.
> >
> > I think it would be better to do that in rbd_add_acquire_lock(), only
> > if the wait is interrupted.  Please see the attachment.
>
> Looks good to me to avoid some unnecessary callings.
>
> Should I send a V2 for it? or you can fix it by yourself? Either is fine
> to me.

I'll amend it myself and queue it up for the next -rc.

Thanks,

                Ilya
