Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DA1226FAF
	for <lists+ceph-devel@lfdr.de>; Mon, 20 Jul 2020 22:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgGTUYz (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 20 Jul 2020 16:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgGTUYz (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 20 Jul 2020 16:24:55 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3727A22CBB;
        Mon, 20 Jul 2020 20:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595276694;
        bh=aS/+2SaYIz9Pl2URWwnQ8gYyzjTYfy2mPklTMhn6DSQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=e9/ZjYjMuKp3iyvy3Yuj6UOehCOxEmOA6Pu2A5YH70HrV+3SGONhtLsxhTojfiXtZ
         /QSGG31PdCeXOE38qo6H+YCl9VZekQCWK6S5s0xd9GAFE699xlqcRiEGUpm9ZVME+k
         6wXlOy+36hg051CmkPsCrknrSgMDsteKVsVhYiL8=
Message-ID: <028c75cdba6faf15ede3ef38937614694a0945d1.camel@kernel.org>
Subject: Re: [PATCH] fs:ceph: Remove unused variables in ceph_mdsmap_decode()
From:   Jeff Layton <jlayton@kernel.org>
To:     Jia Yang <jiayang5@huawei.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 20 Jul 2020 16:24:53 -0400
In-Reply-To: <20200720114017.24869-1-jiayang5@huawei.com>
References: <20200720114017.24869-1-jiayang5@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-07-20 at 19:40 +0800, Jia Yang wrote:
> Fix build warnings:
> 
> fs/ceph/mdsmap.c: In function ‘ceph_mdsmap_decode’:
> fs/ceph/mdsmap.c:192:7: warning:
> variable ‘info_cv’ set but not used [-Wunused-but-set-variable]
> fs/ceph/mdsmap.c:177:7: warning:
> variable ‘state_seq’ set but not used [-Wunused-but-set-variable]
> fs/ceph/mdsmap.c:123:15: warning:
> variable ‘mdsmap_cv’ set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Jia Yang <jiayang5@huawei.com>
> ---
>  fs/ceph/mdsmap.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
> index 889627817e52..9496287f2071 100644
> --- a/fs/ceph/mdsmap.c
> +++ b/fs/ceph/mdsmap.c
> @@ -120,7 +120,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  	const void *start = *p;
>  	int i, j, n;
>  	int err;
> -	u8 mdsmap_v, mdsmap_cv;
> +	u8 mdsmap_v;
>  	u16 mdsmap_ev;
>  
>  	m = kzalloc(sizeof(*m), GFP_NOFS);
> @@ -129,7 +129,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  
>  	ceph_decode_need(p, end, 1 + 1, bad);
>  	mdsmap_v = ceph_decode_8(p);
> -	mdsmap_cv = ceph_decode_8(p);

These decode calls have the side effect of incrementing "p", so this
will break decoding. You can still get rid of them, but you'll want to
convert them to ceph_decode_skip_* calls.

>  	if (mdsmap_v >= 4) {
>  	       u32 mdsmap_len;
>  	       ceph_decode_32_safe(p, end, mdsmap_len, bad);
> @@ -174,7 +173,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		u64 global_id;
>  		u32 namelen;
>  		s32 mds, inc, state;
> -		u64 state_seq;
>  		u8 info_v;
>  		void *info_end = NULL;
>  		struct ceph_entity_addr addr;
> @@ -189,9 +187,7 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		info_v= ceph_decode_8(p);
>  		if (info_v >= 4) {
>  			u32 info_len;
> -			u8 info_cv;
>  			ceph_decode_need(p, end, 1 + sizeof(u32), bad);
> -			info_cv = ceph_decode_8(p);
>  			info_len = ceph_decode_32(p);
>  			info_end = *p + info_len;
>  			if (info_end > end)
> @@ -210,7 +206,6 @@ struct ceph_mdsmap *ceph_mdsmap_decode(void **p, void *end)
>  		mds = ceph_decode_32(p);
>  		inc = ceph_decode_32(p);
>  		state = ceph_decode_32(p);
> -		state_seq = ceph_decode_64(p);
>  		err = ceph_decode_entity_addr(p, end, &addr);
>  		if (err)
>  			goto corrupt;

-- 
Jeff Layton <jlayton@kernel.org>

