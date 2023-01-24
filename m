Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17281679820
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Jan 2023 13:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjAXMcY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Jan 2023 07:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbjAXMcX (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 24 Jan 2023 07:32:23 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEC7AA
        for <ceph-devel@vger.kernel.org>; Tue, 24 Jan 2023 04:32:20 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 12CEA1F45B;
        Tue, 24 Jan 2023 12:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674563539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUTyT/jMaphZhefINzBLarrrZoHSVShYdLUpKXHlHM4=;
        b=LBg7jd5iRMeN5Hzm9ukB25WvYTEP4x7j3XxA6qntP17TA/8+9JLBpQISDTj+a5Cj0fOEi1
        bZ2lJReHWGPfUyffrbOkfIAghMQg4B7xljVFsPlZSmjGIOZ+cr4Ki+i0f6pR3FZT7QmgN8
        bR/7UUWSk4nmSRgCKsk5X1VW+SYvhVs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674563539;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gUTyT/jMaphZhefINzBLarrrZoHSVShYdLUpKXHlHM4=;
        b=XG+TX2BXA1ZqxSG4OkZltESC8QFwn4LgmpY/Fly8uhQ/qry+EhobX3mOEhueFFXhiER1FV
        He2UKIe5AykFCVAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9FF65139FB;
        Tue, 24 Jan 2023 12:32:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K2IcJNLPz2OrQAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 24 Jan 2023 12:32:18 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 2c92b9f3;
        Tue, 24 Jan 2023 12:32:18 +0000 (UTC)
Date:   Tue, 24 Jan 2023 12:32:18 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com
Subject: Re: [PATCH v2] ceph: drop the messages from MDS when unmouting
Message-ID: <Y8/P0kg4VtC6UtD9@suse.de>
References: <20221221093031.132792-1-xiubli@redhat.com>
 <Y8lvXRmHKGdORhs5@suse.de>
 <Y8pus+5ZciJa/apW@suse.de>
 <cfd149ba-69cb-6514-db03-5cbd113bf5dc@redhat.com>
 <Y85eRQlbwt4Z4xko@suse.de>
 <e11c7958-62c6-d960-77db-e4fae33543e0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e11c7958-62c6-d960-77db-e4fae33543e0@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Jan 24, 2023 at 06:26:46PM +0800, Xiubo Li wrote:
> 
> On 23/01/2023 18:15, Luís Henriques wrote:
> > On Sun, Jan 22, 2023 at 09:57:46PM +0800, Xiubo Li wrote:
> > > Hi Luis,
> > > 
> > > On 20/01/2023 18:36, Luís Henriques wrote:
> > > > On Thu, Jan 19, 2023 at 04:27:09PM +0000, Luís Henriques wrote:
> > > > > On Wed, Dec 21, 2022 at 05:30:31PM +0800, xiubli@redhat.com wrote:
> > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > > 
> > > > > > When unmounting it will just wait for the inflight requests to be
> > > > > > finished, but just before the sessions are closed the kclient still
> > > > > > could receive the caps/snaps/lease/quota msgs from MDS. All these
> > > > > > msgs need to hold some inodes, which will cause ceph_kill_sb() failing
> > > > > > to evict the inodes in time.
> > > > > > 
> > > > > > If encrypt is enabled the kernel generate a warning when removing
> > > > > > the encrypt keys when the skipped inodes still hold the keyring:
> > > > > Finally (sorry for the delay!) I managed to look into the 6.1 rebase.  It
> > > > > does look good, but I started hitting the WARNING added by patch:
> > > > > 
> > > > >     [DO NOT MERGE] ceph: make sure all the files successfully put before unmounting
> > > > > 
> > > > > This patch seems to be working but I'm not sure we really need the extra
> > > > OK, looks like I jumped the gun here: I still see the warning with your
> > > > patch.
> > > > 
> > > > I've done a quick hack and the patch below sees fix it.  But again, it
> > > > will impact performance.  I'll see if I can figure out something else.
> > > > 
> > > > Cheers,
> > > > --
> > > > Luís
> > > > 
> > > > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > > > index 2cd134ad02a9..bdb4efa0f9f7 100644
> > > > --- a/fs/ceph/file.c
> > > > +++ b/fs/ceph/file.c
> > > > @@ -2988,6 +2988,21 @@ static ssize_t ceph_copy_file_range(struct file *src_file, loff_t src_off,
> > > >    	return ret;
> > > >    }
> > > > +static int ceph_flush(struct file *file, fl_owner_t id)
> > > > +{
> > > > +	struct inode *inode = file_inode(file);
> > > > +	int ret;
> > > > +
> > > > +	if ((file->f_mode & FMODE_WRITE) == 0)
> > > > +		return 0;
> > > > +
> > > > +	ret = filemap_write_and_wait(inode->i_mapping);
> > > > +	if (ret)
> > > > +		ret = filemap_check_wb_err(file->f_mapping, 0);
> > > > +
> > > > +	return ret;
> > > > +}
> > > > +
> > > >    const struct file_operations ceph_file_fops = {
> > > >    	.open = ceph_open,
> > > >    	.release = ceph_release,
> > > > @@ -3005,4 +3020,5 @@ const struct file_operations ceph_file_fops = {
> > > >    	.compat_ioctl = compat_ptr_ioctl,
> > > >    	.fallocate	= ceph_fallocate,
> > > >    	.copy_file_range = ceph_copy_file_range,
> > > > +	.flush = ceph_flush,
> > > >    };
> > > > 
> > > This will only fix the second crash case in
> > > https://tracker.ceph.com/issues/58126#note-6, but not the case in
> > > https://tracker.ceph.com/issues/58126#note-5.
> > > 
> > > This issue could be triggered with "test_dummy_encryption" and with
> > > xfstests-dev's generic/124. You can have a try.
> > OK, thanks.  I'll give it a try.  BTW, my local reproducer was
> > generic/132, not generic/124.  I'll let you know if I find something.
> 
> Hi Luis,
> 
> I added some logs and found that when doing the aio_write, it will split to
> many aio requests and when the last req finished it will call the
> "writepages_finish()", which will iput() the inode and release the last
> refcount of the inode.
> 
> But it seems the complete_all() is called without the req->r_callback() is
> totally finished:
> 
> <4>[500400.268200] writepages_finish 0000000060940222 rc 0
> <4>[500400.268476] writepages_finish 0000000060940222 rc 0 <===== the last
> osd req->r_callback()
> <4>[500400.268515] sync_fs (blocking)  <===== unmounting begin
> <4>[500400.268526] sync_fs (blocking) done
> <4>[500400.268530] kill_sb after sync_filesystem 00000000a01a1cf4   <=== the
> sync_filesystem() will be called, I just added it in ceph code but the VFS
> will call it again in "kill_anon_super()"
> <4>[500400.268539] ceph_evict_inode:682, dec inode 0000000044f12aa7
> <4>[500400.268626] sync_fs (blocking)
> <4>[500400.268631] sync_fs (blocking) done
> <4>[500400.268634] evict_inodes inode 0000000060940222, i_count = 1, was
> skipped!    <=== skipped
> <4>[500400.268642] fscrypt_destroy_keyring: mk 00000000baf04977
> mk_active_refs = 2
> <4>[500400.268651] ceph_evict_inode:682, dec inode 0000000060940222   <====
> evict the inode in the req->r_callback()
> 
> Locally my VM is not working and I couldn't run the test for now. Could you
> help test the following patch ?

So, running generic/132 in my test environment with your patch applied to
the 'testing' branch I still see the WARNING (pasted the backtrace
bellow).  I'll try help to dig a bit more on this issue in the next few
days.

Cheers,
--
Luís


[  102.713299] ceph: test_dummy_encryption mode enabled
[  121.807203] evict_inodes inode 000000000d85998d, i_count = 1, was skipped!
[  121.809055] fscrypt_destroy_keyring: mk_active_refs = 2
[  121.810439] ------------[ cut here ]------------
[  121.811937] WARNING: CPU: 1 PID: 2671 at fs/crypto/keyring.c:244 fscrypt_destroy_keyring+0x109/0x110
[  121.814243] CPU: 1 PID: 2671 Comm: umount Not tainted 6.2.0-rc2+ #23
[  121.815810] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552-rebuilt.opensuse.org 04/01/2014
[  121.818588] RIP: 0010:fscrypt_destroy_keyring+0x109/0x110
[  121.819925] Code: 00 00 48 83 c4 10 5b 5d 41 5c 41 5d 41 5e 41 5f c3 41 8b 77 38 48 c7 c7 18 40 c0 81 e8 e2 b2 51 00 41 8b 47 38 83 f8 01 74 9e <0f> 0b eb 9a 0f 1f 00 0f0
[  121.824469] RSP: 0018:ffffc900039f3e20 EFLAGS: 00010202
[  121.825908] RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000001
[  121.827660] RDX: 0000000000000000 RSI: ffff88842fc9b180 RDI: 00000000ffffffff
[  121.829425] RBP: ffff888102a99000 R08: 0000000000000000 R09: c0000000ffffefff
[  121.831188] R10: ffffc90000093e00 R11: ffffc900039f3cd8 R12: 0000000000000000
[  121.833408] R13: ffff888102a9a948 R14: ffffffff823a66b0 R15: ffff8881048f6c00
[  121.835186] FS:  00007f2442206840(0000) GS:ffff88842fc80000(0000) knlGS:0000000000000000
[  121.838205] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  121.840386] CR2: 00007f0a289daf70 CR3: 000000011446a000 CR4: 00000000000006a0
[  121.842190] Call Trace:
[  121.843125]  <TASK>
[  121.843945]  generic_shutdown_super+0x42/0x130
[  121.845656]  kill_anon_super+0xe/0x30
[  121.847081]  ceph_kill_sb+0x3d/0xa0
[  121.848418]  deactivate_locked_super+0x34/0x60
[  121.850166]  cleanup_mnt+0xb8/0x150
[  121.851498]  task_work_run+0x61/0x90
[  121.852863]  exit_to_user_mode_prepare+0x147/0x170
[  121.854741]  syscall_exit_to_user_mode+0x20/0x40
[  121.856489]  do_syscall_64+0x48/0x80
[  121.857887]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  121.859659] RIP: 0033:0x7f2442444a67
[  121.860922] Code: 24 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 018
[  121.866942] RSP: 002b:00007ffc56533fc8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[  121.869305] RAX: 0000000000000000 RBX: 00007f2442579264 RCX: 00007f2442444a67
[  121.871400] RDX: ffffffffffffff78 RSI: 0000000000000000 RDI: 00005612dcd02b10
[  121.873512] RBP: 00005612dccfd960 R08: 0000000000000000 R09: 00007f2442517be0
[  121.875492] R10: 00005612dcd03ea0 R11: 0000000000000246 R12: 0000000000000000
[  121.877448] R13: 00005612dcd02b10 R14: 00005612dccfda70 R15: 00005612dccfdb90
[  121.879418]  </TASK>
[  121.880039] ---[ end trace 0000000000000000 ]---


> 
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index 78b622178a3d..5cdaba0d3003 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -2539,6 +2539,7 @@ static void __complete_request(struct ceph_osd_request
> *req)
> 
>         if (req->r_callback)
>                 req->r_callback(req);
> +       barrier();
>         complete_all(&req->r_completion);
>         ceph_osdc_put_request(req);
>  }
> 
> Thanks
> 
> - Xiubo
> 
> 
> > > Locally I am still reading the code to check why "sync_filesystem(s);"
> > > couldn't do the same with "ceph_flush" as above.
> > > 
> > > I am still on holiday these days and I will test this after my back.
> > Sure, no problem.  Enjoy your break!
> > 
> > Cheers,
> > --
> > Luís
> > 
> > > Thanks
> > > 
> > > 
> > > > > 'stopping' state.  Looking at the code, we've flushed all the workqueues
> > > > > and done all the waits, so I *think* the sync_filesystem() call should be
> > > > > enough.
> > > > > 
> > > > > The other alternative I see would be to add a ->flush() to ceph_file_fops,
> > > > > where we'd do a filemap_write_and_wait().  But that would probably have a
> > > > > negative performance impact -- my understand is that it basically means
> > > > > we'll have sync file closes.
> > > > > 
> > > > > Cheers,
> > > > > --
> > > > > Luís
> > > > > 
> > > > > > WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
> > > > > > CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
> > > > > > Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
> > > > > > RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
> > > > > > RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
> > > > > > RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
> > > > > > RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
> > > > > > RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
> > > > > > R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
> > > > > > R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
> > > > > > FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
> > > > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > > > CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
> > > > > > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > > > > > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > > > > > Call Trace:
> > > > > > <TASK>
> > > > > > generic_shutdown_super+0x47/0x120
> > > > > > kill_anon_super+0x14/0x30
> > > > > > ceph_kill_sb+0x36/0x90 [ceph]
> > > > > > deactivate_locked_super+0x29/0x60
> > > > > > cleanup_mnt+0xb8/0x140
> > > > > > task_work_run+0x67/0xb0
> > > > > > exit_to_user_mode_prepare+0x23d/0x240
> > > > > > syscall_exit_to_user_mode+0x25/0x60
> > > > > > do_syscall_64+0x40/0x80
> > > > > > entry_SYSCALL_64_after_hwframe+0x63/0xcd
> > > > > > RIP: 0033:0x7fd83dc39e9b
> > > > > > 
> > > > > > URL: https://tracker.ceph.com/issues/58126
> > > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > > ---
> > > > > > 
> > > > > > V2:
> > > > > > - Fix it in ceph layer.
> > > > > > 
> > > > > > 
> > > > > >    fs/ceph/caps.c       |  3 +++
> > > > > >    fs/ceph/mds_client.c |  5 ++++-
> > > > > >    fs/ceph/mds_client.h |  7 ++++++-
> > > > > >    fs/ceph/quota.c      |  3 +++
> > > > > >    fs/ceph/snap.c       |  3 +++
> > > > > >    fs/ceph/super.c      | 14 ++++++++++++++
> > > > > >    6 files changed, 33 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > > > > index 15d9e0f0d65a..e8a53aeb2a8c 100644
> > > > > > --- a/fs/ceph/caps.c
> > > > > > +++ b/fs/ceph/caps.c
> > > > > > @@ -4222,6 +4222,9 @@ void ceph_handle_caps(struct ceph_mds_session *session,
> > > > > >    	dout("handle_caps from mds%d\n", session->s_mds);
> > > > > > +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> > > > > > +		return;
> > > > > > +
> > > > > >    	/* decode */
> > > > > >    	end = msg->front.iov_base + msg->front.iov_len;
> > > > > >    	if (msg->front.iov_len < sizeof(*h))
> > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > index d41ab68f0130..1ad85af49b45 100644
> > > > > > --- a/fs/ceph/mds_client.c
> > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > @@ -4869,6 +4869,9 @@ static void handle_lease(struct ceph_mds_client *mdsc,
> > > > > >    	dout("handle_lease from mds%d\n", mds);
> > > > > > +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> > > > > > +		return;
> > > > > > +
> > > > > >    	/* decode */
> > > > > >    	if (msg->front.iov_len < sizeof(*h) + sizeof(u32))
> > > > > >    		goto bad;
> > > > > > @@ -5262,7 +5265,7 @@ void send_flush_mdlog(struct ceph_mds_session *s)
> > > > > >    void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
> > > > > >    {
> > > > > >    	dout("pre_umount\n");
> > > > > > -	mdsc->stopping = 1;
> > > > > > +	mdsc->stopping = CEPH_MDSC_STOPPING_BEGAIN;
> > > > > >    	ceph_mdsc_iterate_sessions(mdsc, send_flush_mdlog, true);
> > > > > >    	ceph_mdsc_iterate_sessions(mdsc, lock_unlock_session, false);
> > > > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > > > index 81a1f9a4ac3b..56f9d8077068 100644
> > > > > > --- a/fs/ceph/mds_client.h
> > > > > > +++ b/fs/ceph/mds_client.h
> > > > > > @@ -398,6 +398,11 @@ struct cap_wait {
> > > > > >    	int			want;
> > > > > >    };
> > > > > > +enum {
> > > > > > +	CEPH_MDSC_STOPPING_BEGAIN = 1,
> > > > > > +	CEPH_MDSC_STOPPING_FLUSHED = 2,
> > > > > > +};
> > > > > > +
> > > > > >    /*
> > > > > >     * mds client state
> > > > > >     */
> > > > > > @@ -414,7 +419,7 @@ struct ceph_mds_client {
> > > > > >    	struct ceph_mds_session **sessions;    /* NULL for mds if no session */
> > > > > >    	atomic_t		num_sessions;
> > > > > >    	int                     max_sessions;  /* len of sessions array */
> > > > > > -	int                     stopping;      /* true if shutting down */
> > > > > > +	int                     stopping;      /* the stage of shutting down */
> > > > > >    	atomic64_t		quotarealms_count; /* # realms with quota */
> > > > > >    	/*
> > > > > > diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> > > > > > index 64592adfe48f..f5819fc31d28 100644
> > > > > > --- a/fs/ceph/quota.c
> > > > > > +++ b/fs/ceph/quota.c
> > > > > > @@ -47,6 +47,9 @@ void ceph_handle_quota(struct ceph_mds_client *mdsc,
> > > > > >    	struct inode *inode;
> > > > > >    	struct ceph_inode_info *ci;
> > > > > > +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> > > > > > +		return;
> > > > > > +
> > > > > >    	if (msg->front.iov_len < sizeof(*h)) {
> > > > > >    		pr_err("%s corrupt message mds%d len %d\n", __func__,
> > > > > >    		       session->s_mds, (int)msg->front.iov_len);
> > > > > > diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> > > > > > index a73943e51a77..eeabdd0211d8 100644
> > > > > > --- a/fs/ceph/snap.c
> > > > > > +++ b/fs/ceph/snap.c
> > > > > > @@ -1010,6 +1010,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
> > > > > >    	int locked_rwsem = 0;
> > > > > >    	bool close_sessions = false;
> > > > > > +	if (mdsc->stopping >= CEPH_MDSC_STOPPING_FLUSHED)
> > > > > > +		return;
> > > > > > +
> > > > > >    	/* decode */
> > > > > >    	if (msg->front.iov_len < sizeof(*h))
> > > > > >    		goto bad;
> > > > > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > > > > index f10a076f47e5..012b35be41a9 100644
> > > > > > --- a/fs/ceph/super.c
> > > > > > +++ b/fs/ceph/super.c
> > > > > > @@ -1483,6 +1483,20 @@ static void ceph_kill_sb(struct super_block *s)
> > > > > >    	ceph_mdsc_pre_umount(fsc->mdsc);
> > > > > >    	flush_fs_workqueues(fsc);
> > > > > > +	/*
> > > > > > +	 * Though the kill_anon_super() will finally trigger the
> > > > > > +	 * sync_filesystem() anyway, we still need to do it here and
> > > > > > +	 * then bump the stage of shutdown. This will drop any further
> > > > > > +	 * message, which makes no sense any more, from MDSs.
> > > > > > +	 *
> > > > > > +	 * Without this when evicting the inodes it may fail in the
> > > > > > +	 * kill_anon_super(), which will trigger a warning when
> > > > > > +	 * destroying the fscrypt keyring and then possibly trigger
> > > > > > +	 * a further crash in ceph module when iput() the inodes.
> > > > > > +	 */
> > > > > > +	sync_filesystem(s);
> > > > > > +	fsc->mdsc->stopping = CEPH_MDSC_STOPPING_FLUSHED;
> > > > > > +
> > > > > >    	kill_anon_super(s);
> > > > > >    	fsc->client->extra_mon_dispatch = NULL;
> > > > > > -- 
> > > > > > 2.31.1
> > > > > > 
> > > -- 
> > > Best Regards,
> > > 
> > > Xiubo Li (李秀波)
> > > 
> > > Email: xiubli@redhat.com/xiubli@ibm.com
> > > Slack: @Xiubo Li
> > > 
> -- 
> Best Regards,
> 
> Xiubo Li (李秀波)
> 
> Email: xiubli@redhat.com/xiubli@ibm.com
> Slack: @Xiubo Li
> 
