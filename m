Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4875C36E32C
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Apr 2021 04:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbhD2CPU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Apr 2021 22:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57921 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229888AbhD2CPU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 22:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619662473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RiUzBVKMpC7m5nSuqZRTem39Bddklzf90xrukuHIWNY=;
        b=Q7bsOuy0GaKigS3McseleqgA8h/6MEmFMMu3JxMXuDgdSi+Rcx6cQWATB1lOKwoFfBCgit
        D0FvX4LaRqR1msilTetzsNhgjjAJG/spWkjYLKHL/3HYlHSZQCb7kjMwrGUcttdXGh4aYv
        gh10qmdFaj6Nw0NER3V6t4ZCheOn/vA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-tlXpQLAXMb6_TQvoXSfXtQ-1; Wed, 28 Apr 2021 22:14:31 -0400
X-MC-Unique: tlXpQLAXMb6_TQvoXSfXtQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B3370801AC3;
        Thu, 29 Apr 2021 02:14:30 +0000 (UTC)
Received: from [10.72.12.188] (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 173F86B8E5;
        Thu, 29 Apr 2021 02:14:28 +0000 (UTC)
Subject: Re: [PATCH v3 0/2] ceph: add IO size metric support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210428060840.4447-1-xiubli@redhat.com>
 <6de87237eca5e9ebd7714755ddd11adb4bc5c5ed.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <3388d842-d48b-0353-a60b-ab3221b94965@redhat.com>
Date:   Thu, 29 Apr 2021 10:14:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <6de87237eca5e9ebd7714755ddd11adb4bc5c5ed.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2021/4/28 22:14, Jeff Layton wrote:
> On Wed, 2021-04-28 at 14:08 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> V3:
>> - update and rename __update_latency to __update_stdev.
>>
>> V2:
>> - remove the unused parameters in metric.c
>> - a small clean up for the code.
>>
>> For the read/write IO speeds, will leave them to be computed in
>> userspace,
>> 	where it can get a preciser result with float type.
>>
>>
>> Xiubo Li (2):
>>    ceph: update and rename __update_latency helper to __update_stdev
>>    ceph: add IO size metrics support
>>
>>   fs/ceph/addr.c    | 14 +++++----
>>   fs/ceph/debugfs.c | 37 +++++++++++++++++++++---
>>   fs/ceph/file.c    | 23 +++++++--------
>>   fs/ceph/metric.c  | 74 ++++++++++++++++++++++++++++++++---------------
>>   fs/ceph/metric.h  | 10 +++++--
>>   5 files changed, 111 insertions(+), 47 deletions(-)
>>
> Thanks Xiubo,
>
> This looks good. Merged into ceph-client/testing.
>
> My only (minor) complaint is that the output of
> /sys/kernel/debug/ceph/*/metrics is a bit ad-hoc and messy, especially
> when there are multiple mounts. It might be good to clean that up in a
> later patch, but I don't see it as a reason to block merging this.

BTW, each mounter will have its own "/sys/.../metrics" file, what do you 
mean for multiple mounts here ? Is there any case will they be messed up 
or something else ?

Thanks.


> Cheers,


