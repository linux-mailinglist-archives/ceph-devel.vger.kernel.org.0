Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4B34C226
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Mar 2021 05:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhC2DK5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 28 Mar 2021 23:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40891 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230243AbhC2DK4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 28 Mar 2021 23:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616987455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=176hVXBqNsib9v5dmxNV3S8ZkPoDNuGKMCXJqfOIcEM=;
        b=Nr5wP+zmmz1SSTEezYOFimYWwM5n47qGdtAltY6WXoZFJLsIsAElqyVzZWthauT97+ud1d
        LybrbnkOzCgkcVcjIneqJmfhKI6MgQCaH/f8umIhvJxQSx0o5EJFxV6qdS9wU7Vjf9p3Q9
        7sl8HnQTN1VOfaJUWKpiQv8rvHlZg0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-Wpoi_T3XPJ2vKK5AsbGpBQ-1; Sun, 28 Mar 2021 23:10:51 -0400
X-MC-Unique: Wpoi_T3XPJ2vKK5AsbGpBQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1529F180FCA0;
        Mon, 29 Mar 2021 03:10:50 +0000 (UTC)
Received: from [10.72.12.18] (ovpn-12-18.pek2.redhat.com [10.72.12.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7A5F41037E83;
        Mon, 29 Mar 2021 03:10:48 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix inode leak on getattr error in __fh_to_dentry
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, Luis Henriques <lhenriques@suse.de>
References: <20210326154032.86410-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <564ba8c9-4e9b-f0f5-0db5-fb961ca47075@redhat.com>
Date:   Mon, 29 Mar 2021 11:10:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210326154032.86410-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/3/26 23:40, Jeff Layton wrote:
> Cc: Luis Henriques <lhenriques@suse.de>
> Fixes: 878dabb64117 (ceph: don't return -ESTALE if there's still an open file)
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/export.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> index f22156ee7306..17d8c8f4ec89 100644
> --- a/fs/ceph/export.c
> +++ b/fs/ceph/export.c
> @@ -178,8 +178,10 @@ static struct dentry *__fh_to_dentry(struct super_block *sb, u64 ino)
>   		return ERR_CAST(inode);
>   	/* We need LINK caps to reliably check i_nlink */
>   	err = ceph_do_getattr(inode, CEPH_CAP_LINK_SHARED, false);
> -	if (err)
> +	if (err) {
> +		iput(inode);
>   		return ERR_PTR(err);
> +	}
>   	/* -ESTALE if inode as been unlinked and no file is open */
>   	if ((inode->i_nlink == 0) && (atomic_read(&inode->i_count) == 1)) {
>   		iput(inode);

Reviewed-by: Xiubo Li <xiubli@redhat.com>

