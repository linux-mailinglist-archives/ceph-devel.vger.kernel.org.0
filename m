Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011174633D1
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Nov 2021 13:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbhK3MKx (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Nov 2021 07:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbhK3MKw (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Nov 2021 07:10:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B250DC061574
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 04:07:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B6CFCE191D
        for <ceph-devel@vger.kernel.org>; Tue, 30 Nov 2021 12:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A37C53FC7;
        Tue, 30 Nov 2021 12:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274050;
        bh=KLjFb5nE/43PCqojUgo0v9X53QYWDM19LsvRYYDRn2s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NLwrmKO7TZTQHQJGAJ5lbaNHEdN2jHuZamzveeWKvYAejDkXwjGGa92YXrt0fwM7a
         YC+IZ7vk8raekm5DeZik76Hjq/Q5pqt7loJb9xucZZsWwllvG8aj2V6NJGA0sc982z
         4chguyVCxAcNDMalD+ud3dI+5E+UMd8T6g1E18KlYi/Q6z0W/HFpOr9GGD5S6/+wsw
         S2NeMms07ANgdhE3mfifuP3FD8NSW/petEUlAqqAuaVKMHBrB+9U26uEZ/kgE0YfOx
         B+VfsgZCTXoIceW9RKpmOtqms24qSBtA5p4HQXGp/snr9K9w4XVzXHztiliBFDCLxd
         qjc6SYd5WnFLA==
Message-ID: <41b05af2020a3cb345a16f5dfca15f6f5f41bfe4.camel@kernel.org>
Subject: Re: [PATCH] ceph: initialize pathlen variable in reconnect_caps_cb
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org, dan.carpenter@oracle.com
Date:   Tue, 30 Nov 2021 07:07:28 -0500
In-Reply-To: <20211130112034.2711318-1-xiubli@redhat.com>
References: <20211130112034.2711318-1-xiubli@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2021-11-30 at 19:20 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> Silence the potential compiler warning.
> 
> Fixes: a33f6432b3a6 (ceph: encode inodes' parent/d_name in cap reconnect message)
> Signed-off-by: Xiubo Li <xiubli@redhat.com>

Is this something we need to fix? AFAICT, there is no bug here.

In the case where ceph_mdsc_build_path returns an error, "path" will be
an ERR_PTR and then ceph_mdsc_free_path will be a no-op. If we do need
to take this, we should probably also credit Dan for finding it.

> ---
>  fs/ceph/mds_client.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 87f20ed16c6e..2fc2b0a023e4 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -3711,7 +3711,7 @@ static int reconnect_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  	struct ceph_pagelist *pagelist = recon_state->pagelist;
>  	struct dentry *dentry;
>  	char *path;
> -	int pathlen, err;
> +	int pathlen = 0, err;
>  	u64 pathbase;
>  	u64 snap_follows;
>  

If we do take this, you can also get rid of the place where pathlen is
set in the !dentry case.

-- 
Jeff Layton <jlayton@kernel.org>
