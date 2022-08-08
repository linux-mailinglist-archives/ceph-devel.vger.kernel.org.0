Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7AA58C19C
	for <lists+ceph-devel@lfdr.de>; Mon,  8 Aug 2022 04:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242069AbiHHC2f (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 7 Aug 2022 22:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243574AbiHHC2K (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 7 Aug 2022 22:28:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4B981027
        for <ceph-devel@vger.kernel.org>; Sun,  7 Aug 2022 19:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659925613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f93ca8gVEP0XUmTkYFbWUPC6+gqcikXlFlS0D/m53BU=;
        b=czkyE4ikWPiMQGbomGaoNPkHpeOirR5now5j0i1TfAJsaARoPh+LsNjEErBBRsKIMOI33C
        M56fMky5pGopku4/ExkB5I+h0QNxm9EqvyMiFCwZhFG1+fHyEY7cpRbHN8q5Cg2KpvkiPN
        vuduJLR0RA3lXTavyOPgmPuTo7r1/DI=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-lMXG_LT-MXy3vZtbVmITpg-1; Sun, 07 Aug 2022 22:26:52 -0400
X-MC-Unique: lMXG_LT-MXy3vZtbVmITpg-1
Received: by mail-pf1-f199.google.com with SMTP id by13-20020a056a00400d00b0052ec5a1cd4dso2747734pfb.21
        for <ceph-devel@vger.kernel.org>; Sun, 07 Aug 2022 19:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject
         :x-gm-message-state:from:to:cc;
        bh=f93ca8gVEP0XUmTkYFbWUPC6+gqcikXlFlS0D/m53BU=;
        b=MK3TNLnQN7xZolVOQ2nEqJJmX+crOvzl20xsS+BGPuww6EXg6Kji0kB2Cht1w8Fqjn
         vXG8R9/RIgTRl6g/4s94/RIDquzJ5bgL4Ij/LOIGAWh/saW6XygPEuday/dVNnSb7lnH
         5EeTQf4KjKWef6nf61ZqbtpZ6g7WvZPumvlWg9gjPlg6KOfnBYgq+40FEvWIP3+qfLma
         cCnuPZ535YYq8f2RrDbBNxd8OgR7q6d3gbp+mE1iOzCiAbGNdS6eo9QkbWge2snqnABW
         EIEakb2JYBdnr/9yMRbTfEQBE6cR08th3nYJX7vMv//58owu5xzvcZQnLcJmj3U/ACUg
         jDWw==
X-Gm-Message-State: ACgBeo1F/ntYI945qNQ90ZGfyuCqFav30BCkSx2V+wrMugTEIP0L/g47
        61AYomESDnLZcM5YcuReo8xk4U8lj28iImYD8iUM/ZE9HP6ej6yfRTgvL+lbk5ZHxH4/xbGlEGp
        q3Kf/E0bXpIg2G9tIzLmi2N/0daBDAIVAF8iazD/x2Ffg4e3sY/5T1Tslbms/rO9t6Exhxfk=
X-Received: by 2002:a17:902:ce04:b0:16c:e142:5dd7 with SMTP id k4-20020a170902ce0400b0016ce1425dd7mr17089779plg.173.1659925610820;
        Sun, 07 Aug 2022 19:26:50 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6jqToasWXs/1MxF7hIigVGSnbf58E3mmR3AEs0myNgKdMbsL9HA/kjfaOlFRZafMBQsSo7vw==
X-Received: by 2002:a17:902:ce04:b0:16c:e142:5dd7 with SMTP id k4-20020a170902ce0400b0016ce1425dd7mr17089756plg.173.1659925610338;
        Sun, 07 Aug 2022 19:26:50 -0700 (PDT)
Received: from [10.72.12.61] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d10-20020a17090a6a4a00b001f021cdd73dsm9429686pjm.10.2022.08.07.19.26.48
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Aug 2022 19:26:50 -0700 (PDT)
Subject: Re: [PATCH v2] ceph: fail the request if the peer MDS doesn't support
 getvxattr op
To:     Ceph Development <ceph-devel@vger.kernel.org>
References: <20220803091844.608743-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <410b98a3-2be6-0584-9c19-7206ef69a54d@redhat.com>
Date:   Mon, 8 Aug 2022 10:26:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220803091844.608743-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/3/22 5:18 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> Just fail the request instead sending the request out, or the peer
> MDS will crash.
>
> URL: https://tracker.ceph.com/issues/56529
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - Sync to the https://github.com/ceph/ceph/pull/47063. Will return -EOPNOTSUPP
>    directly instead of falling back to old method.
>
As discussed in the PR#47063, it has switched to -ENODATA instead.

I will post the V3 to fix it.

Thanks!


>   fs/ceph/inode.c      |  1 +
>   fs/ceph/mds_client.c | 11 +++++++++++
>   fs/ceph/mds_client.h |  6 +++++-
>   fs/ceph/xattr.c      |  6 +-----
>   4 files changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 79ff197c7cc5..cfa0b550eef2 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2607,6 +2607,7 @@ int ceph_do_getvxattr(struct inode *inode, const char *name, void *value,
>   		goto out;
>   	}
>   
> +	req->r_feature_needed = CEPHFS_FEATURE_OP_GETVXATTR;
>   	req->r_path2 = kstrdup(name, GFP_NOFS);
>   	if (!req->r_path2) {
>   		err = -ENOMEM;
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 598012ddc401..e3683305445c 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2501,6 +2501,7 @@ ceph_mdsc_create_request(struct ceph_mds_client *mdsc, int op, int mode)
>   	INIT_LIST_HEAD(&req->r_unsafe_dir_item);
>   	INIT_LIST_HEAD(&req->r_unsafe_target_item);
>   	req->r_fmode = -1;
> +	req->r_feature_needed = -1;
>   	kref_init(&req->r_kref);
>   	RB_CLEAR_NODE(&req->r_node);
>   	INIT_LIST_HEAD(&req->r_wait);
> @@ -3255,6 +3256,16 @@ static void __do_request(struct ceph_mds_client *mdsc,
>   
>   	dout("do_request mds%d session %p state %s\n", mds, session,
>   	     ceph_session_state_name(session->s_state));
> +
> +	/*
> +	 * The old ceph will crash the MDSs when see unknown OPs
> +	 */
> +	if (req->r_feature_needed > 0 &&
> +	    !test_bit(req->r_feature_needed, &session->s_features)) {
> +		err = -EOPNOTSUPP;
> +		goto out_session;
> +	}
> +
>   	if (session->s_state != CEPH_MDS_SESSION_OPEN &&
>   	    session->s_state != CEPH_MDS_SESSION_HUNG) {
>   		/*
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index e15ee2858fef..728b7d72bf76 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -31,8 +31,9 @@ enum ceph_feature_type {
>   	CEPHFS_FEATURE_METRIC_COLLECT,
>   	CEPHFS_FEATURE_ALTERNATE_NAME,
>   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> +	CEPHFS_FEATURE_OP_GETVXATTR,
>   
> -	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_NOTIFY_SESSION_STATE,
> +	CEPHFS_FEATURE_MAX = CEPHFS_FEATURE_OP_GETVXATTR,
>   };
>   
>   #define CEPHFS_FEATURES_CLIENT_SUPPORTED {	\
> @@ -45,6 +46,7 @@ enum ceph_feature_type {
>   	CEPHFS_FEATURE_METRIC_COLLECT,		\
>   	CEPHFS_FEATURE_ALTERNATE_NAME,		\
>   	CEPHFS_FEATURE_NOTIFY_SESSION_STATE,	\
> +	CEPHFS_FEATURE_OP_GETVXATTR,		\
>   }
>   
>   /*
> @@ -352,6 +354,8 @@ struct ceph_mds_request {
>   	long long	  r_dir_ordered_cnt;
>   	int		  r_readdir_cache_idx;
>   
> +	int		  r_feature_needed;
> +
>   	struct ceph_cap_reservation r_caps_reservation;
>   };
>   
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index b10d459c2326..5f29c1f08de1 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -983,11 +983,7 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>   		}
>   		return err;
>   	} else {
> -		err = ceph_do_getvxattr(inode, name, value, size);
> -		/* this would happen with a new client and old server combo */
> -		if (err == -EOPNOTSUPP)
> -			err = -ENODATA;
> -		return err;
> +		return ceph_do_getvxattr(inode, name, value, size);
>   	}
>   handle_non_vxattrs:
>   	req_mask = __get_request_mask(inode);

