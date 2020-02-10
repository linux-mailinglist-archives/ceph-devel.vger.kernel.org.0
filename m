Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6E1157DD0
	for <lists+ceph-devel@lfdr.de>; Mon, 10 Feb 2020 15:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgBJOw3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 10 Feb 2020 09:52:29 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36677 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727810AbgBJOw3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 09:52:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581346348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a0ETSlMoybwa8k94a7pQROr6wiVedgU9xB+s48BEh94=;
        b=cS+l0KW7zefSkci2S8GZbHF1aZqOIAoRfQY27YdhU41J5P/Eeyn2jmKogGhbUqvCPAHKVP
        rpBPXJeSrggdeo8QXLqWyPIUppV6yaTu2yr3Nmb/DLd4ppbkO6QfRQWXZpYy60Y6OGpbKn
        w22vGgFkxvzA5wl57YIZERMCOdzfDjQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-8A7Hzx4PPoiy9gpCtW_dmg-1; Mon, 10 Feb 2020 09:52:24 -0500
X-MC-Unique: 8A7Hzx4PPoiy9gpCtW_dmg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 763A8100551C;
        Mon, 10 Feb 2020 14:52:23 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DDB85DA82;
        Mon, 10 Feb 2020 14:52:15 +0000 (UTC)
Subject: Re: [PATCH] ceph: fix posix acl couldn't be settable
To:     jlayton@kernel.org, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, dhowells@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200210135841.21177-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <e2614ef4-7dc1-d9ac-752a-d48b806dd561@redhat.com>
Date:   Mon, 10 Feb 2020 22:52:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200210135841.21177-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/10 21:58, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> For the old mount API, the module parameters parseing function will
> be called in ceph_mount() and also just after the default posix acl
> flag set, so we can control to enable/disable it via the mount option.
>
> But for the new mount API, it will call the module parameters
> parseing function before ceph_get_tree(), so the posix acl will always
> be enabled.
>
> Fixes: 82995cc6c5ae ("libceph, rbd, ceph: convert to use the new mount API")
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/super.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 5fef4f59e13e..69fa498391dc 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -341,6 +341,10 @@ static int ceph_parse_mount_param(struct fs_context *fc,
>   	unsigned int mode;
>   	int token, ret;
>   
> +#ifdef CONFIG_CEPH_FS_POSIX_ACL
> +	fc->sb_flags |= SB_POSIXACL;
> +#endif
> +

Maybe we should move this to ceph_init_fs_context().

>   	ret = ceph_parse_param(param, pctx->copts, fc);
>   	if (ret != -ENOPARAM)
>   		return ret;
> @@ -1089,10 +1093,6 @@ static int ceph_get_tree(struct fs_context *fc)
>   	if (!fc->source)
>   		return invalf(fc, "ceph: No source");
>   
> -#ifdef CONFIG_CEPH_FS_POSIX_ACL
> -	fc->sb_flags |= SB_POSIXACL;
> -#endif
> -
>   	/* create client (which we may/may not use) */
>   	fsc = create_fs_client(pctx->opts, pctx->copts);
>   	pctx->opts = NULL;


