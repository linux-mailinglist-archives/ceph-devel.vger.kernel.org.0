Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5483711045E
	for <lists+ceph-devel@lfdr.de>; Tue,  3 Dec 2019 19:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfLCSmg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 13:42:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfLCSmg (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 13:42:36 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 242A42073B;
        Tue,  3 Dec 2019 18:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575398555;
        bh=TQbv1VunwT8CUH8LKkCpFm0tuxzbzB03hzDwPidbd8A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NirluR+Utd/7+Gm0pg9qHND7NEaH9E067gDAspilafqXCuTfZW0r4f2r2VC2WF2pY
         VuFpeIAgUnHxQEk7/bmZfHFxRU69JapqxlHHjJi5/hXYPCUAEeGemAuRK8ajLgC42u
         ghLP/0O9gk9VOPxS+ei1e480PIAOOFvCOvRW0urw=
Message-ID: <cba462addab9fc98983df47f4acd92ed07e674be.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix mdsmap_decode got incorrect mds(X)
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, zyan@redhat.com,
        pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 03 Dec 2019 13:42:34 -0500
In-Reply-To: <20191203142949.34910-1-xiubli@redhat.com>
References: <20191203142949.34910-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-12-03 at 09:29 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The possible max rank, it maybe larger than the m->m_num_mds,
> for example if the mds_max == 2 in the cluster, when the MDS(0)
> was laggy and being replaced by a new MDS, we will temporarily
> receive a new mds map with n_num_mds == 1 and the active MDS(1),
> and the mds rank >= m->m_num_mds.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mdsmap.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 284d68646c40..a77e0ecb9a6b 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -129,6 +129,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  	int err;
>  	u8 mdsmap_v, mdsmap_cv;
>  	u16 mdsmap_ev;
> +	u32 possible_max_rank;
>  
>  	m = kzalloc(sizeof(*m), GFP_NOFS);
>  	if (!m)
> @@ -164,6 +165,15 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  	m->m_num_mds = n = ceph_decode_32(p);
>  	m->m_num_active_mds = m->m_num_mds;
>  
> +	/*
> +	 * the possible max rank, it maybe larger than the m->m_num_mds,
> +	 * for example if the mds_max == 2 in the cluster, when the MDS(0)
> +	 * was laggy and being replaced by a new MDS, we will temporarily
> +	 * receive a new mds map with n_num_mds == 1 and the active MDS(1),
> +	 * and the mds rank >= m->m_num_mds.
> +	 */
> +	possible_max_rank = max((u32)m->m_num_mds, m->m_max_mds);
> +
>  	m->m_info = kcalloc(m->m_num_mds, sizeof(*m->m_info), GFP_NOFS);
>  	if (!m->m_info)
>  		goto nomem;
> @@ -238,7 +248,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		     ceph_mds_state_name(state),
>  		     laggy ? "(laggy)" : "");
>  
> -		if (mds < 0 || mds >= m->m_num_mds) {
> +		if (mds < 0 || mds >= possible_max_rank) {
>  			pr_warn("mdsmap_decode got incorrect mds(%d)\n", mds);
>  			continue;
>  		}

Thanks, Xiubo. I'll squash this one into your earlier ceph_mdsmap_decode
patch, since it's fixing that logic up.
-- 
Jeff Layton <jlayton@kernel.org>

