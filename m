Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193F534C263
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Mar 2021 06:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhC2EAI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 29 Mar 2021 00:00:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230509AbhC2D7x (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 28 Mar 2021 23:59:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616990393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wboDHPymzPgnM1UEvzsHeIcsA917Pxs7ewoTu3RFYtk=;
        b=hsymBbo/vE+KlUqR9gP22Eo7MV4waXYG0KBF/dYsGThLmzHLuvh0MtJeI25iDB3Gy7gzwv
        C/3ziyjcZov/VpCQ2xBQv6jydp3NEjYHpx5FyP+qslCy6/ertqCIto0hh3yc26YUAafTIi
        InDLGjFpT0c6cZt76bPE4UL2HRjv7XE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-rwc1cWS5N6uQ2H_uD7wddA-1; Sun, 28 Mar 2021 23:59:49 -0400
X-MC-Unique: rwc1cWS5N6uQ2H_uD7wddA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6451E8189EB;
        Mon, 29 Mar 2021 03:59:41 +0000 (UTC)
Received: from [10.72.12.18] (ovpn-12-18.pek2.redhat.com [10.72.12.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C3FF4694CD;
        Mon, 29 Mar 2021 03:59:39 +0000 (UTC)
Subject: Re: [PATCH] ceph: only check pool permissions for regular files
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Luis Henriques <lhenriques@suse.de>
References: <20210325165606.41943-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <dd18d0e4-b8e3-2d01-ac8c-ec9952cd2292@redhat.com>
Date:   Mon, 29 Mar 2021 11:59:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210325165606.41943-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/3/26 0:56, Jeff Layton wrote:
> There is no need to do a ceph_pool_perm_check() on anything that isn't a
> regular file, as the MDS is what handles talking to the OSD in those
> cases. Just return 0 if it's not a regular file.
>
> Reported-by: Luis Henriques <lhenriques@suse.de>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/addr.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
> index d26a88aca014..07cbf21099b8 100644
> --- a/fs/ceph/addr.c
> +++ b/fs/ceph/addr.c
> @@ -1940,6 +1940,10 @@ int ceph_pool_perm_check(struct inode *inode, int need)
>   	s64 pool;
>   	int ret, flags;
>   
> +	/* Only need to do this for regular files */
> +	if (!S_ISREG(inode->i_mode))
> +		return 0;
> +
>   	if (ci->i_vino.snap != CEPH_NOSNAP) {
>   		/*
>   		 * Pool permission check needs to write to the first object.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

