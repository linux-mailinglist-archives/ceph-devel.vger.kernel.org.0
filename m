Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5585175F76
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Mar 2020 17:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgCBQXD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Mar 2020 11:23:03 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40797 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726831AbgCBQXD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 2 Mar 2020 11:23:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583166181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nPhbYNyMRKcVGvyxS3LOBilEt7WE4dCu2KTx/2yI32g=;
        b=KZQ2c5gRujDmr722aCqqVM5bS5Y69anupJEwJJ3GOk7AmmlNxSMrGAnmKHZbeWGOmDjS7N
        qleJcPhBAGxkShDnIlPjr7Mvgr/jrzS9fLg7P9XNJ9Kt2zSOAew6VHsF2HuRAYcFb/DQ5q
        wQFc9EWDUjaOWCWceCCIHrglVxt0uf4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-Rt67fG4rPOaAe0nLIT5Vpg-1; Mon, 02 Mar 2020 11:23:00 -0500
X-MC-Unique: Rt67fG4rPOaAe0nLIT5Vpg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4610FDB64;
        Mon,  2 Mar 2020 16:22:59 +0000 (UTC)
Received: from [10.72.12.56] (ovpn-12-56.pek2.redhat.com [10.72.12.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 227015C1B0;
        Mon,  2 Mar 2020 16:22:53 +0000 (UTC)
Subject: Re: [PATCH v6 00/13] ceph: async directory operations support
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com, sage@redhat.com, pdonnell@redhat.com
References: <20200302141434.59825-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <544d98ca-6dc9-bcda-3f99-ff87f646265c@redhat.com>
Date:   Tue, 3 Mar 2020 00:22:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302141434.59825-1-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 3/2/20 10:14 PM, Jeff Layton wrote:
> v6: move handling of CEPH_I_ASYNC_CREATE from __send_cap into callers
>      also issue ceph_mdsc_release_dir_caps() in complete_request
>      properly handle -EJUKEBOX return in async callbacks
>      
> I previously pulled the async unlink patch from ceph-client/testing, so
> this set includes a revised version of that as well, and orders it
> some other changes.
> 
> The main change from v5 is to rework the callers of __send_cap to either
> skip sending or wait if the create reply hasn't come in yet.
> 
> We may not actually need patch #7 here. Zheng had that delta in one
> of the earlier patches, but I'm not sure it's really needed now. It
> may make sense to just take it on its own merits though.
> 
> Jeff Layton (12):
>    ceph: make kick_flushing_inode_caps non-static
>    ceph: add flag to designate that a request is asynchronous
>    ceph: track primary dentry link
>    ceph: add infrastructure for waiting for async create to complete
>    ceph: make __take_cap_refs non-static
>    ceph: cap tracking for async directory operations
>    ceph: perform asynchronous unlink if we have sufficient caps
>    ceph: make ceph_fill_inode non-static
>    ceph: decode interval_sets for delegated inos
>    ceph: add new MDS req field to hold delegated inode number
>    ceph: cache layout in parent dir on first sync create
>    ceph: attempt to do async create when possible
> 
> Yan, Zheng (1):
>    ceph: don't take refs to want mask unless we have all bits
> 
>   fs/ceph/caps.c               |  91 ++++++++----
>   fs/ceph/dir.c                | 111 ++++++++++++++-
>   fs/ceph/file.c               | 269 +++++++++++++++++++++++++++++++++--
>   fs/ceph/inode.c              |  58 ++++----
>   fs/ceph/mds_client.c         | 196 ++++++++++++++++++++++---
>   fs/ceph/mds_client.h         |  24 +++-
>   fs/ceph/super.c              |  20 +++
>   fs/ceph/super.h              |  23 ++-
>   include/linux/ceph/ceph_fs.h |  17 ++-
>   9 files changed, 724 insertions(+), 85 deletions(-)
> 


series

Reviewed-by: "Yan, Zheng" <zyan@redhat.com>

