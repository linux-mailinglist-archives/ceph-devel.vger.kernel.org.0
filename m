Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 669725A778E
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Aug 2022 09:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiHaHfI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 Aug 2022 03:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiHaHfH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 31 Aug 2022 03:35:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CDC2D1D6
        for <ceph-devel@vger.kernel.org>; Wed, 31 Aug 2022 00:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661931303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wIdcurkIynf9UIQI7K+1TrodAX0qrR7z6GYxj/se/n4=;
        b=Jp5tadymvovsgYG1hWFy4n/feDQryqG2uaURtr3wjpSe7GooYVKzemkY3zaadelehtkcHW
        5wz8mVqpxpdc5nwY/zCr0AU8OXxjezdWC++dVjvCCsgk2tPZso0eCIQezSJN+VNyVgb2mP
        SHrhpcTyDLFc915v+LNZqrJIxD4Vuxw=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-252-K5Z_3iz0OsyWqMhN89gU4A-1; Wed, 31 Aug 2022 03:35:02 -0400
X-MC-Unique: K5Z_3iz0OsyWqMhN89gU4A-1
Received: by mail-pf1-f198.google.com with SMTP id k126-20020a628484000000b00536029e722fso5677785pfd.7
        for <ceph-devel@vger.kernel.org>; Wed, 31 Aug 2022 00:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=wIdcurkIynf9UIQI7K+1TrodAX0qrR7z6GYxj/se/n4=;
        b=3cNkip64SnMrWnIN+yqijKD8qPpaUVtDXycsiJ0b0+58Xe3PSmvK2pqqiQS6ke2k1Q
         dLmtRWYoM15Ak0flhjm4VX59EWnVJmoHZpAW+2pMAAGft7y9sCgUDvv8SfvAGhkZRsHq
         JhCg4QFwXd9w3+XBrlH9jI3CPK2rpu9UwCdX0gAr6VdOgWauHwNBPWDHMd7s+AK/5I8l
         bSnd4dfmWPwdMjQUSCxGeneRYny/hFyT9Rf8Tzd4EQor5emfsvoHs/WUj2hcdlKZKYe2
         bdYKvtXqg/GxYxahkriUp2xbGD12Kcz9tBCfZn0cSlGRInrfgLRxYFQ0Yo52KcKFCjXW
         KdEQ==
X-Gm-Message-State: ACgBeo36270PKNIKyCqufbqA/pVyKpSgasxe1ovgRdQRU/f23eGdH/aK
        nJz+wu9QX/c+XUhcsBC65FwYbawhxNqgPYTNQzHXcynbpaEaPkz16t1DvdcQ45g15GES9Fo4gFw
        kiTp45H+FLbwnEI2IIZleMA==
X-Received: by 2002:a17:90b:3b46:b0:1fb:57fc:d0bc with SMTP id ot6-20020a17090b3b4600b001fb57fcd0bcmr1996664pjb.71.1661931301530;
        Wed, 31 Aug 2022 00:35:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4SG+4JBd7Oe2XwibKEFm+PnGCVIaJF+tQ0kgkoPEJu4dc9odXBdGTNmUFA4N0JCvmKbY3r0g==
X-Received: by 2002:a17:90b:3b46:b0:1fb:57fc:d0bc with SMTP id ot6-20020a17090b3b4600b001fb57fcd0bcmr1996649pjb.71.1661931301299;
        Wed, 31 Aug 2022 00:35:01 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x25-20020aa78f19000000b005377c74c409sm10529391pfr.4.2022.08.31.00.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 00:35:01 -0700 (PDT)
Subject: Re: [PATCH] ceph: fix incorrectly showing the .snap size for stat
To:     ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, idryomov@gmail.com, lhenriques@suse.de,
        mchangir@redhat.com
References: <20220831043759.94724-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d0b711eb-4f32-ccd8-09a9-9844bee17e43@redhat.com>
Date:   Wed, 31 Aug 2022 15:34:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220831043759.94724-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/31/22 12:37 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> We should set the 'stat->size' to the real number of snapshots for
> snapdirs.
>
> URL: https://tracker.ceph.com/issues/57342
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/inode.c | 57 +++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 55 insertions(+), 2 deletions(-)
>
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 4db4394912e7..fafdeb169b22 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2705,6 +2705,52 @@ static int statx_to_caps(u32 want, umode_t mode)
>   	return mask;
>   }
>   
> +static struct inode *ceph_get_snap_parent(struct inode *inode)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(sb);
> +	struct ceph_mds_request *req;
> +	struct ceph_vino vino = {
> +		.ino = ceph_ino(inode),
> +		.snap = CEPH_NOSNAP,
> +	};
> +	struct inode *parent;
> +	int mask;
> +	int err;
> +
> +	if (ceph_vino_is_reserved(vino))
> +		return ERR_PTR(-ESTALE);
> +
> +	parent = ceph_find_inode(sb, vino);
> +	if (likely(parent)) {
> +		if (ceph_inode_is_shutdown(parent)) {
> +			iput(parent);
> +			return ERR_PTR(-ESTALE);
> +		}
> +		return parent;
> +	}
> +
> +	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_LOOKUPINO,
> +				       USE_ANY_MDS);
> +	if (IS_ERR(req))
> +		return ERR_CAST(req);
> +
> +	mask = CEPH_STAT_CAP_INODE;
> +	if (ceph_security_xattr_wanted(d_inode(sb->s_root)))
> +		mask |= CEPH_CAP_XATTR_SHARED;
> +	req->r_args.lookupino.mask = cpu_to_le32(mask);
> +	req->r_ino1 = vino;
> +	req->r_num_caps = 1;
> +	err = ceph_mdsc_do_request(mdsc, NULL, req);
> +	if (err < 0)
> +		return ERR_PTR(err);
> +	parent = req->r_target_inode;
> +	if (!parent)
> +		return ERR_PTR(-ESTALE);
> +	ihold(parent);
> +	return parent;
> +}
> +
>   /*
>    * Get all the attributes. If we have sufficient caps for the requested attrs,
>    * then we can avoid talking to the MDS at all.
> @@ -2748,10 +2794,17 @@ int ceph_getattr(struct user_namespace *mnt_userns, const struct path *path,
>   
>   	if (S_ISDIR(inode->i_mode)) {
>   		if (ceph_test_mount_opt(ceph_sb_to_client(inode->i_sb),
> -					RBYTES))
> +					RBYTES)) {
>   			stat->size = ci->i_rbytes;
> -		else
> +		} else if (ceph_snap(inode) == CEPH_SNAPDIR) {
> +			struct inode *parent = ceph_get_snap_parent(inode);
> +			struct ceph_inode_info *pci = ceph_inode(parent);
> +
> +			stat->size = pci->i_rsnaps;

This seems incorrect. i_rsnaps will be the total number of all the snaps 
including the descendants.

I will switch to use the snamrealm instead.

> +			iput(parent);
> +		} else {
>   			stat->size = ci->i_files + ci->i_subdirs;
> +		}
>   		stat->blocks = 0;
>   		stat->blksize = 65536;
>   		/*

