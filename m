Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80CB720064
	for <lists+ceph-devel@lfdr.de>; Fri,  2 Jun 2023 13:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbjFBL3L (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 2 Jun 2023 07:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbjFBL3J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 2 Jun 2023 07:29:09 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3144018D
        for <ceph-devel@vger.kernel.org>; Fri,  2 Jun 2023 04:29:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DD098219C0;
        Fri,  2 Jun 2023 11:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685705343; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3cQemi/hZbgOkG0vXAGOt6AVF3wcgFqWb6H7xd3WlY=;
        b=pzOjwNnzgGuAsSqVVdPfEIFLcyUyfSshsAzF74fSq3Nb0VP1MFOYMHfgIIsrYb9OSqd86s
        m8x853reo2lrwVzqg6CVSmjNpnV2AnGggYHNR3kT213JerTO4pl2Kl/ktFkO5FRsegoJIX
        C2Pi4Pqtb4tUNN+LABXyKpokq72w39Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685705343;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u3cQemi/hZbgOkG0vXAGOt6AVF3wcgFqWb6H7xd3WlY=;
        b=5GoGhgi3XNjq15pDLuj+zPjkdsO4wagAlQNu9nYLH1ewKGUYxJH23kExZPFr6xNBWHFfB4
        OmAfldCvD6oDOWCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84971133E6;
        Fri,  2 Jun 2023 11:29:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id yXl+HX/SeWSJdgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 02 Jun 2023 11:29:03 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d499d94d;
        Fri, 2 Jun 2023 11:29:02 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com
Subject: Re: [PATCH] ceph: just wait the osd requests' callbacks to finish
 when unmounting
References: <20230509084637.213326-1-xiubli@redhat.com>
Date:   Fri, 02 Jun 2023 12:29:02 +0100
In-Reply-To: <20230509084637.213326-1-xiubli@redhat.com> (xiubli@redhat.com's
        message of "Tue, 9 May 2023 16:46:37 +0800")
Message-ID: <871qiu2jcx.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

xiubli@redhat.com writes:

> From: Xiubo Li <xiubli@redhat.com>
>
> The sync_filesystem() will flush all the dirty buffer and submit the
> osd reqs to the osdc and then is blocked to wait for all the reqs to
> finish. But the when the reqs' replies come, the reqs will be removed
> from osdc just before the req->r_callback()s are called. Which means
> the sync_filesystem() will be woke up by leaving the req->r_callback()s
> are still running.
>
> This will be buggy when the waiter require the req->r_callback()s to
> release some resources before continuing. So we need to make sure the
> req->r_callback()s are called before removing the reqs from the osdc.
>
> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_ke=
yring+0x7e/0xd0
> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864=
c #1
> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> generic_shutdown_super+0x47/0x120
> kill_anon_super+0x14/0x30
> ceph_kill_sb+0x36/0x90 [ceph]
> deactivate_locked_super+0x29/0x60
> cleanup_mnt+0xb8/0x140
> task_work_run+0x67/0xb0
> exit_to_user_mode_prepare+0x23d/0x240
> syscall_exit_to_user_mode+0x25/0x60
> do_syscall_64+0x40/0x80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fd83dc39e9b
>
> We need to increase the blocker counter to make sure all the osd
> requests' callbacks have been finished just before calling the
> kill_anon_super() when unmounting.

(Sorry for taking so long replying to this patch!  And I've still a few
others on the queue!)

I've been looking at this patch and at patch "ceph: drop the messages from
MDS when unmounting", but I still can't say whether they are correct or
not.  They seem to be working, but they don't _look_ right.

For example, mdsc->stopping is being used by ceph_dec_stopping_blocker()
and ceph_inc_stopping_blocker() for setting the ceph_mds_client state, but
the old usage for that field (e.g. in ceph_mdsc_pre_umount()) is being
kept.  Is that correct?  Maybe, but it looks wrong: the old usage isn't
protected by the spinlock and doesn't use the atomic counter.

Another example: in patch "ceph: drop the messages from MDS when
unmounting" we're adding calls to ceph_inc_stopping_blocker() in
ceph_handle_caps(), ceph_handle_quota(), and ceph_handle_snap().  Are
those the only places where this is needed?  Obviously not, because this
new patch is adding extra calls in the read/write paths.  But maybe there
are more places...?

And another one: changing ceph_inc_stopping_blocker() to accept NULL to
distinguish between mds and osd requests makes things look even more
hacky :-(

On the other end, I've been testing these patches thoroughly and couldn't
see any issues with them.  And although I'm still not convinced that they
will not deadlock in some corner cases, I don't have a better solution
either for the problem they're solving.

FWIW you can add my:

Tested-by: Lu=C3=ADs Henriques <lhenriques@suse.de>

to this patch (the other one already has it), but I'll need to spend more
time to see if there are better solutions.

Cheers,
--=20
Lu=C3=ADs

>
> URL: https://tracker.ceph.com/issues/58126
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> This is based ceph-client's testing branch and the fscrypt patches.
>
>
>  fs/ceph/addr.c  |  4 ++++
>  fs/ceph/super.c | 12 ++++++++----
>  2 files changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index 683ba9fbd590..eb89e3f2a416 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -272,6 +272,7 @@ static void finish_netfs_read(struct ceph_osd_request=
 *req)
>  	}
>  	netfs_subreq_terminated(subreq, err, false);
>  	iput(req->r_inode);
> +	ceph_dec_stopping_blocker(fsc->mdsc);
>  }
>=20=20
>  static bool ceph_netfs_issue_op_inline(struct netfs_io_subrequest *subre=
q)
> @@ -399,6 +400,7 @@ static void ceph_netfs_issue_read(struct netfs_io_sub=
request *subreq)
>  	} else {
>  		osd_req_op_extent_osd_iter(req, 0, &iter);
>  	}
> +	ceph_inc_stopping_blocker(fsc->mdsc, NULL);
>  	req->r_callback =3D finish_netfs_read;
>  	req->r_priv =3D subreq;
>  	req->r_inode =3D inode;
> @@ -871,6 +873,7 @@ static void writepages_finish(struct ceph_osd_request=
 *req)
>  	else
>  		kfree(osd_data->pages);
>  	ceph_osdc_put_request(req);
> +	ceph_dec_stopping_blocker(fsc->mdsc);
>  }
>=20=20
>  /*
> @@ -1179,6 +1182,7 @@ static int ceph_writepages_start(struct address_spa=
ce *mapping,
>  		BUG_ON(len < ceph_fscrypt_page_offset(pages[locked_pages - 1]) +
>  			     thp_size(pages[locked_pages - 1]) - offset);
>=20=20
> +		ceph_inc_stopping_blocker(fsc->mdsc, NULL);
>  		req->r_callback =3D writepages_finish;
>  		req->r_inode =3D inode;
>=20=20
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index de2a45fa451a..c29d2ddd1a7b 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -1475,16 +1475,20 @@ static int ceph_init_fs_context(struct fs_context=
 *fc)
>  /*
>   * Return true if mdsc successfully increase blocker counter,
>   * or false if the mdsc is in stopping and flushed state.
> + *
> + * session: NULL then it's for osd requests or for mds requests.
>   */
>  bool ceph_inc_stopping_blocker(struct ceph_mds_client *mdsc,
>  			       struct ceph_mds_session *session)
>  {
> -	mutex_lock(&session->s_mutex);
> -	inc_session_sequence(session);
> -	mutex_unlock(&session->s_mutex);
> +	if (session) {
> +		mutex_lock(&session->s_mutex);
> +		inc_session_sequence(session);
> +		mutex_unlock(&session->s_mutex);
> +	}
>=20=20
>  	spin_lock(&mdsc->stopping_lock);
> -	if (mdsc->stopping >=3D CEPH_MDSC_STOPPING_FLUSHED) {
> +	if (session && mdsc->stopping >=3D CEPH_MDSC_STOPPING_FLUSHED) {
>  		spin_unlock(&mdsc->stopping_lock);
>  		return false;
>  	}
> --=20
>
> 2.40.0
>

