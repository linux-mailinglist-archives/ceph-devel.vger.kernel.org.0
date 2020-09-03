Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED0725C26D
	for <lists+ceph-devel@lfdr.de>; Thu,  3 Sep 2020 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgICOY6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 3 Sep 2020 10:24:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729189AbgICOWY (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 3 Sep 2020 10:22:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599142943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bPCdYQwr8S02JA1aLxnQblx1LkhxsU/CPImzUIiDZaw=;
        b=HZw62LEuuiZsj8dPng2xSZG5MTZ8fXLJZEbZvWBuY2VdtHjhrXxfpOfd/Pmefi9Ce8Itzc
        e4i8H+XcN065qaVL4xb1TUo25wVwfsoiFzm1eaOpJYgBH9HFhH0vTyQeWek9WjABS/2nHP
        RZOFFBGPbDFe8ZvXbcv5HeeMYc+EJZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-d4maf47LOe6iCdsMo7Uk7Q-1; Thu, 03 Sep 2020 10:22:19 -0400
X-MC-Unique: d4maf47LOe6iCdsMo7Uk7Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61263801AEE;
        Thu,  3 Sep 2020 14:22:18 +0000 (UTC)
Received: from [10.72.12.50] (ovpn-12-50.pek2.redhat.com [10.72.12.50])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 64FA468430;
        Thu,  3 Sep 2020 14:22:16 +0000 (UTC)
Subject: Re: [PATCH v5 0/2] ceph: metrics for opened files, pinned caps and
 opened inodes
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200903130140.799392-1-xiubli@redhat.com>
 <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ad35f2f8-6692-3918-6137-adc8e95607c6@redhat.com>
Date:   Thu, 3 Sep 2020 22:22:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <449a56624f3dd4e2a4a4cf95cd24d69c53700b6d.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/9/3 22:18, Jeff Layton wrote:
> On Thu, 2020-09-03 at 09:01 -0400, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Changed in V5:
>> - Remove mdsc parsing helpers except the ceph_sb_to_mdsc()
>> - Remove the is_opened member.
>>
>> Changed in V4:
>> - A small fix about the total_inodes.
>>
>> Changed in V3:
>> - Resend for V2 just forgot one patch, which is adding some helpers
>> support to simplify the code.
>>
>> Changed in V2:
>> - Add number of inodes that have opened files.
>> - Remove the dir metrics and fold into files.
>>
>>
>>
>> Xiubo Li (2):
>>    ceph: add ceph_sb_to_mdsc helper support to parse the mdsc
>>    ceph: metrics for opened files, pinned caps and opened inodes
>>
>>   fs/ceph/caps.c    | 41 +++++++++++++++++++++++++++++++++++++----
>>   fs/ceph/debugfs.c | 11 +++++++++++
>>   fs/ceph/dir.c     | 20 +++++++-------------
>>   fs/ceph/file.c    | 13 ++++++-------
>>   fs/ceph/inode.c   | 11 ++++++++---
>>   fs/ceph/locks.c   |  2 +-
>>   fs/ceph/metric.c  | 14 ++++++++++++++
>>   fs/ceph/metric.h  |  7 +++++++
>>   fs/ceph/quota.c   | 10 +++++-----
>>   fs/ceph/snap.c    |  2 +-
>>   fs/ceph/super.h   |  6 ++++++
>>   11 files changed, 103 insertions(+), 34 deletions(-)
>>
> Looks good. I went ahead and merge this into testing.
>
> Small merge conflict in quota.c, which I guess is probably due to not
> basing this on testing branch. I also dropped what looks like an
> unrelated hunk in the second patch.
>
> In the future, if you can be sure that patches you post apply cleanly to
> testing branch then that would make things easier.

Okay, will do it.

Thanks.


> Thanks!


