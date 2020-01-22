Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487E1144C77
	for <lists+ceph-devel@lfdr.de>; Wed, 22 Jan 2020 08:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbgAVHaN (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 22 Jan 2020 02:30:13 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60087 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbgAVHaN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 22 Jan 2020 02:30:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579678211;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=357h7ttiGlQTaF9fp2zxvv8y451ZBhurEf5ee1VkJCE=;
        b=XKQv7jyx93rSDbBGjoqMYWSyTDQKh03+eEj1xTB+ZwGOld9blA4wDuml4teBVFjxBWjgeG
        VZqdJBfT4+w4fsdwJooJSei0yZciBUIDZBnc6J6t90U3o5k9IhSaXpg2Iai6fXJCDn4DNU
        oxUq/BfB2u/gJviMY1Jnx/YpcaB1hXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-ipFYsI1FNZ-wdX4iOhKIKg-1; Wed, 22 Jan 2020 02:30:07 -0500
X-MC-Unique: ipFYsI1FNZ-wdX4iOhKIKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CFA9800D4E;
        Wed, 22 Jan 2020 07:30:06 +0000 (UTC)
Received: from [10.72.12.142] (ovpn-12-142.pek2.redhat.com [10.72.12.142])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 240475C3FD;
        Wed, 22 Jan 2020 07:30:01 +0000 (UTC)
Subject: Re: [RFC PATCH v3 00/10] ceph: asynchronous file create support
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     idridryomov@gmail.com, sage@redhat.com
References: <20200121192928.469316-1-jlayton@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <9ca16b04-2351-ba1b-6e72-4b456ab19448@redhat.com>
Date:   Wed, 22 Jan 2020 15:29:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200121192928.469316-1-jlayton@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/22/20 3:29 AM, Jeff Layton wrote:
> v3:
> - move some cephfs-specific code into ceph.ko
> - present and track inode numbers as u64 values
> - fix up check for dentry and cap eligibility checks
> - set O_CEPH_EXCL on async creates
> - attempt to handle errors better on async create (invalidate dentries
>    and dir completeness).
> - ensure that fsync waits for async create to complete
> 
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
> Still not quite ready for merge, but I've cleaned up a number of warts
> in the v2 set. Performance numbers still look about the same.
> 
> There is definitely still a race of some sort that causes the client to
> try to asynchronously create a dentry that already exists. I'm still
> working on tracking that down.
> 
> Jeff Layton (10):
>    ceph: move net/ceph/ceph_fs.c to fs/ceph/util.c
>    ceph: make ceph_fill_inode non-static
>    ceph: make dentry_lease_is_valid non-static
>    ceph: make __take_cap_refs non-static
>    ceph: decode interval_sets for delegated inos
>    ceph: add flag to designate that a request is asynchronous
>    ceph: add infrastructure for waiting for async create to complete
>    ceph: add new MDS req field to hold delegated inode number
>    ceph: cache layout in parent dir on first sync create
>    ceph: attempt to do async create when possible
> 
>   fs/ceph/Makefile                     |   2 +-
>   fs/ceph/caps.c                       |  38 +++--
>   fs/ceph/dir.c                        |  13 +-
>   fs/ceph/file.c                       | 240 +++++++++++++++++++++++++--
>   fs/ceph/inode.c                      |  50 +++---
>   fs/ceph/mds_client.c                 | 123 ++++++++++++--
>   fs/ceph/mds_client.h                 |  17 +-
>   fs/ceph/super.h                      |  16 +-
>   net/ceph/ceph_fs.c => fs/ceph/util.c |   4 -
>   include/linux/ceph/ceph_fs.h         |   8 +-
>   net/ceph/Makefile                    |   2 +-
>   11 files changed, 443 insertions(+), 70 deletions(-)
>   rename net/ceph/ceph_fs.c => fs/ceph/util.c (94%)
> 

Series

Reviewed-By: "Yan, Zheng" <zyan@redhat.com>


