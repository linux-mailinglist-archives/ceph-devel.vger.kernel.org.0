Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254E7443D74
	for <lists+ceph-devel@lfdr.de>; Wed,  3 Nov 2021 07:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhKCHAA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 3 Nov 2021 03:00:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22671 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230152AbhKCG7y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 3 Nov 2021 02:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635922638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PwoKxjATsG3++nMtKtDrI5to9qh83kc0OeJrprl6nAA=;
        b=cH+YIGUbdrTBehO/hOpwLT/rcgxmLZUAd42rhp7pPAdcvgCafH36ZOdiGGj8FOb96K3IKs
        5eoRnY2g43YdrvuwZYIlVoteQI86YFAxaC3zF+r356JdhMFO+H+qhDYQVavOz0GTu91KR6
        uCsvL5MOtTiFL2mEWswKmEEfr6fO9Fc=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-9QnXCehWMCavca1BveE1VQ-1; Wed, 03 Nov 2021 02:57:17 -0400
X-MC-Unique: 9QnXCehWMCavca1BveE1VQ-1
Received: by mail-pj1-f69.google.com with SMTP id p19-20020a17090a429300b001a1fd412f57so534425pjg.9
        for <ceph-devel@vger.kernel.org>; Tue, 02 Nov 2021 23:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PwoKxjATsG3++nMtKtDrI5to9qh83kc0OeJrprl6nAA=;
        b=BFwa8r2bl4I/KmwTS9cWyifaiemoahFzBx7OFJ9A8lsn464qqTtX5frl9V4z9dVnt8
         1ds41/UxZjtfAts5Icu+wriAMUhxLe7ZJ9ZgMj8I/AffI2N2XXzAQhlQ8BEtqqKRJi3v
         MCh3iTZ3UcrHlB7wk1EFZZ2CjmggiOpLpBSMERHYegm7HNmJ5szcWyDh1XOOwTmA8PmY
         e6mLrtzovlXNJTnSLypEPonxWvEXt1JzpyndAtu4ND4ureXAxwsdkMkRw2+iNJk0ugY7
         K8QlJzccxwmm4DIKZqfAyAaeMeG2uKxhLUS4tBc0RhC4Zn4VeGhrd+zXiaHi8LaEio7K
         Nnew==
X-Gm-Message-State: AOAM530EwCNeWbsF9H5JKLheMLF1g4IWmn12LWK8CmhPSfDu1eTFmKHd
        uAI3U1P2RDjhpXk6toIsYrh80nWUfJapI7gCdNgMevWs7665VEUIe2/caB5PNhW9VettC9XuAYz
        mEOfcT0gTCUNCgbm6i6n2SQ==
X-Received: by 2002:a65:62d5:: with SMTP id m21mr32393532pgv.124.1635922635538;
        Tue, 02 Nov 2021 23:57:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzS8iLup0ncInhYC8MLLxzV6WuxaRVjydZ/DrSUukoa6gjz7iPInOCdDRFqQCGCix/SrK0gMg==
X-Received: by 2002:a65:62d5:: with SMTP id m21mr32393515pgv.124.1635922635278;
        Tue, 02 Nov 2021 23:57:15 -0700 (PDT)
Received: from [10.72.12.174] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id co4sm4434542pjb.2.2021.11.02.23.57.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 23:57:14 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: properly handle statfs on multifs setups
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        idryomov@gmail.com
Cc:     Sachin Prabhu <sprabhu@redhat.com>
References: <20211102204547.253710-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <fcdeaedc-ab5d-6c0c-d6b2-a59e302975ef@redhat.com>
Date:   Wed, 3 Nov 2021 14:56:50 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211102204547.253710-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/3/21 4:45 AM, Jeff Layton wrote:
> ceph_statfs currently stuffs the cluster fsid into the f_fsid field.
> This was fine when we only had a single filesystem per cluster, but now
> that we have multiples we need to use something that will vary between
> them.
>
> Change ceph_statfs to xor each 32-bit chunk of the fsid (aka cluster id)
> into the lower bits of the statfs->f_fsid. Change the lower bits to hold
> the fscid (filesystem ID within the cluster).
>
> That should give us a value that is guaranteed to be unique between
> filesystems within a cluster, and should minimize the chance of
> collisions between mounts of different clusters.
>
> URL: https://tracker.ceph.com/issues/52812
> Reported-by: Sachin Prabhu <sprabhu@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/super.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>
> While looking at making an equivalent change to the userland libraries,
> it occurred to me that the earlier patch's method for computing this
> was overly-complex. This makes it a bit simpler, and avoids the
> intermediate step of setting up a u64.
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9bb88423417e..e7b839aa08f6 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -52,8 +52,7 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
>   	struct ceph_fs_client *fsc = ceph_inode_to_client(d_inode(dentry));
>   	struct ceph_mon_client *monc = &fsc->client->monc;
>   	struct ceph_statfs st;
> -	u64 fsid;
> -	int err;
> +	int i, err;
>   	u64 data_pool;
>   
>   	if (fsc->mdsc->mdsmap->m_num_data_pg_pools == 1) {
> @@ -99,12 +98,14 @@ static int ceph_statfs(struct dentry *dentry, struct kstatfs *buf)
>   	buf->f_namelen = NAME_MAX;
>   
>   	/* Must convert the fsid, for consistent values across arches */
> +	buf->f_fsid.val[0] = 0;
>   	mutex_lock(&monc->mutex);
> -	fsid = le64_to_cpu(*(__le64 *)(&monc->monmap->fsid)) ^
> -	       le64_to_cpu(*((__le64 *)&monc->monmap->fsid + 1));
> +	for (i = 0; i < 4; ++i)
> +		buf->f_fsid.val[0] ^= le32_to_cpu(((__le32 *)&monc->monmap->fsid)[i]);
>   	mutex_unlock(&monc->mutex);
>   
> -	buf->f_fsid = u64_to_fsid(fsid);
> +	/* fold the fs_cluster_id into the upper bits */
> +	buf->f_fsid.val[1] = monc->fs_cluster_id;
>   
>   	return 0;
>   }

This version looks better.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


