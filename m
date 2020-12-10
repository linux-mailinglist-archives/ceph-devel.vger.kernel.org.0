Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF2F2D50CF
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Dec 2020 03:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgLJCUy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Dec 2020 21:20:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728493AbgLJCUx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Dec 2020 21:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607566767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vtc4YGxMlI2J37sNOg7+nMPx60IADmmPgmA+tOTxz1U=;
        b=QXYQBWoTcUKbrbTRvQ8ANUbEexrxffKIds9FdHaJ6QXDl3636W7qlmj0k5zXuWxcfvMnuT
        +sOD0dQUADPPloK6Fw00yFTI6v9qBps6Pvm6hVvbthTVUbdb96FdUzbAEs3nNBQFv59MEW
        cNFGYGdKsfxSm77JS1NPdwy9sMgEYLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-H5bkjoVPO7aoKhUhAieAvQ-1; Wed, 09 Dec 2020 21:19:23 -0500
X-MC-Unique: H5bkjoVPO7aoKhUhAieAvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8E0A107ACE6;
        Thu, 10 Dec 2020 02:19:22 +0000 (UTC)
Received: from [10.72.12.33] (ovpn-12-33.pek2.redhat.com [10.72.12.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B26D65D6A1;
        Thu, 10 Dec 2020 02:19:20 +0000 (UTC)
Subject: Re: [PATCH 0/4] ceph: implement later versions of MClientRequest
 headers
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     pdonnell@redhat.com, idryomov@gmail.com
References: <20201209185354.29097-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <916fd7f8-cb01-c923-ff91-d34bb5cb6b43@redhat.com>
Date:   Thu, 10 Dec 2020 10:19:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201209185354.29097-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/12/10 2:53, Jeff Layton wrote:
> A few years ago, userland ceph added support for changing the birthtime
> via setattr, as well as support for sending supplementary groups in a
> MDS request.
>
> This patchset updates the kclient to use the newer protocol. The
> necessary structures are extended and the code is changed to support the
> newer formats when it detects that the MDS will support it.
>
> Supplementary groups will now be transmitted in the request, but for now
> the setting of btime is not implemented.
>
> This is a prerequisite step to adding support for the new "alternate
> name" field that Xiubo has been working on, which we'll need for
> proper fscrypt support.
>
> Jeff Layton (4):
>    ceph: don't reach into request header for readdir info
>    ceph: take a cred reference instead of tracking individual uid/gid
>    ceph: clean up argument lists to __prepare_send_request and
>      __send_request
>    ceph: implement updated ceph_mds_request_head structure
>
>   fs/ceph/inode.c              |  5 +-
>   fs/ceph/mds_client.c         | 98 ++++++++++++++++++++++++++----------
>   fs/ceph/mds_client.h         |  3 +-
>   include/linux/ceph/ceph_fs.h | 32 +++++++++++-
>   4 files changed, 106 insertions(+), 32 deletions(-)
>
This series looks good to me.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

