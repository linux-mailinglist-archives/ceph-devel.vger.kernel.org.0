Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFAF44422B
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 14:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhKCNJK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 09:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhKCNJJ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 3 Nov 2021 09:09:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A19DE60F56;
        Wed,  3 Nov 2021 13:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635944793;
        bh=Gfe12cSe/Zgx7ZcCvRx+H/uwr4YEGVisOB5q3qgsmcY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ViYH6quwbICnKS/w1eSUs/gJNKyop9oRy3bjxGpq2YlU9tGwjfd5yeiDBDJtV+fog
         IAF/a45gqstjAreibSjK7FTCWzum7AZpnz8Pq388kyZj1qCI7tBOJ2IWQlTCgph+QK
         RnodrHyAKwfnsNslVBT3EzzZtpspuSx3M9PvSlTBpv1/p65Bir1xrUqIYLSLyKf8Zd
         itzktQA/bfLIyDB8qnkcbjYw/8SnBf+Y9W6vL2zai6TZZ2ODUfduexc4zhLOGds29b
         I8RzAgUPyczzsyofq8rvmor3sUhnVsEyBEu7/QvpgvPToOn8WcRjFKm4pKabnSu5hJ
         sFWz70Y/D4dFQ==
Message-ID: <597ab2ed71c04327d22e80ef3e630d6f0515c7b7.camel@kernel.org>
Subject: Re: [PATCH 1/2] libceph: have ceph_osdc_copy_from() return the osd
 request
From:   Jeff Layton <jlayton@kernel.org>
To:     =?ISO-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>,
        Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>
Cc:     Patrick Donnelly <pdonnell@redhat.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 03 Nov 2021 09:06:31 -0400
In-Reply-To: <20211103112405.8733-2-lhenriques@suse.de>
References: <20211103112405.8733-1-lhenriques@suse.de>
         <20211103112405.8733-2-lhenriques@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.0 (3.42.0-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 2021-11-03 at 11:24 +0000, Luís Henriques wrote:
> This patch modifies the behaviour of ceph_osdc_copy_from() function so
> that it will create the osd request and send it but won't block waiting
> for the result.  It is now the responsibility of the callers (currently
> only ceph_do_objects_copy()) to do the wait and release the request.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>  fs/ceph/file.c                  |  9 ++++++++-
>  include/linux/ceph/osd_client.h | 21 +++++++++++----------
>  net/ceph/osd_client.c           | 27 ++++++++++++++-------------
>  3 files changed, 33 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 6005b430f6f7..a39703b8ef99 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2218,6 +2218,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
>  {
>  	struct ceph_object_locator src_oloc, dst_oloc;
>  	struct ceph_object_id src_oid, dst_oid;
> +	struct ceph_osd_request *req;
>  	size_t bytes = 0;
>  	u64 src_objnum, src_objoff, dst_objnum, dst_objoff;
>  	u32 src_objlen, dst_objlen;
> @@ -2243,7 +2244,7 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
>  		ceph_oid_printf(&dst_oid, "%llx.%08llx",
>  				dst_ci->i_vino.ino, dst_objnum);
>  		/* Do an object remote copy */
> -		ret = ceph_osdc_copy_from(&fsc->client->osdc,
> +		req = ceph_osdc_copy_from(&fsc->client->osdc,
>  					  src_ci->i_vino.snap, 0,
>  					  &src_oid, &src_oloc,
>  					  CEPH_OSD_OP_FLAG_FADVISE_SEQUENTIAL |
> @@ -2254,6 +2255,12 @@ static ssize_t ceph_do_objects_copy(struct ceph_inode_info *src_ci, u64 *src_off
>  					  dst_ci->i_truncate_seq,
>  					  dst_ci->i_truncate_size,
>  					  CEPH_OSD_COPY_FROM_FLAG_TRUNCATE_SEQ);
> +		if (IS_ERR(req))
> +			ret = PTR_ERR(req);
> +		else {
> +			ret = ceph_osdc_wait_request(&fsc->client->osdc, req);
> +			ceph_osdc_put_request(req);
> +		}
>  		if (ret) {
>  			if (ret == -EOPNOTSUPP) {
>  				fsc->have_copy_from2 = false;
> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
> index 83fa08a06507..74d590cd29c9 100644
> --- a/include/linux/ceph/osd_client.h
> +++ b/include/linux/ceph/osd_client.h
> @@ -515,16 +515,17 @@ int ceph_osdc_call(struct ceph_osd_client *osdc,
>  		   struct page *req_page, size_t req_len,
>  		   struct page **resp_pages, size_t *resp_len);
>  
> -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> -			u64 src_snapid, u64 src_version,
> -			struct ceph_object_id *src_oid,
> -			struct ceph_object_locator *src_oloc,
> -			u32 src_fadvise_flags,
> -			struct ceph_object_id *dst_oid,
> -			struct ceph_object_locator *dst_oloc,
> -			u32 dst_fadvise_flags,
> -			u32 truncate_seq, u64 truncate_size,
> -			u8 copy_from_flags);
> +struct ceph_osd_request *
> +ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> +		    u64 src_snapid, u64 src_version,
> +		    struct ceph_object_id *src_oid,
> +		    struct ceph_object_locator *src_oloc,
> +		    u32 src_fadvise_flags,
> +		    struct ceph_object_id *dst_oid,
> +		    struct ceph_object_locator *dst_oloc,
> +		    u32 dst_fadvise_flags,
> +		    u32 truncate_seq, u64 truncate_size,
> +		    u8 copy_from_flags);
>  
>  /* watch/notify */
>  struct ceph_osd_linger_request *
> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
> index ff8624a7c964..78384b431748 100644
> --- a/net/ceph/osd_client.c
> +++ b/net/ceph/osd_client.c
> @@ -5347,23 +5347,24 @@ static int osd_req_op_copy_from_init(struct ceph_osd_request *req,
>  	return 0;
>  }
>  
> -int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> -			u64 src_snapid, u64 src_version,
> -			struct ceph_object_id *src_oid,
> -			struct ceph_object_locator *src_oloc,
> -			u32 src_fadvise_flags,
> -			struct ceph_object_id *dst_oid,
> -			struct ceph_object_locator *dst_oloc,
> -			u32 dst_fadvise_flags,
> -			u32 truncate_seq, u64 truncate_size,
> -			u8 copy_from_flags)
> +struct ceph_osd_request *
> +ceph_osdc_copy_from(struct ceph_osd_client *osdc,
> +		    u64 src_snapid, u64 src_version,
> +		    struct ceph_object_id *src_oid,
> +		    struct ceph_object_locator *src_oloc,
> +		    u32 src_fadvise_flags,
> +		    struct ceph_object_id *dst_oid,
> +		    struct ceph_object_locator *dst_oloc,
> +		    u32 dst_fadvise_flags,
> +		    u32 truncate_seq, u64 truncate_size,
> +		    u8 copy_from_flags)
>  {
>  	struct ceph_osd_request *req;
>  	int ret;
>  
>  	req = ceph_osdc_alloc_request(osdc, NULL, 1, false, GFP_KERNEL);
>  	if (!req)
> -		return -ENOMEM;
> +		return ERR_PTR(-ENOMEM);
>  
>  	req->r_flags = CEPH_OSD_FLAG_WRITE;
>  
> @@ -5382,11 +5383,11 @@ int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>  		goto out;
>  
>  	ceph_osdc_start_request(osdc, req, false);
> -	ret = ceph_osdc_wait_request(osdc, req);
> +	return req;
>  

I don't really understand why this function is part of net/ceph. It's
odd in that it basically allocates, initializes and starts the request
and then passes back the pointer to it. That doesn't really follow the
pattern of the other OSD READ/WRITE ops, where we basically set them up
and start them more directly from the fs/ceph code.

I think it'd make more sense to just get rid of ceph_osdc_copy_from
altogether, export the osd_req_op_copy_from_init symbol and open-code
the whole thing in ceph_do_objects_copy. This isn't otherwise called
from rbd or anything else so I don't see the benefit of keeping this
function as part of libceph.

>  out:
>  	ceph_osdc_put_request(req);
> -	return ret;
> +	return ERR_PTR(ret);
>  }
>  EXPORT_SYMBOL(ceph_osdc_copy_from);
>  

-- 
Jeff Layton <jlayton@kernel.org>
