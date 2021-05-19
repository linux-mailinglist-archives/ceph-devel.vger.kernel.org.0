Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B97388427
	for <lists+ceph-devel@lfdr.de>; Wed, 19 May 2021 02:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhESAy1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 May 2021 20:54:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229597AbhESAyT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 May 2021 20:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621385579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OIAs12n+GZKfv6uvoTiLrLcguW5RvNasNcmlvuIRRLQ=;
        b=blWdMlCsJYS23w4xLgj/aRpWl+9YF9Num1Rg/DcvGSjb9P8jA2tKNYhLgIi15NiCKS04+Y
        5x9NhXkuFa0zLS6Dcrtpm00nwX5nTsgXW9udJCuFuS0ecNzgW5ZLSCzy9TlKXcKVjfaggB
        kc7YruOMLLrYrElUjjyzjq9vIpwjX6M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-nLEwAQyMP1WMIti2nnRzug-1; Tue, 18 May 2021 20:52:57 -0400
X-MC-Unique: nLEwAQyMP1WMIti2nnRzug-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BA8E107ACCA;
        Wed, 19 May 2021 00:52:57 +0000 (UTC)
Received: from [10.72.12.181] (ovpn-12-181.pek2.redhat.com [10.72.12.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C77835C1A1;
        Wed, 19 May 2021 00:52:55 +0000 (UTC)
Subject: Re: [PATCH] ceph: make ceph_queue_cap_snap static
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20210518213628.119867-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <115e9937-bfa1-d498-10e9-4f187e2ad323@redhat.com>
Date:   Wed, 19 May 2021 08:52:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210518213628.119867-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/19/21 5:36 AM, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/snap.c  | 2 +-
>   fs/ceph/super.h | 1 -
>   2 files changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
> index 4ce18055d931..44b380a53727 100644
> --- a/fs/ceph/snap.c
> +++ b/fs/ceph/snap.c
> @@ -460,7 +460,7 @@ static bool has_new_snaps(struct ceph_snap_context *o,
>    * Caller must hold snap_rwsem for read (i.e., the realm topology won't
>    * change).
>    */
> -void ceph_queue_cap_snap(struct ceph_inode_info *ci)
> +static void ceph_queue_cap_snap(struct ceph_inode_info *ci)
>   {
>   	struct inode *inode = &ci->vfs_inode;
>   	struct ceph_cap_snap *capsnap;
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index db80d89556b1..12d30153e4ca 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -931,7 +931,6 @@ extern int ceph_update_snap_trace(struct ceph_mds_client *m,
>   extern void ceph_handle_snap(struct ceph_mds_client *mdsc,
>   			     struct ceph_mds_session *session,
>   			     struct ceph_msg *msg);
> -extern void ceph_queue_cap_snap(struct ceph_inode_info *ci);
>   extern int __ceph_finish_cap_snap(struct ceph_inode_info *ci,
>   				  struct ceph_cap_snap *capsnap);
>   extern void ceph_cleanup_empty_realms(struct ceph_mds_client *mdsc);

Reviewed-by: Xiubo Li <xiubli@redhat.com>


