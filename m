Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4FF34706C
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Mar 2021 05:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232617AbhCXEMZ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 Mar 2021 00:12:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35332 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229882AbhCXEL4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 00:11:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616559115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DSaUdF3nJvo5zsuYSn/HRlw9un4bfQlSOvPtRi905vg=;
        b=BiA3VXc60NfgZFIVdX+Q7TdpHcirvGoon7bLHHLnEFVraprjNXTDIlBOgimSeRmDHxBl+Y
        67zj6/pddn9Or0r6+Q/xSAm8/hsrIB0Or2lzj3wYypa4yov1JpLPvqY+oZfnfR5RNasD0Y
        96en2tpKB02EViAj5I3gNyMEUKiJLqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-JxaHRFkZPgSGuHmjPbJ0Sw-1; Wed, 24 Mar 2021 00:11:53 -0400
X-MC-Unique: JxaHRFkZPgSGuHmjPbJ0Sw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 02D07190A7A4;
        Wed, 24 Mar 2021 04:11:52 +0000 (UTC)
Received: from [10.72.12.53] (ovpn-12-53.pek2.redhat.com [10.72.12.53])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E66FA68411;
        Wed, 24 Mar 2021 04:11:50 +0000 (UTC)
Subject: Re: [PATCH 1/2] ceph: fix kerneldoc copypasta over
 ceph_start_io_direct
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20210323203326.217781-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <df423f45-807d-eb2e-0bd4-b15919f4891d@redhat.com>
Date:   Wed, 24 Mar 2021 12:11:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323203326.217781-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/3/24 4:33, Jeff Layton wrote:
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/io.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/io.c b/fs/ceph/io.c
> index 97602ea92ff4..c456509b31c3 100644
> --- a/fs/ceph/io.c
> +++ b/fs/ceph/io.c
> @@ -118,7 +118,7 @@ static void ceph_block_buffered(struct ceph_inode_info *ci, struct inode *inode)
>   }
>   
>   /**
> - * ceph_end_io_direct - declare the file is being used for direct i/o
> + * ceph_start_io_direct - declare the file is being used for direct i/o
>    * @inode: file inode
>    *
>    * Declare that a direct I/O operation is about to start, and ensure

Reviewed-by: Xiubo Li <xiubli@redhat.com>

