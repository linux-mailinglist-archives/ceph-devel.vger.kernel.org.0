Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 264FF83D53
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Aug 2019 00:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfHFW0b (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Aug 2019 18:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:38248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727256AbfHFW0b (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 18:26:31 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1CEBD2086D;
        Tue,  6 Aug 2019 22:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565130389;
        bh=aB18A8wFti+ZkjhM46B14P7bvQfsPH8oq0AhWBsXdxc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=K4l+VBqkG568tWbgpq2WBlSW3phBNmInGPEezFGJnoeMJK/YzTEAe5U1CItNvZzSZ
         x1K7OgZxhqgoA77nro8DnkorVkn+i3N4RaaOCqZriM7C1LqzHrMgbMFJ/3qXGFW7QS
         ozHlPnmvwIa9e1Obgj/Q7AgQ43+JNmZT58g+IfUA=
Message-ID: <d55e535de65df063c8ada3f1cf15c50b716c17c2.camel@kernel.org>
Subject: Re: [PATCH 2/2] ceph: allow arbitrary security.* xattrs
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org
Cc:     ukernel@gmail.com, idryomov@gmail.com, sage@redhat.com
Date:   Tue, 06 Aug 2019 18:26:27 -0400
In-Reply-To: <20190806180019.6213-2-jlayton@kernel.org>
References: <20190806180019.6213-1-jlayton@kernel.org>
         <20190806180019.6213-2-jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2019-08-06 at 14:00 -0400, Jeff Layton wrote:
> Most filesystems don't limit what security.* xattrs can be set or
> fetched. I see no reason that we need to limit that on cephfs either.
> 
> Drop the special xattr handler for "security." xattrs, and allow the
> "other" xattr handler to handle security xattrs as well.
> 
> In addition to fixing xfstest generic/093, this allows us to support
> per-file capabilities (a'la setcap(8)).
> 
> URL: https://tracker.ceph.com/issues/41135
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/xattr.c | 35 ++---------------------------------
>  1 file changed, 2 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 410eaf1ba211..d690debe6ef4 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -20,7 +20,8 @@ static int __remove_xattr(struct ceph_inode_info *ci,
>  
>  static bool ceph_is_valid_xattr(const char *name)
>  {
> -	return !strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) ||
> +	return !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||

Obviously, this should be XATTR_SECURITY_PREFIX_LEN. Fixed in my tree.

> +	       !strncmp(name, XATTR_CEPH_PREFIX, XATTR_CEPH_PREFIX_LEN) ||
>  	       !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) ||
>  	       !strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN);
>  }
> @@ -1265,35 +1266,6 @@ int ceph_security_init_secctx(struct dentry *dentry, umode_t mode,
>  		ceph_pagelist_release(pagelist);
>  	return err;
>  }
> -
> -static int ceph_xattr_set_security_label(const struct xattr_handler *handler,
> -				    struct dentry *unused, struct inode *inode,
> -				    const char *key, const void *buf,
> -				    size_t buflen, int flags)
> -{
> -	if (security_ismaclabel(key)) {
> -		const char *name = xattr_full_name(handler, key);
> -		return __ceph_setxattr(inode, name, buf, buflen, flags);
> -	}
> -	return  -EOPNOTSUPP;
> -}
> -
> -static int ceph_xattr_get_security_label(const struct xattr_handler *handler,
> -				    struct dentry *unused, struct inode *inode,
> -				    const char *key, void *buf, size_t buflen)
> -{
> -	if (security_ismaclabel(key)) {
> -		const char *name = xattr_full_name(handler, key);
> -		return __ceph_getxattr(inode, name, buf, buflen);
> -	}
> -	return  -EOPNOTSUPP;
> -}
> -
> -static const struct xattr_handler ceph_security_label_handler = {
> -	.prefix = XATTR_SECURITY_PREFIX,
> -	.get    = ceph_xattr_get_security_label,
> -	.set    = ceph_xattr_set_security_label,
> -};
>  #endif /* CONFIG_CEPH_FS_SECURITY_LABEL */
>  #endif /* CONFIG_SECURITY */
>  
> @@ -1318,9 +1290,6 @@ const struct xattr_handler *ceph_xattr_handlers[] = {
>  #ifdef CONFIG_CEPH_FS_POSIX_ACL
>  	&posix_acl_access_xattr_handler,
>  	&posix_acl_default_xattr_handler,
> -#endif
> -#ifdef CONFIG_CEPH_FS_SECURITY_LABEL
> -	&ceph_security_label_handler,
>  #endif
>  	&ceph_other_xattr_handler,
>  	NULL,

-- 
Jeff Layton <jlayton@kernel.org>

