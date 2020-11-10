Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30DC2AD992
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 16:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730917AbgKJPAQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 10 Nov 2020 10:00:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgKJPAQ (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 10 Nov 2020 10:00:16 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4C6E206B2;
        Tue, 10 Nov 2020 15:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605020415;
        bh=W14qN2szGEO2vUU+wAa9EGh4ZpLcaXkxnvV/I+f0eE0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Z31l4jWxDy5kfo01v0iZwvRyZM4wmu+6km2u+klV1q8moXgVW+zLxI3Z7JanIVfVy
         MW26qIQ/A2kQ5twSl68DZE/q6BEN+SKvY3Kfne7bLKrbV4qgCVeYSQdlYWIwPXPeVy
         LDAPZeZfO4fXltdnKVJ1s85DuInvfdhQ6d1IiEpQ=
Message-ID: <cd7f819b4dba68ed3d3e8f107bcb0088d6305965.camel@kernel.org>
Subject: Re: [PATCH v3 1/2] ceph: add status debug file support
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com, idryomov@gmail.com
Cc:     zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Tue, 10 Nov 2020 10:00:13 -0500
In-Reply-To: <20201110141703.414211-2-xiubli@redhat.com>
References: <20201110141703.414211-1-xiubli@redhat.com>
         <20201110141703.414211-2-xiubli@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-11-10 at 22:17 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> This will help list some useful client side info, like the client
> entity address/name and bloclisted status, etc.
> 

"blocklisted"

> URL: https://tracker.ceph.com/issues/48057
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/debugfs.c | 20 ++++++++++++++++++++
>  fs/ceph/super.h   |  1 +
>  2 files changed, 21 insertions(+)
> 
> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
> index 7a8fbe3e4751..4e498a492de4 100644
> --- a/fs/ceph/debugfs.c
> +++ b/fs/ceph/debugfs.c
> @@ -304,11 +304,25 @@ static int mds_sessions_show(struct seq_file *s, void *ptr)
>  	return 0;
>  }
>  
> 
> 
> 
> 
> 
> 
> 
> +static int status_show(struct seq_file *s, void *p)
> +{
> +	struct ceph_fs_client *fsc = s->private;
> +	struct ceph_entity_inst *inst = &fsc->client->msgr.inst;
> +	struct ceph_entity_addr *client_addr = ceph_client_addr(fsc->client);
> +
> +	seq_printf(s, "inst_str: %s.%lld %s/%u\n", ENTITY_NAME(inst->name),

nit: maybe we should call the first field "instance:"

I'll go ahead and fix this up as I merge it. You don't need to resend.

> +		   ceph_pr_addr(client_addr), le32_to_cpu(client_addr->nonce));
> +	seq_printf(s, "blocklisted: %s\n", fsc->blocklisted ? "true" : "false");
> +
> +	return 0;
> +}
> +
>  DEFINE_SHOW_ATTRIBUTE(mdsmap);
>  DEFINE_SHOW_ATTRIBUTE(mdsc);
>  DEFINE_SHOW_ATTRIBUTE(caps);
>  DEFINE_SHOW_ATTRIBUTE(mds_sessions);
>  DEFINE_SHOW_ATTRIBUTE(metric);
> +DEFINE_SHOW_ATTRIBUTE(status);
>  
> 
> 
> 
>  
> 
> 
> 
>  /*
> @@ -394,6 +408,12 @@ void ceph_fs_debugfs_init(struct ceph_fs_client *fsc)
>  						fsc->client->debugfs_dir,
>  						fsc,
>  						&caps_fops);
> +
> +	fsc->debugfs_status = debugfs_create_file("status",
> +						  0400,
> +						  fsc->client->debugfs_dir,
> +						  fsc,
> +						  &status_fops);
>  }
>  
> 
> 
> 
>  
> 
> 
> 
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index f097237a5ad3..5138b75923f9 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -128,6 +128,7 @@ struct ceph_fs_client {
>  	struct dentry *debugfs_bdi;
>  	struct dentry *debugfs_mdsc, *debugfs_mdsmap;
>  	struct dentry *debugfs_metric;
> +	struct dentry *debugfs_status;
>  	struct dentry *debugfs_mds_sessions;
>  #endif
>  
> 
> 
> 

-- 
Jeff Layton <jlayton@kernel.org>

