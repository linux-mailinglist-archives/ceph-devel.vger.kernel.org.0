Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFFD1492D7
	for <lists+ceph-devel@lfdr.de>; Sat, 25 Jan 2020 02:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387660AbgAYB6w (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Jan 2020 20:58:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:32184 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387608AbgAYB6w (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 24 Jan 2020 20:58:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579917530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sCTY3MUOhIT5JGZJSjGudd2fJZYDwoOMvR2a39fEd00=;
        b=c0VJpAVrdIEjr5A4p9xK+D9jlYr+A5MSI8A7Ay0UM+8wpPo8Yf2FrUQ8IrprQGVWfxe89v
        GbXVkqkGHn4ykg5VwC5z97ZucJlsATtnvT//qECUUcUsTPwbtG3lf32WVTqIGCXyK629V9
        1MKjZhPE4276IsmaW7shcluceRtIMmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-NZ9mE3ZgMSKd2txzsO5vyQ-1; Fri, 24 Jan 2020 20:58:46 -0500
X-MC-Unique: NZ9mE3ZgMSKd2txzsO5vyQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 799631882CC0;
        Sat, 25 Jan 2020 01:58:45 +0000 (UTC)
Received: from [10.72.12.29] (ovpn-12-29.pek2.redhat.com [10.72.12.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC8508645A;
        Sat, 25 Jan 2020 01:58:40 +0000 (UTC)
Subject: Re: [RFC PATCH v3 00/10] ceph: asynchronous file create support
To:     Jeff Layton <jlayton@kernel.org>, "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, idridryomov@gmail.com,
        Sage Weil <sage@redhat.com>
References: <20200121192928.469316-1-jlayton@kernel.org>
 <CAAM7YAnYoCuxu2Oj3vK1ZyWyAgh_vWWTYRxE2ZqEhU9vT+YTKg@mail.gmail.com>
 <c894860b08a36191e8556afd3cf4bdb19cd5875b.camel@kernel.org>
From:   "Yan, Zheng" <zyan@redhat.com>
Message-ID: <8f207ea4-dc47-114f-cb33-edf2524bf334@redhat.com>
Date:   Sat, 25 Jan 2020 09:58:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c894860b08a36191e8556afd3cf4bdb19cd5875b.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 1/25/20 1:19 AM, Jeff Layton wrote:
> On Thu, 2020-01-23 at 01:04 +0800, Yan, Zheng wrote:
>> On Wed, Jan 22, 2020 at 3:31 AM Jeff Layton <jlayton@kernel.org> wrote:
>>> v3:
>>> - move some cephfs-specific code into ceph.ko
>>> - present and track inode numbers as u64 values
>>> - fix up check for dentry and cap eligibility checks
>>> - set O_CEPH_EXCL on async creates
>>> - attempt to handle errors better on async create (invalidate dentries
>>>    and dir completeness).
>>> - ensure that fsync waits for async create to complete
>>>
>>> v2:
>>> - move cached layout to dedicated field in inode
>>> - protect cached layout with i_ceph_lock
>>> - wipe cached layout in __check_cap_issue
>>> - set max_size of file to layout.stripe_unit
>>> - set truncate_size to (u64)-1
>>> - use dedicated CephFS feature bit instead of CEPHFS_FEATURE_OCTOPUS
>>> - set cap_id to 1 in async created inode
>>> - allocate inode number before submitting request
>>> - rework the prep for an async create to be more efficient
>>> - don't allow MDS or cap messages involving an inode until we get async
>>>    create reply
>>>
>>> Still not quite ready for merge, but I've cleaned up a number of warts
>>> in the v2 set. Performance numbers still look about the same.
>>>
>>> There is definitely still a race of some sort that causes the client to
>>> try to asynchronously create a dentry that already exists. I'm still
>>> working on tracking that down.
>>>
>>> Jeff Layton (10):
>>>    ceph: move net/ceph/ceph_fs.c to fs/ceph/util.c
>>>    ceph: make ceph_fill_inode non-static
>>>    ceph: make dentry_lease_is_valid non-static
>>>    ceph: make __take_cap_refs non-static
>>>    ceph: decode interval_sets for delegated inos
>>>    ceph: add flag to designate that a request is asynchronous
>>>    ceph: add infrastructure for waiting for async create to complete
>>>    ceph: add new MDS req field to hold delegated inode number
>>>    ceph: cache layout in parent dir on first sync create
>>>    ceph: attempt to do async create when possible
>>>
>>>   fs/ceph/Makefile                     |   2 +-
>>>   fs/ceph/caps.c                       |  38 +++--
>>>   fs/ceph/dir.c                        |  13 +-
>>>   fs/ceph/file.c                       | 240 +++++++++++++++++++++++++--
>>>   fs/ceph/inode.c                      |  50 +++---
>>>   fs/ceph/mds_client.c                 | 123 ++++++++++++--
>>>   fs/ceph/mds_client.h                 |  17 +-
>>>   fs/ceph/super.h                      |  16 +-
>>>   net/ceph/ceph_fs.c => fs/ceph/util.c |   4 -
>>>   include/linux/ceph/ceph_fs.h         |   8 +-
>>>   net/ceph/Makefile                    |   2 +-
>>>   11 files changed, 443 insertions(+), 70 deletions(-)
>>>   rename net/ceph/ceph_fs.c => fs/ceph/util.c (94%)
>>>
>>> --
>>> 2.24.1
>>>
>>
>> I realized that there still are two issues:
>> -  we needs to clear delegated inos when mds failover
> 
> I'm guessing we need to do this whenever any session is reconnected,
> right? I think we may have bigger problems here though:
> 
> The issue is that with this set we assign out ino_t's prior to
> submitting the request. We could get down into it and find that we're
> reconnecting the session. At that point, that ino_t is no longer valid
> for the session.

yes, that's a problem for current kclient impelmentaion


> 
>> - we needs to clear caps for async dir operations when reconnecting to
>> mds. (see last commit of https://github.com/ceph/ceph/pull/32576)
>>
> 
> I guess we can use ceph_iterate_session_caps to do this. That said,
> looking at your patch:
> 
>          if (in->is_dir()) {
>            // remove caps for async dir operations
>            cap.implemented &= (CEPH_CAP_ANY_SHARED | CEPH_CAP_ANY_EXCL);
>          }
> 
> We remove all but Fsx here. That seems like quite a subtle difference
> from how FILE caps work.

only file caps have more than 2 bits. this removes caps other than 
AsxLsxXsxFsx.

> 
> Given the way that we're doing the inode delegation and handling dir
> caps, I think we may need to rework things such that async requests
> never get queued to the s_waiting list, and instead return some sort of
> distinct error that cues the caller to fall back to a synchronous
> request.
> 
> That would help prevent some of the potential races here.

my libcephfs implementation check if a request can be async just before 
sending the request.
> 

