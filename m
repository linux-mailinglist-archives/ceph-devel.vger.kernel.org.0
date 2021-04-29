Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF22D36E2C6
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Apr 2021 02:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhD2A60 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 28 Apr 2021 20:58:26 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:28748 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhD2A6Z (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 20:58:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619657859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Na0gxTRzUQfQHfiv1CxuEI6nuX4Eb+6ephewHKzNJXM=;
        b=exvUakRkKE5cBwGBuCUZoILD8dAIVFna75JU/K4iudQGchO4lboz1c4c0hdlxvhC6TU10s
        lpWBwvCZ7OfX8f4mnxtazr7ILbx1kPXjBKIOSsXdvrPHqOHk8gDSMWuS/4g8oBaDXwXpEp
        l0x0rUPiV2xJE31CB5+L+YsYk3WBH9c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-fdX2MZx9NxObq0o1iho4fw-1; Wed, 28 Apr 2021 20:57:36 -0400
X-MC-Unique: fdX2MZx9NxObq0o1iho4fw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D950501E5;
        Thu, 29 Apr 2021 00:57:35 +0000 (UTC)
Received: from [10.72.12.188] (ovpn-12-188.pek2.redhat.com [10.72.12.188])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7EC9B5C1BB;
        Thu, 29 Apr 2021 00:57:32 +0000 (UTC)
Subject: Re: [PATCH v3 0/2] ceph: add IO size metric support
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210428060840.4447-1-xiubli@redhat.com>
 <6de87237eca5e9ebd7714755ddd11adb4bc5c5ed.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <d989e9ab-600c-3f1a-efa8-fb4198fb8a16@redhat.com>
Date:   Thu, 29 Apr 2021 08:57:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <6de87237eca5e9ebd7714755ddd11adb4bc5c5ed.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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

Yeah, sure. I will do it this week.

Thanks

BRs


> Cheers,


