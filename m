Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F57B13DB33
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Jan 2020 14:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbgAPNKm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 08:10:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36665 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727011AbgAPNKm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 08:10:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579180240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fx9JtdxtmI17REA3aSFGNT2JhmbhQ4Mc4qtLSGZMyG4=;
        b=CtpRfm9a6vAhD9JXtfTNF4t6ReBASu24VHtQ2wnumkgW/9cqkTQ4rv4TeEvpDkRZZ8d7W8
        O082FfL1TM666/thp1io9Pne5/iOwCml5Ics2MoWPoiqJ+4U2kJkeQpEa7iETat14thwLl
        t3jj4jAJ5UxdyC2CZ6FGdSK6nvRmDqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-HA_1CfmmMAG8iNBjvZgqJg-1; Thu, 16 Jan 2020 08:10:39 -0500
X-MC-Unique: HA_1CfmmMAG8iNBjvZgqJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E92E5107ACC5;
        Thu, 16 Jan 2020 13:10:37 +0000 (UTC)
Received: from [10.72.12.100] (ovpn-12-100.pek2.redhat.com [10.72.12.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01EA55D9C9;
        Thu, 16 Jan 2020 13:10:32 +0000 (UTC)
Subject: Re: [RFC PATCH v2 00/10] ceph: asynchronous file create support
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        xiubli@redhat.com
References: <20200115205912.38688-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <bf9f8483-c00f-4c2f-aadd-f9ca02757ae5@redhat.com>
Date:   Thu, 16 Jan 2020 21:10:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200115205912.38688-1-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/16/20 4:59 AM, Jeff Layton wrote:
> v2:
> - move cached layout to dedicated field in inode
> - protect cached layout with i_ceph_lock
> - wipe cached layout in __check_cap_issue
> - set max_size of file to layout.stripe_unit
> - set truncate_size to (u64)-1
> - use dedicated CephFS feature bit instead of CEPHFS_FEATURE_OCTOPUS
> - set cap_id to 1 in async created inode
> - allocate inode number before submitting request
> - rework the prep for an async create to be more efficient
> - don't allow MDS or cap messages involving an inode until we get async
>    create reply
> 
> A lot of changes in this set, mostly based on Zheng and Xiubo's
> comments. Performance is pretty similar to the previous set:
> 
> Untarring a kernel tarball into a cephfs takes about 98s with
> async dirops disabled. With them enabled, it takes around 78s,
> which is about a 25% improvement.
> 
> This is not quite ready for merge. Error handling could still be
> improved. With xfstest generic/531, I see some messages like this pop
> up in the ring buffer:
> 
>      [ 7331.393110] ceph: ceph_async_create_cb: inode number mismatch! err=0 deleg_ino=0x100001232d9 target=0x100001232b9
> 

how about always set O_EXCL flag in async create request. It may help to 
debug this issue.

> Basically, we went to do an async create and got a different inode
> number back than expected. That still needs investigation, but I
> didn't see any test failures due to it.
> 
> Jeff Layton (10):
>    libceph: export ceph_file_layout_is_valid
>    ceph: make ceph_fill_inode non-static
>    ceph: make dentry_lease_is_valid non-static
>    ceph: make __take_cap_refs a public function
>    ceph: decode interval_sets for delegated inos
>    ceph: add flag to designate that a request is asynchronous
>    ceph: add infrastructure for waiting for async create to complete
>    ceph: add new MDS req field to hold delegated inode number
>    ceph: cache layout in parent dir on first sync create
>    ceph: attempt to do async create when possible
> 
>   fs/ceph/caps.c               |  34 ++++--
>   fs/ceph/dir.c                |  13 ++-
>   fs/ceph/file.c               | 218 +++++++++++++++++++++++++++++++++--
>   fs/ceph/inode.c              |  50 ++++----
>   fs/ceph/mds_client.c         | 126 ++++++++++++++++++--
>   fs/ceph/mds_client.h         |   9 +-
>   fs/ceph/super.h              |  16 ++-
>   include/linux/ceph/ceph_fs.h |   8 +-
>   net/ceph/ceph_fs.c           |   1 +
>   9 files changed, 410 insertions(+), 65 deletions(-)
> 

