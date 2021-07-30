Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23B83DB6DF
	for <lists+ceph-devel@lfdr.de>; Fri, 30 Jul 2021 12:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238312AbhG3KJT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 30 Jul 2021 06:09:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:39364 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238274AbhG3KJK (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 30 Jul 2021 06:09:10 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 826392232B;
        Fri, 30 Jul 2021 10:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1627639745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8SNOccRzsMvlWmub/uG2L8fKOYebBQXIJL7f2jgzQB8=;
        b=HjcuDPmiO6kKEzy7o+rCTbn6PBkYHG9oGd0rlx+AlovqYscNRSm1ymvlVie+jTev/oVQHG
        IPJuA6oh0GqfYck5gy/YqEAMf2YIGawJ/VtkTJR44u9PKoiynEPvaoJU4MXLNNZ7zX1sVv
        6G3XP9Fd5oXK/8eiJjq43cfiPMzGnz0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1627639745;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8SNOccRzsMvlWmub/uG2L8fKOYebBQXIJL7f2jgzQB8=;
        b=HILwFdMLmh34qbBMza4+3hOhVSpvFnHYwvioQwk+FCJOFpWoHbkttG51/XZ2Nf9Vx+WqUq
        qENQzb7h43QIDFAA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 32895137C2;
        Fri, 30 Jul 2021 10:09:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id boBlCcHPA2EWMAAAGKfGzw
        (envelope-from <lhenriques@suse.de>); Fri, 30 Jul 2021 10:09:05 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 7f9f41ab;
        Fri, 30 Jul 2021 10:09:04 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, pdonnell@redhat.com, idryomov@gmail.com
Subject: Re: [PATCH v3] ceph: dump info about cap flushes when we're waiting
 too long for them
References: <20210729180442.177399-1-jlayton@kernel.org>
Date:   Fri, 30 Jul 2021 11:09:04 +0100
In-Reply-To: <20210729180442.177399-1-jlayton@kernel.org> (Jeff Layton's
        message of "Thu, 29 Jul 2021 14:04:42 -0400")
Message-ID: <87zgu4m7un.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> We've had some cases of hung umounts in teuthology testing. It looks
> like client is waiting for cap flushes to complete, but they aren't.
>
> Add a field to the inode to track the highest cap flush tid seen for
> that inode. Also, add a backpointer to the inode to the ceph_cap_flush
> struct.
>
> Change wait_caps_flush to wait 60s, and then dump info about the
> condition of the list.
>
> Also, print pr_info messages if we end up dropping a FLUSH_ACK for an
> inode onto the floor.
>
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> URL: https://tracker.ceph.com/issues/51279
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/caps.c       | 17 +++++++++++++++--
>  fs/ceph/inode.c      |  1 +
>  fs/ceph/mds_client.c | 31 +++++++++++++++++++++++++++++--
>  fs/ceph/super.h      |  2 ++
>  4 files changed, 47 insertions(+), 4 deletions(-)
>
> v3: more debugging has shown the client waiting on FLUSH_ACK messages
>     that seem to never have come. Add some new printks if we end up
>     dropping a FLUSH_ACK onto the floor.

Since you're adding debug printks, would it be worth to also add one in
mds_dispatch(), when __verify_registered_session(mdsc, s) < 0?

It's a wild guess, but the FLUSH_ACK could be dropped in that case too.
Not that I could spot any issue there, but since this seems to be
happening during umount...

Cheers,
-- 
Luis


>
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index 7ae83d06d48c..cb551c9e5867 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1829,6 +1829,7 @@ static u64 __mark_caps_flushing(struct inode *inode,
>  	swap(cf, ci->i_prealloc_cap_flush);
>  	cf->caps = flushing;
>  	cf->wake = wake;
> +	cf->ci = ci;
>  
>  	spin_lock(&mdsc->cap_dirty_lock);
>  	list_del_init(&ci->i_dirty_item);
> @@ -3588,6 +3589,10 @@ static void handle_cap_flush_ack(struct inode *inode, u64 flush_tid,
>  	bool wake_ci = false;
>  	bool wake_mdsc = false;
>  
> +	/* track latest cap flush ack seen for this inode */
> +	if (flush_tid > ci->i_last_cap_flush_ack)
> +		ci->i_last_cap_flush_ack = flush_tid;
> +
>  	list_for_each_entry_safe(cf, tmp_cf, &ci->i_cap_flush_list, i_list) {
>  		/* Is this the one that was flushed? */
>  		if (cf->tid == flush_tid)
> @@ -4116,7 +4121,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>  	     (unsigned)seq);
>  
>  	if (!inode) {
> -		dout(" i don't have ino %llx\n", vino.ino);
> +		if (op == CEPH_CAP_OP_FLUSH_ACK)
> +			pr_info("%s: can't find ino %llx:%llx for flush_ack!\n",
> +				__func__, vino.snap, vino.ino);
> +		else
> +			dout(" i don't have ino %llx\n", vino.ino);
>  
>  		if (op == CEPH_CAP_OP_IMPORT) {
>  			cap = ceph_get_cap(mdsc, NULL);
> @@ -4169,10 +4178,14 @@ void ceph_handle_caps(struct ceph_mds_session *session,
>  	spin_lock(&ci->i_ceph_lock);
>  	cap = __get_cap_for_mds(ceph_inode(inode), session->s_mds);
>  	if (!cap) {
> -		dout(" no cap on %p ino %llx.%llx from mds%d\n",
> +		dout(" no cap on %p ino %llx:%llx from mds%d\n",
>  		     inode, ceph_ino(inode), ceph_snap(inode),
>  		     session->s_mds);
>  		spin_unlock(&ci->i_ceph_lock);
> +		if (op == CEPH_CAP_OP_FLUSH_ACK)
> +			pr_info("%s: no cap on %p ino %llx:%llx from mds%d for flush_ack!\n",
> +				__func__, inode, ceph_ino(inode),
> +				ceph_snap(inode), session->s_mds);
>  		goto flush_cap_releases;
>  	}
>  
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 1bd2cc015913..84e4f112fc45 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -499,6 +499,7 @@ struct inode *ceph_alloc_inode(struct super_block *sb)
>  	INIT_LIST_HEAD(&ci->i_cap_snaps);
>  	ci->i_head_snapc = NULL;
>  	ci->i_snap_caps = 0;
> +	ci->i_last_cap_flush_ack = 0;
>  
>  	ci->i_last_rd = ci->i_last_wr = jiffies - 3600 * HZ;
>  	for (i = 0; i < CEPH_FILE_MODE_BITS; i++)
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index c3fa0c0e4f6c..fc26527b8059 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2064,6 +2064,24 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
>  	return ret;
>  }
>  
> +static void dump_cap_flushes(struct ceph_mds_client *mdsc, u64 want_tid)
> +{
> +	struct ceph_cap_flush *cf;
> +
> +	pr_info("%s: still waiting for cap flushes through %llu\n:\n",
> +		__func__, want_tid);
> +	spin_lock(&mdsc->cap_dirty_lock);
> +	list_for_each_entry(cf, &mdsc->cap_flush_list, g_list) {
> +		if (cf->tid > want_tid)
> +			break;
> +		pr_info("%llx:%llx %s %llu %llu %d\n",
> +			ceph_vinop(&cf->ci->vfs_inode),
> +			ceph_cap_string(cf->caps), cf->tid,
> +			cf->ci->i_last_cap_flush_ack, cf->wake);
> +	}
> +	spin_unlock(&mdsc->cap_dirty_lock);
> +}
> +
>  /*
>   * flush all dirty inode data to disk.
>   *
> @@ -2072,10 +2090,19 @@ static int check_caps_flush(struct ceph_mds_client *mdsc,
>  static void wait_caps_flush(struct ceph_mds_client *mdsc,
>  			    u64 want_flush_tid)
>  {
> +	long ret;
> +
>  	dout("check_caps_flush want %llu\n", want_flush_tid);
>  
> -	wait_event(mdsc->cap_flushing_wq,
> -		   check_caps_flush(mdsc, want_flush_tid));
> +	do {
> +		ret = wait_event_timeout(mdsc->cap_flushing_wq,
> +			   check_caps_flush(mdsc, want_flush_tid), 60 * HZ);
> +		if (ret == 0)
> +			dump_cap_flushes(mdsc, want_flush_tid);
> +		else if (ret == 1)
> +			pr_info("%s: condition evaluated to true after timeout!\n",
> +				  __func__);
> +	} while (ret == 0);
>  
>  	dout("check_caps_flush ok, flushed thru %llu\n", want_flush_tid);
>  }
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 07eb542efa1d..d51d42a00f33 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -189,6 +189,7 @@ struct ceph_cap_flush {
>  	bool wake; /* wake up flush waiters when finish ? */
>  	struct list_head g_list; // global
>  	struct list_head i_list; // per inode
> +	struct ceph_inode_info *ci;
>  };
>  
>  /*
> @@ -388,6 +389,7 @@ struct ceph_inode_info {
>  	struct ceph_snap_context *i_head_snapc;  /* set if wr_buffer_head > 0 or
>  						    dirty|flushing caps */
>  	unsigned i_snap_caps;           /* cap bits for snapped files */
> +	u64 i_last_cap_flush_ack;		/* latest cap flush_ack tid for this inode */
>  
>  	unsigned long i_last_rd;
>  	unsigned long i_last_wr;
> -- 
>
> 2.31.1
>
