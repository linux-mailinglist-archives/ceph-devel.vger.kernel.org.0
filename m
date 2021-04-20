Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110BB365011
	for <lists+ceph-devel@lfdr.de>; Tue, 20 Apr 2021 04:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhDTCCr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 19 Apr 2021 22:02:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhDTCCr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 19 Apr 2021 22:02:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618884136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pjn5Jnac03tyPqVB71JyohrEqjg9UzBnWj7k4tQgGP0=;
        b=LDfFfRkfhWaWx6K4nIdjZC3KLsf3TzirfsIVjkCga7SRa/ZjAZPu/hywAEpnt9z6GLR1uI
        KIyaDwUuUYAEyVEvE4f2oGuHzyj91mmF2oCSTVJ6FBVVER00/EUdXphz9aEd879N5OKSWX
        yr5AXsZEdCnilHa6qo4lkJemV4pSbBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-s7rYD8FiOlOYlAdW5eAePA-1; Mon, 19 Apr 2021 22:02:13 -0400
X-MC-Unique: s7rYD8FiOlOYlAdW5eAePA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A8571922976;
        Tue, 20 Apr 2021 02:02:12 +0000 (UTC)
Received: from [10.72.13.181] (ovpn-13-181.pek2.redhat.com [10.72.13.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 859511980D;
        Tue, 20 Apr 2021 02:02:10 +0000 (UTC)
Subject: Re: [PATCH] ceph: make the lost+found dir accessible by kernel client
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ukernel@gmail.com,
        ceph-devel@vger.kernel.org
References: <20210419023237.1177430-1-xiubli@redhat.com>
 <02cc34a899aab7169ecfdc9b15bb5dcb3d19edd8.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <294a5c31-f40c-b424-0497-6737c5cd583d@redhat.com>
Date:   Tue, 20 Apr 2021 10:02:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <02cc34a899aab7169ecfdc9b15bb5dcb3d19edd8.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/4/20 0:09, Jeff Layton wrote:
> On Mon, 2021-04-19 at 10:32 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Inode number 0x4 is reserved for the lost+found dir, and the app
>> or test app need to access it.
>>
>> URL: https://tracker.ceph.com/issues/50216
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/super.h              | 3 ++-
>>   include/linux/ceph/ceph_fs.h | 7 ++++---
>>   2 files changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
>> index 4808a1458c9b..0f38e6183ff0 100644
>> --- a/fs/ceph/super.h
>> +++ b/fs/ceph/super.h
>> @@ -542,7 +542,8 @@ static inline int ceph_ino_compare(struct inode *inode, void *data)
>>   
>>
>>
>>
>>   static inline bool ceph_vino_is_reserved(const struct ceph_vino vino)
>>   {
>> -	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT) {
>> +	if (vino.ino < CEPH_INO_SYSTEM_BASE && vino.ino != CEPH_INO_ROOT &&
>> +	    vino.ino != CEPH_INO_LOST_AND_FOUND ) {
>>   		WARN_RATELIMIT(1, "Attempt to access reserved inode number 0x%llx", vino.ino);
>>   		return true;
>>   	}
>> diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
>> index e41a811026f6..57e5bd63fb7a 100644
>> --- a/include/linux/ceph/ceph_fs.h
>> +++ b/include/linux/ceph/ceph_fs.h
>> @@ -27,9 +27,10 @@
>>   #define CEPH_MONC_PROTOCOL   15 /* server/client */
>>   
>>
>>
>>
>>   
>>
>>
>>
>> -#define CEPH_INO_ROOT   1
>> -#define CEPH_INO_CEPH   2       /* hidden .ceph dir */
>> -#define CEPH_INO_DOTDOT 3	/* used by ceph fuse for parent (..) */

Hi Jeff,

Please fix the "CEPH_INO_DOTDOT" when you folding this patch. The inode 
number 3 is not _DOTDOT any more. This was introduced by an very old 
commit(dd6f5e105d85e) but I couldn't find the related change about this 
in ceph code.

It should be:

#define CEPH_INO_GLOBAL_SNAPREALM 3


>> +#define CEPH_INO_ROOT           1
>> +#define CEPH_INO_CEPH           2 /* hidden .ceph dir */
>> +#define CEPH_INO_DOTDOT         3 /* used by ceph fuse for parent (..) */
>> +#define CEPH_INO_LOST_AND_FOUND 4 /* lost+found dir */
>>   
>>
>>
>>
>>   /* arbitrary limit on max # of monitors (cluster of 3 is typical) */
>>   #define CEPH_MAX_MON   31
> Thanks Xiubo,
>
> For some background, apparently cephfs-data-scan can create this
> directory, and the clients do need access to it. I'll fold this into the
> original patch that makes these inodes inaccessible (ceph: don't allow
> access to MDS-private inodes).
>
> Cheers!


