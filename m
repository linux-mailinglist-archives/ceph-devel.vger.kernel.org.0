Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E87E531104
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 17:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfEaPND (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 31 May 2019 11:13:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:41288 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbfEaPND (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 31 May 2019 11:13:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 94F15AE08;
        Fri, 31 May 2019 15:13:02 +0000 (UTC)
Date:   Fri, 31 May 2019 16:13:01 +0100
From:   Luis Henriques <lhenriques@suse.com>
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     ceph-devel@vger.kernel.org, idryomov@redhat.com, jlayton@redhat.com
Subject: Re: [PATCH 3/3] ceph: fix infinite loop in get_quota_realm()
Message-ID: <20190531151301.GA896@hermes.olymp>
References: <20190531122802.12814-1-zyan@redhat.com>
 <20190531122802.12814-3-zyan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190531122802.12814-3-zyan@redhat.com>
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 31, 2019 at 08:28:02PM +0800, Yan, Zheng wrote:
> get_quota_realm() enters infinite loop if quota inode has no caps.
> This can happen after client gets evicted.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> ---
>  fs/ceph/quota.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
> index d629fc857450..de56dee60540 100644
> --- a/fs/ceph/quota.c
> +++ b/fs/ceph/quota.c
> @@ -135,7 +135,7 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
>  		return NULL;
>  
>  	mutex_lock(&qri->mutex);
> -	if (qri->inode) {
> +	if (qri->inode && ceph_is_any_caps(qri->inode)) {
>  		/* A request has already returned the inode */
>  		mutex_unlock(&qri->mutex);
>  		return qri->inode;
> @@ -146,7 +146,18 @@ static struct inode *lookup_quotarealm_inode(struct ceph_mds_client *mdsc,
>  		mutex_unlock(&qri->mutex);
>  		return NULL;
>  	}
> -	in = ceph_lookup_inode(sb, realm->ino);
> +	if (qri->inode) {
> +		/* get caps */
> +		int ret = __ceph_do_getattr(qri->inode, NULL,
> +					    CEPH_STAT_CAP_INODE, true);
> +		if (ret >= 0)
> +			in = qri->inode;
> +		else
> +			in = ERR_PTR(ret);
> +	}  else {
> +		in = ceph_lookup_inode(sb, realm->ino);
> +	}
> +
>  	if (IS_ERR(in)) {
>  		pr_warn("Can't lookup inode %llx (err: %ld)\n",
>  			realm->ino, PTR_ERR(in));
> -- 
> 2.17.2
> 
> 

Nice catch, thanks!  Feel free to add my

Reviewed-by: Luis Henriques <lhenriques@suse.com>

Cheers,
--
Luís
