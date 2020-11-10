Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC502ACE89
	for <lists+ceph-devel@lfdr.de>; Tue, 10 Nov 2020 05:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKJE2r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Nov 2020 23:28:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729243AbgKJE2q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Nov 2020 23:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604982525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j8Xobc5kf4G1Sirt10BQEEJCujaJs66RHIbk8h+TE8c=;
        b=bIvzltrcjeCfKVgY5I8Gi5LxgQtHt6wVj5bSOzYRF+radKBpgmCIiHwvK2WP/6wVpUjtAI
        gt4BW5WkJWuIZvwQ0S+9DvVnJbbCaQgg1+A6x2g2Z+dNZtevBj7nkjCGrtOE4pCZLxSV13
        ylZ2XUhM9pYaTxAfB1riQL4djIBuAEw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-h1apwsEpPPuF7JDGKHiUag-1; Mon, 09 Nov 2020 23:28:42 -0500
X-MC-Unique: h1apwsEpPPuF7JDGKHiUag-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCCB01007467;
        Tue, 10 Nov 2020 04:28:41 +0000 (UTC)
Received: from [10.72.12.62] (ovpn-12-62.pek2.redhat.com [10.72.12.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72C8E10013D9;
        Tue, 10 Nov 2020 04:28:40 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: acquire Fs caps when getting dir stats
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com
References: <20201103191058.1019442-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <1321776d-1e94-faad-b94d-9b45f327569b@redhat.com>
Date:   Tue, 10 Nov 2020 12:28:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103191058.1019442-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/11/4 3:10, Jeff Layton wrote:
> We only update the inode's dirstats when we have Fs caps from the MDS.
>
> Declare a new VXATTR_FLAG_DIRSTAT that we set on all dirstats, and have
> the vxattr handling code acquire Fs caps when it's set.
>
> URL: https://tracker.ceph.com/issues/48104
> Reported-by: Patrick Donnelly <pdonnell@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/xattr.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index 197cb1234341..0fd05d3d4399 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -42,6 +42,7 @@ struct ceph_vxattr {
>   #define VXATTR_FLAG_READONLY		(1<<0)
>   #define VXATTR_FLAG_HIDDEN		(1<<1)
>   #define VXATTR_FLAG_RSTAT		(1<<2)
> +#define VXATTR_FLAG_DIRSTAT		(1<<3)
>   
>   /* layouts */
>   
> @@ -347,9 +348,9 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
>   	XATTR_LAYOUT_FIELD(dir, layout, object_size),
>   	XATTR_LAYOUT_FIELD(dir, layout, pool),
>   	XATTR_LAYOUT_FIELD(dir, layout, pool_namespace),
> -	XATTR_NAME_CEPH(dir, entries, 0),
> -	XATTR_NAME_CEPH(dir, files, 0),
> -	XATTR_NAME_CEPH(dir, subdirs, 0),
> +	XATTR_NAME_CEPH(dir, entries, VXATTR_FLAG_DIRSTAT),
> +	XATTR_NAME_CEPH(dir, files, VXATTR_FLAG_DIRSTAT),
> +	XATTR_NAME_CEPH(dir, subdirs, VXATTR_FLAG_DIRSTAT),
>   	XATTR_RSTAT_FIELD(dir, rentries),
>   	XATTR_RSTAT_FIELD(dir, rfiles),
>   	XATTR_RSTAT_FIELD(dir, rsubdirs),
> @@ -837,6 +838,8 @@ ssize_t __ceph_getxattr(struct inode *inode, const char *name, void *value,
>   		int mask = 0;
>   		if (vxattr->flags & VXATTR_FLAG_RSTAT)
>   			mask |= CEPH_STAT_RSTAT;
> +		if (vxattr->flags & VXATTR_FLAG_DIRSTAT)
> +			mask |= CEPH_CAP_FILE_SHARED;
>   		err = ceph_do_getattr(inode, mask, true);
>   		if (err)
>   			return err;

Reviewed-by: Xiubo Li <xiubli@redhat.com>

