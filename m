Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36802166E58
	for <lists+ceph-devel@lfdr.de>; Fri, 21 Feb 2020 05:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbgBUERB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Feb 2020 23:17:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33231 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729782AbgBUEQ7 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 20 Feb 2020 23:16:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582258618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qzs+tV9Z0rXKBM8TAE2GW4chB2YhQtpIc8dC4sieGKU=;
        b=a0durTr2kkFdE2ts0lxNGxbNQh19c17plgIBQ82BKYcPH6rnzopB+8yMeqll1VRYETBWB/
        jYpOyfSTtaFnFztSW0ih3YBVaeDtDJ4Aj0w+E4XsWoE5lvFMVhBwLER0ZkQgtavQjMRNl2
        h3ipMiQAQWuX2okeYzjdTys7ZWtB0nM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-x4HKaCrwNTyydlK9ey8M4g-1; Thu, 20 Feb 2020 23:16:52 -0500
X-MC-Unique: x4HKaCrwNTyydlK9ey8M4g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DE25189F763;
        Fri, 21 Feb 2020 04:16:51 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99EF719486;
        Fri, 21 Feb 2020 04:16:46 +0000 (UTC)
Subject: Re: [PATCH v7 2/5] ceph: add caps perf metric for each session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200219033851.6548-1-xiubli@redhat.com>
 <20200219033851.6548-3-xiubli@redhat.com>
 <b3837ae640e8ec3fa631b4b2a4d61adf15440ec2.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ebe5e479-0da4-093a-adee-2b432ef2e109@redhat.com>
Date:   Fri, 21 Feb 2020 12:16:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b3837ae640e8ec3fa631b4b2a4d61adf15440ec2.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/20 2:29, Jeff Layton wrote:
> On Tue, 2020-02-18 at 22:38 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will fulfill the cap hit/mis metric stuff per-superblock,
>> it will count the hit/mis counters based each inode, and if one
>> inode's 'issued & ~revoking == mask' will mean a hit, or a miss.
>>
>> item          total           miss            hit
>> -------------------------------------------------
>> caps          295             107             4119
>>
>> URL: https://tracker.ceph.com/issues/43215
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/acl.c        |  2 ++
>>   fs/ceph/caps.c       | 31 +++++++++++++++++++++++++++++++
>>   fs/ceph/debugfs.c    | 16 ++++++++++++++++
>>   fs/ceph/dir.c        |  9 +++++++--
>>   fs/ceph/file.c       |  2 ++
>>   fs/ceph/mds_client.c | 26 ++++++++++++++++++++++----
>>   fs/ceph/metric.h     |  3 +++
>>   fs/ceph/quota.c      |  9 +++++++--
>>   fs/ceph/super.h      |  9 +++++++++
>>   fs/ceph/xattr.c      | 17 ++++++++++++++---
>>   10 files changed, 113 insertions(+), 11 deletions(-)
>>
> Summary:
>
> I think counting this stuff is useful, but I'm not sure you're doing it
> in the right places below. Also, you're calling __ceph_caps_metric from
> many places where you already know whether it's a hit or miss. You could
> just bump the counter and do less work in those cases.
>
> More notes below:

Will fix them all.

Thanks
BRs
Xiubo



