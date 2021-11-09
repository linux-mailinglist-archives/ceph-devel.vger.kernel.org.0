Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F16244B1A9
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Nov 2021 18:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbhKIRFB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 9 Nov 2021 12:05:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:38636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238128AbhKIRFA (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 9 Nov 2021 12:05:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDED860F90;
        Tue,  9 Nov 2021 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636477334;
        bh=m4weViyZmHS/WUlVjsiwDEGTHtdcBMYQ8Nadf++PTU0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Bz+V2IVhCmAcJj8RElsTWfn4oCIPtVNWibosue8Vhm+cTJ9teFWK15s/q3bJT0T6t
         TCs+EINZY4hEBnc1LHGcJukQlLNxx1PvlXMLOQlpwXt5IPK9Mpf7kcNKRVAvYwwocx
         as/P2lgqW+PlQfVsCSlVUDYB5MoedrK2XkpSvebxmMZSYry7Y/aQV2NbKCrQVhAYYH
         Fb1oJzDL3mgjRHmz4nadjqVA/TyIhsdY14OrgG5VP/Y4qzE3zo+bOVtYDnrFwbjpXt
         B/UnnQCBXt9dv+nWNyFwcbdK0U8rVeLmCCf5dUbTedUMIAiTGh0o6Nw9S1JwKFwZaF
         tTkjovsADRx8A==
Message-ID: <930ef6492acab416c5a4fd43ada6b16daec4048e.camel@kernel.org>
Subject: Re: [PATCH v1 1/1] ceph: Fix incorrect statfs report for small quota
From:   Jeff Layton <jlayton@kernel.org>
To:     khiremat@redhat.com
Cc:     idryomov@gmail.com, pdonnell@redhat.com, vshankar@redhat.com,
        xiubli@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 09 Nov 2021 12:02:12 -0500
In-Reply-To: <20211109091041.121750-2-khiremat@redhat.com>
References: <20211109091041.121750-1-khiremat@redhat.com>
         <20211109091041.121750-2-khiremat@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-11-09 at 14:40 +0530, khiremat@redhat.com wrote:
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
> 
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

Technically this is (sort of) correct, but the lack of granularity makes
this reporting somewhat useless.

Honestly, I'd rather see this switch to reporting a smaller blocksize
when you get down to <4M max_bytes. If people are setting quotas that
are that small, then they probably would like to be able to look at "df"
and see if they're approaching their quota. This doesn't give them that
capability.

Instead, could we just switch to reporting a 4k blocksize when
i_max_bytes is that small? Then you can multiply the other values by 1k
and it should all be correct.
-- 
Jeff Layton <jlayton@kernel.org>
