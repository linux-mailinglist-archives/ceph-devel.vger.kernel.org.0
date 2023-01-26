Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1767CD3E
	for <lists+ceph-devel@lfdr.de>; Thu, 26 Jan 2023 15:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjAZOEo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 26 Jan 2023 09:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjAZOEn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 26 Jan 2023 09:04:43 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B8E86A0
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 06:04:35 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ud5so5321562ejc.4
        for <ceph-devel@vger.kernel.org>; Thu, 26 Jan 2023 06:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NQKesxhtFFA+DedOT8l+I42EcEHGIZfyXmbDt1rZ1Ag=;
        b=MW0pEfiAS2pNX5GUv6QrUBTM8FqyLm4FD0hLyPoHQQn8k9NDSAHgJLXDDIANItLMoX
         KIyDbZzOniTabA8H73/N7l31tgqdNwoTDAA/PfbKRVFXV0pOym93PvqQpcaIyyeqKWEc
         OXAzN/yMARz5ucFTgEt2CSRGmGMdExzBzqn5EjLpBv14xexMoLqb++BKr8sA1JQhhi8A
         851ZdrWSRRh+P7yvMX0hGnVLXjLCgu2MuzF7bB8eaa5hyDc5/kIt37tQvXumLepo6KJn
         cQZe/H4srRuz3OzTgSIvBmw5MnZKYxSMNn9AzQoHN5WC8iupHpwvDdsHyzUqa3EnSS2N
         NqIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NQKesxhtFFA+DedOT8l+I42EcEHGIZfyXmbDt1rZ1Ag=;
        b=E9fdj8R75kJtSncmlt/6lM1LLZ9+ZCGYudNEjR+0RCs7CXA3PXCTvYbyF6CWGAdTUs
         8Of8oNnaTx/tWNwwAFYtbb4aTD432fzxb+Dm3LYffPiuzKsfqkbHFgIojAorQ5TMd72h
         RbddM9DCy5ow1lLHCpk4y8+G5znCqPVXDTcKBq34jOcxX+8c1wU2REo0Wd70S7qfJKk0
         N+Rf8ZoUWqJG5etd32HM9goiSS52yTlKpjHV+e0trztY9ITy0US1OCRc/Ue8mDezau8J
         oVA0sJiE50BYTon/2BaMT5AvhiA++RChefSdixVw4EUtOzFRWoNK5aVI6ARR3op0E9ia
         mn3A==
X-Gm-Message-State: AFqh2kqrusF0m40L/0iZgceRhYZPAVZ2EEy4ofOHYh1GpVVNnGReDJYC
        yMizsGK9mGYaOHR0OB1fqyivqboK4TJLDXYPH/E=
X-Google-Smtp-Source: AMrXdXvc2+Hz+/L2dW4cGxS2AkgOHc0NwYn+jAhHpdifEs3kDdYi8HLsmb0HOVjjeYed+SdCbMnZgZ6NfagTeZ8qZp8=
X-Received: by 2002:a17:906:c02:b0:864:524c:e39b with SMTP id
 s2-20020a1709060c0200b00864524ce39bmr6098286ejf.207.1674741873631; Thu, 26
 Jan 2023 06:04:33 -0800 (PST)
MIME-Version: 1.0
References: <20221221093031.132792-1-xiubli@redhat.com> <Y8lvXRmHKGdORhs5@suse.de>
 <Y8pus+5ZciJa/apW@suse.de> <cfd149ba-69cb-6514-db03-5cbd113bf5dc@redhat.com>
 <Y85eRQlbwt4Z4xko@suse.de> <e11c7958-62c6-d960-77db-e4fae33543e0@redhat.com>
 <Y8/P0kg4VtC6UtD9@suse.de> <85021e1d-6668-47cf-e1b6-6cde8d0fe46d@redhat.com>
In-Reply-To: <85021e1d-6668-47cf-e1b6-6cde8d0fe46d@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 26 Jan 2023 15:04:21 +0100
Message-ID: <CAOi1vP8DtKgsuDjzu7otp2HB41nbtUAydfcpNzJQUCk=V_xaUw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: drop the messages from MDS when unmouting
To:     Xiubo Li <xiubli@redhat.com>
Cc:     =?UTF-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>,
        ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jan 26, 2023 at 2:03 PM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 24/01/2023 20:32, Lu=C3=ADs Henriques wrote:
> > On Tue, Jan 24, 2023 at 06:26:46PM +0800, Xiubo Li wrote:
> >> On 23/01/2023 18:15, Lu=C3=ADs Henriques wrote:
> >>> On Sun, Jan 22, 2023 at 09:57:46PM +0800, Xiubo Li wrote:
> >>>> Hi Luis,
> >>>>
> >>>> On 20/01/2023 18:36, Lu=C3=ADs Henriques wrote:
> >>>>> On Thu, Jan 19, 2023 at 04:27:09PM +0000, Lu=C3=ADs Henriques wrote=
:
> >>>>>> On Wed, Dec 21, 2022 at 05:30:31PM +0800, xiubli@redhat.com wrote:
> >>>>>>> From: Xiubo Li <xiubli@redhat.com>
> >>>>>>>
> >>>>>>> When unmounting it will just wait for the inflight requests to be
> >>>>>>> finished, but just before the sessions are closed the kclient sti=
ll
> >>>>>>> could receive the caps/snaps/lease/quota msgs from MDS. All these
> >>>>>>> msgs need to hold some inodes, which will cause ceph_kill_sb() fa=
iling
> >>>>>>> to evict the inodes in time.
> >>>>>>>
> >>>>>>> If encrypt is enabled the kernel generate a warning when removing
> >>>>>>> the encrypt keys when the skipped inodes still hold the keyring:
> >>>>>> Finally (sorry for the delay!) I managed to look into the 6.1 reba=
se.  It
> >>>>>> does look good, but I started hitting the WARNING added by patch:
> >>>>>>
> >>>>>>      [DO NOT MERGE] ceph: make sure all the files successfully put=
 before unmounting
> >>>>>>
> >>>>>> This patch seems to be working but I'm not sure we really need the=
 extra
> >>>>> OK, looks like I jumped the gun here: I still see the warning with =
your
> >>>>> patch.
> >>>>>
> >>>>> I've done a quick hack and the patch below sees fix it.  But again,=
 it
> >>>>> will impact performance.  I'll see if I can figure out something el=
se.
> >>>>>
> >>>>> Cheers,
> >>>>> --
> >>>>> Lu=C3=ADs
> >>>>>
> >>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> >>>>> index 2cd134ad02a9..bdb4efa0f9f7 100644
> >>>>> --- a/fs/ceph/file.c
> >>>>> +++ b/fs/ceph/file.c
> >>>>> @@ -2988,6 +2988,21 @@ static ssize_t ceph_copy_file_range(struct f=
ile *src_file, loff_t src_off,
> >>>>>           return ret;
> >>>>>     }
> >>>>> +static int ceph_flush(struct file *file, fl_owner_t id)
> >>>>> +{
> >>>>> + struct inode *inode =3D file_inode(file);
> >>>>> + int ret;
> >>>>> +
> >>>>> + if ((file->f_mode & FMODE_WRITE) =3D=3D 0)
> >>>>> +         return 0;
> >>>>> +
> >>>>> + ret =3D filemap_write_and_wait(inode->i_mapping);
> >>>>> + if (ret)
> >>>>> +         ret =3D filemap_check_wb_err(file->f_mapping, 0);
> >>>>> +
> >>>>> + return ret;
> >>>>> +}
> >>>>> +
> >>>>>     const struct file_operations ceph_file_fops =3D {
> >>>>>           .open =3D ceph_open,
> >>>>>           .release =3D ceph_release,
> >>>>> @@ -3005,4 +3020,5 @@ const struct file_operations ceph_file_fops =
=3D {
> >>>>>           .compat_ioctl =3D compat_ptr_ioctl,
> >>>>>           .fallocate      =3D ceph_fallocate,
> >>>>>           .copy_file_range =3D ceph_copy_file_range,
> >>>>> + .flush =3D ceph_flush,
> >>>>>     };
> >>>>>
> >>>> This will only fix the second crash case in
> >>>> https://tracker.ceph.com/issues/58126#note-6, but not the case in
> >>>> https://tracker.ceph.com/issues/58126#note-5.
> >>>>
> >>>> This issue could be triggered with "test_dummy_encryption" and with
> >>>> xfstests-dev's generic/124. You can have a try.
> >>> OK, thanks.  I'll give it a try.  BTW, my local reproducer was
> >>> generic/132, not generic/124.  I'll let you know if I find something.
> >> Hi Luis,
> >>
> >> I added some logs and found that when doing the aio_write, it will spl=
it to
> >> many aio requests and when the last req finished it will call the
> >> "writepages_finish()", which will iput() the inode and release the las=
t
> >> refcount of the inode.
> >>
> >> But it seems the complete_all() is called without the req->r_callback(=
) is
> >> totally finished:
> >>
> >> <4>[500400.268200] writepages_finish 0000000060940222 rc 0
> >> <4>[500400.268476] writepages_finish 0000000060940222 rc 0 <=3D=3D=3D=
=3D=3D the last
> >> osd req->r_callback()
> >> <4>[500400.268515] sync_fs (blocking)  <=3D=3D=3D=3D=3D unmounting beg=
in
> >> <4>[500400.268526] sync_fs (blocking) done
> >> <4>[500400.268530] kill_sb after sync_filesystem 00000000a01a1cf4   <=
=3D=3D=3D the
> >> sync_filesystem() will be called, I just added it in ceph code but the=
 VFS
> >> will call it again in "kill_anon_super()"
> >> <4>[500400.268539] ceph_evict_inode:682, dec inode 0000000044f12aa7
> >> <4>[500400.268626] sync_fs (blocking)
> >> <4>[500400.268631] sync_fs (blocking) done
> >> <4>[500400.268634] evict_inodes inode 0000000060940222, i_count =3D 1,=
 was
> >> skipped!    <=3D=3D=3D skipped
> >> <4>[500400.268642] fscrypt_destroy_keyring: mk 00000000baf04977
> >> mk_active_refs =3D 2
> >> <4>[500400.268651] ceph_evict_inode:682, dec inode 0000000060940222   =
<=3D=3D=3D=3D
> >> evict the inode in the req->r_callback()
> >>
> >> Locally my VM is not working and I couldn't run the test for now. Coul=
d you
> >> help test the following patch ?
> > So, running generic/132 in my test environment with your patch applied =
to
> > the 'testing' branch I still see the WARNING (pasted the backtrace
> > bellow).  I'll try help to dig a bit more on this issue in the next few
> > days.
> >
> > Cheers,
> > --
> > Lu=C3=ADs
> >
> >
> > [  102.713299] ceph: test_dummy_encryption mode enabled
> > [  121.807203] evict_inodes inode 000000000d85998d, i_count =3D 1, was =
skipped!
> > [  121.809055] fscrypt_destroy_keyring: mk_active_refs =3D 2
> > [  121.810439] ------------[ cut here ]------------
> > [  121.811937] WARNING: CPU: 1 PID: 2671 at fs/crypto/keyring.c:244 fsc=
rypt_destroy_keyring+0x109/0x110
> > [  121.814243] CPU: 1 PID: 2671 Comm: umount Not tainted 6.2.0-rc2+ #23
> > [  121.815810] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS rel-1.16.0-0-gd239552-rebuilt.opensuse.org 04/01/2014
> > [  121.818588] RIP: 0010:fscrypt_destroy_keyring+0x109/0x110
> > [  121.819925] Code: 00 00 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3=
 41 8b 77 38 48 c7 c7 18 40 c0 81 e8 e2 b2 51 00 41 8b 47 38 83 f8 01 74 9e=
 <0f> 0b eb 9a 0f 1f 00 0f0
> > [  121.824469] RSP: 0018:ffffc900039f3e20 EFLAGS: 00010202
> > [  121.825908] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000=
000000001
> > [  121.827660] RDX: 0000000000000000 RSI: ffff88842fc9b180 RDI: 0000000=
0ffffffff
> > [  121.829425] RBP: ffff888102a99000 R08: 0000000000000000 R09: c000000=
0ffffefff
> > [  121.831188] R10: ffffc90000093e00 R11: ffffc900039f3cd8 R12: 0000000=
000000000
> > [  121.833408] R13: ffff888102a9a948 R14: ffffffff823a66b0 R15: ffff888=
1048f6c00
> > [  121.835186] FS:  00007f2442206840(0000) GS:ffff88842fc80000(0000) kn=
lGS:0000000000000000
> > [  121.838205] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  121.840386] CR2: 00007f0a289daf70 CR3: 000000011446a000 CR4: 0000000=
0000006a0
> > [  121.842190] Call Trace:
> > [  121.843125]  <TASK>
> > [  121.843945]  generic_shutdown_super+0x42/0x130
> > [  121.845656]  kill_anon_super+0xe/0x30
> > [  121.847081]  ceph_kill_sb+0x3d/0xa0
> > [  121.848418]  deactivate_locked_super+0x34/0x60
> > [  121.850166]  cleanup_mnt+0xb8/0x150
> > [  121.851498]  task_work_run+0x61/0x90
> > [  121.852863]  exit_to_user_mode_prepare+0x147/0x170
> > [  121.854741]  syscall_exit_to_user_mode+0x20/0x40
> > [  121.856489]  do_syscall_64+0x48/0x80
> > [  121.857887]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > [  121.859659] RIP: 0033:0x7f2442444a67
> > [  121.860922] Code: 24 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44=
 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05=
 <48> 3d 01 f0 ff ff 73 018
> > [  121.866942] RSP: 002b:00007ffc56533fc8 EFLAGS: 00000246 ORIG_RAX: 00=
000000000000a6
> > [  121.869305] RAX: 0000000000000000 RBX: 00007f2442579264 RCX: 00007f2=
442444a67
> > [  121.871400] RDX: ffffffffffffff78 RSI: 0000000000000000 RDI: 0000561=
2dcd02b10
> > [  121.873512] RBP: 00005612dccfd960 R08: 0000000000000000 R09: 00007f2=
442517be0
> > [  121.875492] R10: 00005612dcd03ea0 R11: 0000000000000246 R12: 0000000=
000000000
> > [  121.877448] R13: 00005612dcd02b10 R14: 00005612dccfda70 R15: 0000561=
2dccfdb90
> > [  121.879418]  </TASK>
> > [  121.880039] ---[ end trace 0000000000000000 ]---
> >
> Okay.
>
> I found the sync_filesystem() will wait for the last the osd request,
> but the sequence of deleting the osd req from osdc and calling
> req->r_callback seems incorrect.
>
> The following patch should fix it:
>
>
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 78b622178a3d..a3b4c5cabb80 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -2532,12 +2532,12 @@ static void finish_request(struct
> ceph_osd_request *req)
>          ceph_msg_revoke_incoming(req->r_reply);
>   }
>
> -static void __complete_request(struct ceph_osd_request *req)
> +static void __complete_request(struct ceph_osd_request *req, bool callba=
ck)
>   {
>          dout("%s req %p tid %llu cb %ps result %d\n", __func__, req,
>               req->r_tid, req->r_callback, req->r_result);
>
> -       if (req->r_callback)
> +       if (callback && req->r_callback)
>                  req->r_callback(req);
>          complete_all(&req->r_completion);
>          ceph_osdc_put_request(req);
> @@ -2548,7 +2548,7 @@ static void complete_request_workfn(struct
> work_struct *work)
>          struct ceph_osd_request *req =3D
>              container_of(work, struct ceph_osd_request, r_complete_work)=
;
>
> -       __complete_request(req);
> +       __complete_request(req, true);
>   }
>
>   /*
> @@ -3873,11 +3873,13 @@ static void handle_reply(struct ceph_osd *osd,
> struct ceph_msg *msg)
>          WARN_ON(!(m.flags & CEPH_OSD_FLAG_ONDISK));
>          req->r_version =3D m.user_version;
>          req->r_result =3D m.result ?: data_len;
> +       if (req->r_callback)
> +               req->r_callback(req);
>          finish_request(req);
>          mutex_unlock(&osd->lock);
>          up_read(&osdc->lock);
>
> -       __complete_request(req);
> +       __complete_request(req, false);

Hi Xiubo,

I haven't looked into the actual problem that you trying to fix here
but this patch seems wrong and very unlikely to fly.  The messenger
invokes the OSD request callback outside of osd->lock and osdc->lock
critical sections on purpose to avoid deadlocks.  This goes way back
and also consistent with how Objecter behaves in userspace.

Thanks,

                Ilya
