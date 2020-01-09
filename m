Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C54721359BA
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Jan 2020 14:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgAINIt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jan 2020 08:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730222AbgAINIt (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 9 Jan 2020 08:08:49 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2C052072A;
        Thu,  9 Jan 2020 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578575328;
        bh=pE3TenjtBLa8o9Emkm6vNJ68KNOM4OEdRtbKsoxNBds=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=0ISiKa4AuItdtaZoFlG5BzavS7kIEJWtTxqcGg3Pf5CpqNgCc9Ds7A8DdiVF7KrR7
         g4FF8bfHq4MuJG67lvZPOAPBoBdXCuwMMyBAdIrBMFsX984A6+POct5bl0UC5V/zcz
         QgewFvWNEuSgJ5gJk/STicnX9maNNH0Qv1ipi1No=
Message-ID: <11bff5cb24cfd0dd1ddc836aabaa23cf38c802aa.camel@kernel.org>
Subject: Re: [PATCH v2] ceph: allocate the accurate extra bytes for the
 session features
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com, zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Thu, 09 Jan 2020 08:08:46 -0500
In-Reply-To: <20200108101731.26652-1-xiubli@redhat.com>
References: <20200108101731.26652-1-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2020-01-08 at 05:17 -0500, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The totally bytes maybe potentially larger than 8.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/mds_client.c | 20 ++++++++++++++------
>  fs/ceph/mds_client.h | 23 ++++++++++++++++-------
>  2 files changed, 30 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 94cce2ab92c4..d379f489ab63 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -9,6 +9,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/ratelimit.h>
> +#include <linux/bits.h>
>  
>  #include "super.h"
>  #include "mds_client.h"
> @@ -1053,20 +1054,21 @@ static struct ceph_msg *create_session_msg(u32 op, u64 seq)
>  	return msg;
>  }
>  
> +static const unsigned char feature_bits[] = CEPHFS_FEATURES_CLIENT_SUPPORTED;
> +#define FEATURE_BYTES(c) (DIV_ROUND_UP((size_t)feature_bits[c - 1] + 1, 64) * 8)
>  static void encode_supported_features(void **p, void *end)
>  {
> -	static const unsigned char bits[] = CEPHFS_FEATURES_CLIENT_SUPPORTED;
> -	static const size_t count = ARRAY_SIZE(bits);
> +	static const size_t count = ARRAY_SIZE(feature_bits);
>  
>  	if (count > 0) {
>  		size_t i;
> -		size_t size = ((size_t)bits[count - 1] + 64) / 64 * 8;
> +		size_t size = FEATURE_BYTES(count);
>  
>  		BUG_ON(*p + 4 + size > end);
>  		ceph_encode_32(p, size);
>  		memset(*p, 0, size);
>  		for (i = 0; i < count; i++)
> -			((unsigned char*)(*p))[i / 8] |= 1 << (bits[i] % 8);
> +			((unsigned char*)(*p))[i / 8] |= BIT(feature_bits[i] % 8);
>  		*p += size;
>  	} else {
>  		BUG_ON(*p + 4 > end);
> @@ -1087,6 +1089,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  	int metadata_key_count = 0;
>  	struct ceph_options *opt = mdsc->fsc->client->options;
>  	struct ceph_mount_options *fsopt = mdsc->fsc->mount_options;
> +	size_t size, count;
>  	void *p, *end;
>  
>  	const char* metadata[][2] = {
> @@ -1104,8 +1107,13 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  			strlen(metadata[i][1]);
>  		metadata_key_count++;
>  	}
> +
>  	/* supported feature */
> -	extra_bytes += 4 + 8;
> +	size = 0;
> +	count = ARRAY_SIZE(feature_bits);
> +	if (count > 0)
> +		size = FEATURE_BYTES(count);
> +	extra_bytes += 4 + size;
>  
>  	/* Allocate the message */
>  	msg = ceph_msg_new(CEPH_MSG_CLIENT_SESSION, sizeof(*h) + extra_bytes,
> @@ -1125,7 +1133,7 @@ static struct ceph_msg *create_session_open_msg(struct ceph_mds_client *mdsc, u6
>  	 * Serialize client metadata into waiting buffer space, using
>  	 * the format that userspace expects for map<string, string>
>  	 *
> -	 * ClientSession messages with metadata are v2
> +	 * ClientSession messages with metadata are v3
>  	 */
>  	msg->hdr.version = cpu_to_le16(3);
>  	msg->hdr.compat_version = cpu_to_le16(1);
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index c021df5f50ce..c950f8f88f58 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -17,22 +17,31 @@
>  #include <linux/ceph/auth.h>
>  
>  /* The first 8 bits are reserved for old ceph releases */
> -#define CEPHFS_FEATURE_MIMIC		8
> -#define CEPHFS_FEATURE_REPLY_ENCODING	9
> -#define CEPHFS_FEATURE_RECLAIM_CLIENT	10
> -#define CEPHFS_FEATURE_LAZY_CAP_WANTED	11
> -#define CEPHFS_FEATURE_MULTI_RECONNECT  12
> +enum ceph_feature_type {
> +	CEPHFS_FEATURE_MIMIC = 8,
> +	CEPHFS_FEATURE_REPLY_ENCODING,
> +	CEPHFS_FEATURE_RECLAIM_CLIENT,
> +	CEPHFS_FEATURE_LAZY_CAP_WANTED,
> +	CEPHFS_FEATURE_MULTI_RECONNECT,
> +
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_MULTI_RECONNECT,
> +};
>  
> -#define CEPHFS_FEATURES_CLIENT_SUPPORTED { 	\
> +/*
> + * This will always have the highest feature bit value
> + * as the last element of the array.
> + */
> +#define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
>  	0, 1, 2, 3, 4, 5, 6, 7,			\
>  	CEPHFS_FEATURE_MIMIC,			\
>  	CEPHFS_FEATURE_REPLY_ENCODING,		\
>  	CEPHFS_FEATURE_LAZY_CAP_WANTED,		\
>  	CEPHFS_FEATURE_MULTI_RECONNECT,		\
> +						\
> +	CEPHFS_FEATURE_MAX,			\
>  }
>  #define CEPHFS_FEATURES_CLIENT_REQUIRED {}
>  
> -
>  /*
>   * Some lock dependencies:
>   *

Merged (with small changelog rephrasing).

Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

