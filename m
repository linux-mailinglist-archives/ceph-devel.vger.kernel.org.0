Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7C8AFF3C
	for <lists+ceph-devel@lfdr.de>; Wed, 11 Sep 2019 16:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbfIKOyd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 11 Sep 2019 10:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727627AbfIKOyd (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 11 Sep 2019 10:54:33 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA0E2075C;
        Wed, 11 Sep 2019 14:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568213672;
        bh=z8fA1CtUng7cgwSqeC1jjtP6k6oD7NU2RrgaHhvBeNo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=oOdCAV2O9dSsu2H3rZ3j9XTL9K7kq7z+XbN9nVB0+JDfSODpvQHRkgmvE1Im52+6J
         4gsDyMruIZRqKjbPYagcKrRRwxAfFNICuitu7LJls+Vf+k6m/k2n5TTP959Ncez4ZA
         BcT6jlroj0RqBCInchTvZdu2U8vVpwxmD6JgButM=
Message-ID: <6730435b5fbae66393de4b55d82891d9e7c4dd11.camel@kernel.org>
Subject: Re: [PATCH] libceph: use ceph_kvmalloc() for osdmap arrays
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Wed, 11 Sep 2019 10:54:31 -0400
In-Reply-To: <20190910194126.21144-1-idryomov@gmail.com>
References: <20190910194126.21144-1-idryomov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-09-10 at 21:41 +0200, Ilya Dryomov wrote:
> osdmap has a bunch of arrays that grow linearly with the number of
> OSDs.  osd_state, osd_weight and osd_primary_affinity take 4 bytes per
> OSD.  osd_addr takes 136 bytes per OSD because of sockaddr_storage.
> The CRUSH workspace area also grows linearly with the number of OSDs.
> 
> Normally these arrays are allocated at client startup.  The osdmap is
> usually updated in small incrementals, but once in a while a full map
> may need to be processed.  For a cluster with 10000 OSDs, this means
> a bunch of 40K allocations followed by a 1.3M allocation, all of which
> are currently required to be physically contiguous.  This results in
> sporadic ENOMEM errors, hanging the client.
> 
> Go back to manually (re)allocating arrays and use ceph_kvmalloc() to
> fall back to non-contiguous allocation when necessary.
> 
> Link: https://tracker.ceph.com/issues/40481
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  net/ceph/osdmap.c | 69 +++++++++++++++++++++++++++++------------------
>  1 file changed, 43 insertions(+), 26 deletions(-)
> 
> diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
> index 90437906b7bc..4e0de14f80bb 100644
> --- a/net/ceph/osdmap.c
> +++ b/net/ceph/osdmap.c
> @@ -973,11 +973,11 @@ void ceph_osdmap_destroy(struct ceph_osdmap *map)
>  				 struct ceph_pg_pool_info, node);
>  		__remove_pg_pool(&map->pg_pools, pi);
>  	}
> -	kfree(map->osd_state);
> -	kfree(map->osd_weight);
> -	kfree(map->osd_addr);
> -	kfree(map->osd_primary_affinity);
> -	kfree(map->crush_workspace);
> +	kvfree(map->osd_state);
> +	kvfree(map->osd_weight);
> +	kvfree(map->osd_addr);
> +	kvfree(map->osd_primary_affinity);
> +	kvfree(map->crush_workspace);
>  	kfree(map);
>  }
>  
> @@ -986,28 +986,41 @@ void ceph_osdmap_destroy(struct ceph_osdmap *map)
>   *
>   * The new elements are properly initialized.
>   */
> -static int osdmap_set_max_osd(struct ceph_osdmap *map, int max)
> +static int osdmap_set_max_osd(struct ceph_osdmap *map, u32 max)
>  {
>  	u32 *state;
>  	u32 *weight;
>  	struct ceph_entity_addr *addr;
> +	u32 to_copy;
>  	int i;
>  
> -	state = krealloc(map->osd_state, max*sizeof(*state), GFP_NOFS);
> -	if (!state)
> -		return -ENOMEM;
> -	map->osd_state = state;
> +	dout("%s old %u new %u\n", __func__, map->max_osd, max);
> +	if (max == map->max_osd)
> +		return 0;
>  
> -	weight = krealloc(map->osd_weight, max*sizeof(*weight), GFP_NOFS);
> -	if (!weight)
> +	state = ceph_kvmalloc(array_size(max, sizeof(*state)), GFP_NOFS);
> +	weight = ceph_kvmalloc(array_size(max, sizeof(*weight)), GFP_NOFS);
> +	addr = ceph_kvmalloc(array_size(max, sizeof(*addr)), GFP_NOFS);

Is GFP_NOFS sufficient here, given that this may be called from rbd?
Should we be using NOIO instead (or maybe the PF_MEMALLOC_* equivalent)?

> +	if (!state || !weight || !addr) {
> +		kvfree(state);
> +		kvfree(weight);
> +		kvfree(addr);
>  		return -ENOMEM;
> -	map->osd_weight = weight;
> +	}
>  
> -	addr = krealloc(map->osd_addr, max*sizeof(*addr), GFP_NOFS);
> -	if (!addr)
> -		return -ENOMEM;
> -	map->osd_addr = addr;
> +	to_copy = min(map->max_osd, max);
> +	if (map->osd_state) {
> +		memcpy(state, map->osd_state, to_copy * sizeof(*state));
> +		memcpy(weight, map->osd_weight, to_copy * sizeof(*weight));
> +		memcpy(addr, map->osd_addr, to_copy * sizeof(*addr));
> +		kvfree(map->osd_state);
> +		kvfree(map->osd_weight);
> +		kvfree(map->osd_addr);
> +	}
>  
> +	map->osd_state = state;
> +	map->osd_weight = weight;
> +	map->osd_addr = addr;
>  	for (i = map->max_osd; i < max; i++) {
>  		map->osd_state[i] = 0;
>  		map->osd_weight[i] = CEPH_OSD_OUT;
> @@ -1017,12 +1030,16 @@ static int osdmap_set_max_osd(struct ceph_osdmap *map, int max)
>  	if (map->osd_primary_affinity) {
>  		u32 *affinity;
>  
> -		affinity = krealloc(map->osd_primary_affinity,
> -				    max*sizeof(*affinity), GFP_NOFS);
> +		affinity = ceph_kvmalloc(array_size(max, sizeof(*affinity)),
> +					 GFP_NOFS);
>  		if (!affinity)
>  			return -ENOMEM;
> -		map->osd_primary_affinity = affinity;
>  
> +		memcpy(affinity, map->osd_primary_affinity,
> +		       to_copy * sizeof(*affinity));
> +		kvfree(map->osd_primary_affinity);
> +
> +		map->osd_primary_affinity = affinity;
>  		for (i = map->max_osd; i < max; i++)
>  			map->osd_primary_affinity[i] =
>  			    CEPH_OSD_DEFAULT_PRIMARY_AFFINITY;
> @@ -1043,7 +1060,7 @@ static int osdmap_set_crush(struct ceph_osdmap *map, struct crush_map *crush)
>  
>  	work_size = crush_work_size(crush, CEPH_PG_MAX_SIZE);
>  	dout("%s work_size %zu bytes\n", __func__, work_size);
> -	workspace = kmalloc(work_size, GFP_NOIO);
> +	workspace = ceph_kvmalloc(work_size, GFP_NOIO);
>  	if (!workspace) {
>  		crush_destroy(crush);
>  		return -ENOMEM;
> @@ -1052,7 +1069,7 @@ static int osdmap_set_crush(struct ceph_osdmap *map, struct crush_map *crush)
>  
>  	if (map->crush)
>  		crush_destroy(map->crush);
> -	kfree(map->crush_workspace);
> +	kvfree(map->crush_workspace);
>  	map->crush = crush;
>  	map->crush_workspace = workspace;
>  	return 0;
> @@ -1298,9 +1315,9 @@ static int set_primary_affinity(struct ceph_osdmap *map, int osd, u32 aff)
>  	if (!map->osd_primary_affinity) {
>  		int i;
>  
> -		map->osd_primary_affinity = kmalloc_array(map->max_osd,
> -							  sizeof(u32),
> -							  GFP_NOFS);
> +		map->osd_primary_affinity = ceph_kvmalloc(
> +		    array_size(map->max_osd, sizeof(*map->osd_primary_affinity)),
> +		    GFP_NOFS);
>  		if (!map->osd_primary_affinity)
>  			return -ENOMEM;
>  
> @@ -1321,7 +1338,7 @@ static int decode_primary_affinity(void **p, void *end,
>  
>  	ceph_decode_32_safe(p, end, len, e_inval);
>  	if (len == 0) {
> -		kfree(map->osd_primary_affinity);
> +		kvfree(map->osd_primary_affinity);
>  		map->osd_primary_affinity = NULL;
>  		return 0;
>  	}

-- 
Jeff Layton <jlayton@kernel.org>

