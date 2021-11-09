Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6B344AFAE
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 15:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238856AbhKIOp6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Nov 2021 09:45:58 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:59900 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhKIOp5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 9 Nov 2021 09:45:57 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 41B6621B16;
        Tue,  9 Nov 2021 14:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636468991; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=goioAniynbIiw0lUXSVIq3T8CoHhRVTIJahregzr+NY=;
        b=t+borbzAZgLVwDox3AulExgAEeANV+RPJ4S2GacW55kssM2iRWJHt1hyhnuzuCb5MBN68g
        2TqrjHyQVauNerMoVT+8sccGwrnawyoNZAiFqejzk0Txzez1UrxN4iTlWC5LX1iXOOanBu
        qpuZRTpx6ElangJx8OwX9eT0PKuaq6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636468991;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=goioAniynbIiw0lUXSVIq3T8CoHhRVTIJahregzr+NY=;
        b=EdZ2J3P+2fibBKZO/9GsXbSLDCahIqJZjPxb5xMxg2zzNky5cWFo8dZxKXqyUfRN+Gm2PN
        q7qdoAfgqmE2kiCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BFCD613A6A;
        Tue,  9 Nov 2021 14:43:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id qqmuK/6IimFcfQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Tue, 09 Nov 2021 14:43:10 +0000
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id 9f0d5704;
        Tue, 9 Nov 2021 14:43:10 +0000 (UTC)
Date:   Tue, 9 Nov 2021 14:43:09 +0000
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     khiremat@redhat.com
Cc:     jlayton@kernel.org, idryomov@gmail.com, pdonnell@redhat.com,
        vshankar@redhat.com, xiubli@redhat.com, ceph-devel@vger.kernel.org
Subject: Re: [PATCH v1 1/1] ceph: Fix incorrect statfs report for small quota
Message-ID: <YYqI/b0LgH5f8idv@suse.de>
References: <20211109091041.121750-1-khiremat@redhat.com>
 <20211109091041.121750-2-khiremat@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211109091041.121750-2-khiremat@redhat.com>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Nov 09, 2021 at 02:40:41PM +0530, khiremat@redhat.com wrote:
> From: Kotresh HR <khiremat@redhat.com>
> 
> Problem:
> The statfs reports incorrect free/available space
> for quota less then CEPH_BLOCK size (4M).
> 
> Solution:
> For quotas less than CEPH_BLOCK size, it is
> decided to go with binary use/free of full block.
> For quota size less than CEPH_BLOCK size, report
> the total=used=CEPH_BLOCK,free=0 when quota is
> full and total=free=CEPH_BLOCK, used=0 otherwise.

This sounds good to me, although it's still not really accurate, as it
will always use the block size granularity.  However, using these small
values for quotas isn't probably quite common anyway, so meh.

> Signed-off-by: Kotresh HR <khiremat@redhat.com>
> ---
>  fs/ceph/quota.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index 620c691af40e..d49ba82d08bf 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -505,6 +505,22 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
>  			buf->f_bfree = free;
>  			buf->f_bavail = free;
>  			is_updated = true;
> +		} else if (ci->i_max_bytes) {
> +			/* For quota size less than CEPH_BLOCK size, report
> +			 * the total=used=CEPH_BLOCK,free=0 when quota is full and
> +			 * total=free=CEPH_BLOCK, used=0 otherwise  */
> +			total = ci->i_max_bytes;
> +			used = ci->i_rbytes;
> +
> +			buf->f_blocks = 1;
> +			if (total > used) {
> +				buf->f_bfree = 1;
> +				buf->f_bavail = 1;
> +			} else {
> +				buf->f_bfree = 0;
> +				buf->f_bavail = 0;
> +			}
> +			is_updated = true;
>  		}
>  		iput(in);
>  	}
> -- 
> 2.31.1
> 

I think it would be more correct to move this logic into the spinlock
protected code.  Which would even make the code simpler, something like:

	spin_lock(&ci->i_ceph_lock);
	if (ci->i_max_bytes) {
		total = ci->i_max_bytes >> CEPH_BLOCK_SHIFT;
		if (total) {
			/* ... */
		} else {
			total = 1;
			free = ci->i_max_bytes > ci->i_rbytes ? 1 : 0;
		}
	}
	spin_unlock(&ci->i_ceph_lock);

I guess the 'if (total)' condition (and the 'is_updated' variable) can
also be removed.

Cheers,
--
Luís
