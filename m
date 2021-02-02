Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A50D30C4D2
	for <lists+ceph-devel@lfdr.de>; Tue,  2 Feb 2021 17:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbhBBQDF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 2 Feb 2021 11:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:50412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235838AbhBBQAc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 11:00:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED86B64ECE;
        Tue,  2 Feb 2021 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612281591;
        bh=XbfCS8r9D79/HwOJHuFwd9sZg+kItL2sGtFVodrMWJs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DztYFmBWBkzHFUwiTi89aEcaQZQQdTgGD5jcc7tgzjNDVJpOaKce8LV4Aq+P1VY+Y
         sh7lsrjaca6+gNfRoscJdyH/wxrzes5d7VCdchhhTlboqd1wEDTzZBt5ZVcs8t2tuj
         hbs1+1yCrQEsVV7Mg/tTep1ygxseiaIoJSpHuusdeiCsC09gjx7/ZCihk9u3g0tD6f
         l/4mcZooFzyhuI9BDIdGU2O/g7ZFdSIYcFKEfEeF4jS3hwd6Iwwo8niak5nGeX8U/i
         IOL72CSjVd5Mzq+bS0QpjXr1JlRDbDvcdkpdWWoXvwyzX3pqDzseqqooZbaXjruOuk
         aWvVdcI6K4YQA==
Message-ID: <d260d1e6c379dd16168df73003daa88f875bd4d8.camel@kernel.org>
Subject: Re: [PATCH v4] ceph: defer flushing the capsnap if the Fb is used
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 02 Feb 2021 10:59:49 -0500
In-Reply-To: <20210202065453.814859-1-xiubli@redhat.com>
References: <20210202065453.814859-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-02-02 at 14:54 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> If the Fb cap is used it means the current inode is flushing the
> dirty data to OSD, just defer flushing the capsnap.
> 
> URL: https://tracker.ceph.com/issues/48679
> URL: https://tracker.ceph.com/issues/48640
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V4:
> - Fix stuck issue when running the snaptest-git-ceph.sh pointed by Jeff.
> 
> V3:
> - Add more comments about putting the inode ref
> - A small change about the code style
> 
> V2:
> - Fix inode reference leak bug
> 
> 
>  fs/ceph/caps.c | 33 ++++++++++++++++++++-------------
>  fs/ceph/snap.c | 10 ++++++++++
>  2 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index abbf48fc6230..570731c4d019 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -3047,6 +3047,7 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  {
>  	struct inode *inode = &ci->vfs_inode;
>  	int last = 0, put = 0, flushsnaps = 0, wake = 0;
> +	bool check_flushsnaps = false;
>  
> 
>  	spin_lock(&ci->i_ceph_lock);
>  	if (had & CEPH_CAP_PIN)
> @@ -3063,26 +3064,17 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  	if (had & CEPH_CAP_FILE_BUFFER) {
>  		if (--ci->i_wb_ref == 0) {
>  			last++;
> +			/* put the ref held by ceph_take_cap_refs() */
>  			put++;
> +			check_flushsnaps = true;
>  		}
>  		dout("put_cap_refs %p wb %d -> %d (?)\n",
>  		     inode, ci->i_wb_ref+1, ci->i_wb_ref);
>  	}
> -	if (had & CEPH_CAP_FILE_WR)
> +	if (had & CEPH_CAP_FILE_WR) {
>  		if (--ci->i_wr_ref == 0) {
>  			last++;
> -			if (__ceph_have_pending_cap_snap(ci)) {
> -				struct ceph_cap_snap *capsnap =
> -					list_last_entry(&ci->i_cap_snaps,
> -							struct ceph_cap_snap,
> -							ci_item);
> -				capsnap->writing = 0;
> -				if (ceph_try_drop_cap_snap(ci, capsnap))
> -					put++;
> -				else if (__ceph_finish_cap_snap(ci, capsnap))
> -					flushsnaps = 1;
> -				wake = 1;
> -			}
> +			check_flushsnaps = true;
>  			if (ci->i_wrbuffer_ref_head == 0 &&
>  			    ci->i_dirty_caps == 0 &&
>  			    ci->i_flushing_caps == 0) {
> @@ -3094,6 +3086,21 @@ static void __ceph_put_cap_refs(struct ceph_inode_info *ci, int had,
>  			if (!__ceph_is_any_real_caps(ci) && ci->i_snap_realm)
>  				drop_inode_snap_realm(ci);
>  		}
> +	}
> +	if (check_flushsnaps && __ceph_have_pending_cap_snap(ci)) {
> +		struct ceph_cap_snap *capsnap =
> +			list_last_entry(&ci->i_cap_snaps,
> +					struct ceph_cap_snap,
> +					ci_item);
> +
> +		capsnap->writing = 0;
> +		if (ceph_try_drop_cap_snap(ci, capsnap))
> +			/* put the ref held by ceph_queue_cap_snap() */
> +			put++;
> +		else if (__ceph_finish_cap_snap(ci, capsnap))
> +			flushsnaps = 1;
> +		wake = 1;
> +	}
>  	spin_unlock(&ci->i_ceph_lock);
>  
> 
>  	dout("put_cap_refs %p had %s%s%s\n", inode, ceph_cap_string(had),
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index b611f829cb61..0728b01d4d43 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -623,6 +623,16 @@ int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
>  		return 0;
>  	}
>  
> 
> +	/* Fb cap still in use, delay it */
> +	if (ci->i_wb_ref) {
> +		dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu "
> +		     "used WRBUFFER, delaying\n", inode, capsnap,
> +		     capsnap->context, capsnap->context->seq,
> +		     ceph_cap_string(capsnap->dirty), capsnap->size);
> +		capsnap->writing = 1;
> +		return 0;
> +	}
> +
>  	ci->i_ceph_flags |= CEPH_I_FLUSH_SNAPS;
>  	dout("finish_cap_snap %p cap_snap %p snapc %p %llu %s s=%llu\n",
>  	     inode, capsnap, capsnap->context,

Much better. This one seems to behave better. I've gone ahead and taken
this into testing branch.

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

