Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC8FC6CD
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 14:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKNNAZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 08:00:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726202AbfKNNAZ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 14 Nov 2019 08:00:25 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADB48206E1;
        Thu, 14 Nov 2019 13:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573736424;
        bh=n3t7u572qIWkQv9fAzVsyHbXrmJi4fGpDag8PrDOscY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vyvR+VRu3c1yLTxSlueP/MKjC1Inordi+oI1d7VvdYb2yF37Tkn2poztxkaNYIuTz
         Cw8dOpLN9TFS7J/f+GVJN1aVYpDD4qvqUuZRPl2w0A8XCQd7e+tDMmXyMTxSq88/Do
         3/4RM0LomCwt0A2nJWfA3rfQu4SZnyoQkMYApf6k=
Message-ID: <5faae4ebcbe0eb22dc1b7d745e9355f35a9e821b.camel@kernel.org>
Subject: Re: [RFC PATCH v2 2/4] ceph: get the require_osd_release field from
 the osdmap
From:   Jeff Layton <jlayton@kernel.org>
To:     Luis Henriques <lhenriques@suse.com>, Sage Weil <sage@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 14 Nov 2019 08:00:22 -0500
In-Reply-To: <20191114105736.8636-3-lhenriques@suse.com>
References: <20191114105736.8636-1-lhenriques@suse.com>
         <20191114105736.8636-3-lhenriques@suse.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-11-14 at 10:57 +0000, Luis Henriques wrote:
> Since Ceph Octopus, OSDs are encoding require_osd_release into the client
> data part of the osdmap.  This patch adds code to pick this extra field.
> 
> Signed-off-by: Luis Henriques <lhenriques@suse.com>
> ---
>  include/linux/ceph/ceph_features.h | 10 ++++++++--
>  include/linux/ceph/osdmap.h        |  1 +
>  net/ceph/osdmap.c                  | 21 +++++++++++++++++++++
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/ceph/ceph_features.h b/include/linux/ceph/ceph_features.h
> index 39e6f4c57580..f329d1907dd7 100644
> --- a/include/linux/ceph/ceph_features.h
> +++ b/include/linux/ceph/ceph_features.h
> @@ -9,6 +9,7 @@
>   */
>  #define CEPH_FEATURE_INCARNATION_1 (0ull)
>  #define CEPH_FEATURE_INCARNATION_2 (1ull<<57) // CEPH_FEATURE_SERVER_JEWEL
> +#define CEPH_FEATURE_INCARNATION_3 ((1ull<<57)|(1ull<<28)) // SERVER_MIMIC
>  
>  #define DEFINE_CEPH_FEATURE(bit, incarnation, name)			\
>  	static const uint64_t CEPH_FEATURE_##name = (1ULL<<bit);		\
> @@ -76,6 +77,7 @@ DEFINE_CEPH_FEATURE( 0, 1, UID)
>  DEFINE_CEPH_FEATURE( 1, 1, NOSRCADDR)
>  DEFINE_CEPH_FEATURE_RETIRED( 2, 1, MONCLOCKCHECK, JEWEL, LUMINOUS)
>  
> +DEFINE_CEPH_FEATURE( 2, 3, SERVER_NAUTILUS)
>  DEFINE_CEPH_FEATURE( 3, 1, FLOCK)
>  DEFINE_CEPH_FEATURE( 4, 1, SUBSCRIBE2)
>  DEFINE_CEPH_FEATURE( 5, 1, MONNAMES)
> @@ -92,6 +94,7 @@ DEFINE_CEPH_FEATURE(14, 2, SERVER_KRAKEN)
>  DEFINE_CEPH_FEATURE(15, 1, MONENC)
>  DEFINE_CEPH_FEATURE_RETIRED(16, 1, QUERY_T, JEWEL, LUMINOUS)
>  
> +DEFINE_CEPH_FEATURE(16, 3, SERVER_OCTOPUS)
>  DEFINE_CEPH_FEATURE_RETIRED(17, 1, INDEP_PG_MAP, JEWEL, LUMINOUS)
>  
>  DEFINE_CEPH_FEATURE(18, 1, CRUSH_TUNABLES)
> @@ -114,7 +117,7 @@ DEFINE_CEPH_FEATURE(25, 1, CRUSH_TUNABLES2)
>  DEFINE_CEPH_FEATURE(26, 1, CREATEPOOLID)
>  DEFINE_CEPH_FEATURE(27, 1, REPLY_CREATE_INODE)
>  DEFINE_CEPH_FEATURE_RETIRED(28, 1, OSD_HBMSGS, HAMMER, JEWEL)
> -DEFINE_CEPH_FEATURE(28, 2, SERVER_M)
> +DEFINE_CEPH_FEATURE(28, 2, SERVER_MIMIC)
>  DEFINE_CEPH_FEATURE(29, 1, MDSENC)
>  DEFINE_CEPH_FEATURE(30, 1, OSDHASHPSPOOL)
>  DEFINE_CEPH_FEATURE(31, 1, MON_SINGLE_PAXOS)  // deprecate me
> @@ -212,7 +215,10 @@ DEFINE_CEPH_FEATURE_DEPRECATED(63, 1, RESERVED_BROKEN, LUMINOUS) // client-facin
>  	 CEPH_FEATURE_CRUSH_TUNABLES5 |		\
>  	 CEPH_FEATURE_NEW_OSDOPREPLY_ENCODING |	\
>  	 CEPH_FEATURE_MSG_ADDR2 |		\
> -	 CEPH_FEATURE_CEPHX_V2)
> +	 CEPH_FEATURE_CEPHX_V2 |		\
> +	 CEPH_FEATURE_SERVER_MIMIC |		\
> +	 CEPH_FEATURE_SERVER_NAUTILUS |		\
> +	 CEPH_FEATURE_SERVER_OCTOPUS)
>  

As you mentioned in the cover letter, that doesn't seem likely to be
safe to just enable like this. I'm pretty sure the kclient is missing
some things that are encompassed by these bits.

Unfortunately none of that seems to be clearly documented anywhere, so
you're probably stuck walking through the ceph tree to see why the
server daemons are checking these flags.

>  #define CEPH_FEATURES_REQUIRED_DEFAULT	0
>  
> diff --git a/include/linux/ceph/osdmap.h b/include/linux/ceph/osdmap.h
> index e081b56f1c1d..0d8e7f5e3478 100644
> --- a/include/linux/ceph/osdmap.h
> +++ b/include/linux/ceph/osdmap.h
> @@ -160,6 +160,7 @@ struct ceph_osdmap {
>  
>  	u32 flags;         /* CEPH_OSDMAP_* */
>  
> +	u8 require_osd_release;
>  	u32 max_osd;       /* size of osd_state, _offload, _addr arrays */
>  	u32 *osd_state;    /* CEPH_OSD_* */
>  	u32 *osd_weight;   /* 0 = failed, 0x10000 = 100% normal */
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index 4e0de14f80bb..29526fd61983 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -1582,6 +1582,27 @@ static int osdmap_decode(void **p, void *end, struct ceph_osdmap *map)
>  		WARN_ON(!RB_EMPTY_ROOT(&map->pg_upmap_items));
>  	}
>  
> +	if (struct_v >= 6)
> +		/* crush version */
> +		ceph_decode_skip_32(p, end, e_inval);
> +	if (struct_v >= 7) {
> +		/*
> +		 * skip removed_snaps and purged_snaps
> +		 * (snap_interval_set_t = 8 + 8)
> +		 */
> +		ceph_decode_skip_set(p, end, 16, e_inval);
> +		ceph_decode_skip_set(p, end, 16, e_inval);
> +	}
> +	if (struct_v >= 9) {
> +		struct ceph_timespec ts;
> +
> +		/* last_up_change and last_in_change */
> +		ceph_decode_copy_safe(p, end, &ts, sizeof(ts), e_inval);
> +		ceph_decode_copy_safe(p, end, &ts, sizeof(ts), e_inval);
> +	}
> +	if (struct_v >= 10)
> +		ceph_decode_8_safe(p, end, map->require_osd_release, e_inval);
> +
>  	/* ignore the rest */
>  	*p = end;
>  

-- 
Jeff Layton <jlayton@kernel.org>

