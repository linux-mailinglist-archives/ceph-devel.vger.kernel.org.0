Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB3C3B7B08
	for <lists+ceph-devel@lfdr.de>; Wed, 30 Jun 2021 02:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235672AbhF3AiP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 29 Jun 2021 20:38:15 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235637AbhF3AiO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 20:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625013346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=es1/2eX4bAwM/zPBLCXCDTC21Zqk4pws7ctPPkhpSCM=;
        b=hbCDIvcZFoHsseozR8YTMXvdkpU9nltBTWSwIJ3Kiy+SSXwuLCM/CDVgatzjAGBlcqcKca
        Adc+GqJBxtZgdEb5bL2isxRrTw/3wy6bjBDbbsZNEv7hfU6ONQjqftEXFaP3nQJmWbbeQV
        APIwUcKDxxpsqAPGXZZmhoAZQXWUIWA=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-jXd1rTJAO1qYdOorhMQoew-1; Tue, 29 Jun 2021 20:35:45 -0400
X-MC-Unique: jXd1rTJAO1qYdOorhMQoew-1
Received: by mail-pg1-f198.google.com with SMTP id 65-20020a6305440000b029022763b46d51so356570pgf.0
        for <ceph-devel@vger.kernel.org>; Tue, 29 Jun 2021 17:35:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=es1/2eX4bAwM/zPBLCXCDTC21Zqk4pws7ctPPkhpSCM=;
        b=eIfyJ8laz7sxKJPgOtBDiGpT3ipzScWnsOD2A6zuCwxe5Pw1/aGEVVsQM40jym5b1i
         U2Ze9NzrTDn3McK01AkWxuWj3EUrb8OgUgyEpTTGcvTp1kLg1hsIICoZfzVUI5ZN8aZW
         XpoEEPOEYi0mqBocN3206Mk8AJbjBwqpKMLmycBXNN5Ks1hwixPGF4EKJTNpglXDcsHC
         nAnd23nqarPFEv2DeWohuYxW/8AfIrG+0JLtg5elRjWZrU5fb0kmNrz40+K0SJWnZ3JB
         oJVLj7G7QYYZKOWlRSKx+UZwIfg8LjCVsio9V+uzrXNawMfN+0m2lW+XIx5SdT0TKJDT
         xcqg==
X-Gm-Message-State: AOAM533l4llEyWDgX/IZSlx3johMvtZ5VsOcQEj+K156ubZh/kRPUDkc
        lhVDbYgYCjAMlwR1p2fIEuEd68MR27yy8bdqoltgUG4KLjADBfKTAre5n3dX3CgZwVIga5Eje7G
        auIVD//TBrhOsfWhB+RrPgVhzoP8a7EQriXZGuXQoJKOebL8ubf1uYH3oVykEpYnavZTPPuQ=
X-Received: by 2002:a62:8fd0:0:b029:30d:a7df:d63f with SMTP id n199-20020a628fd00000b029030da7dfd63fmr8950498pfd.67.1625013344231;
        Tue, 29 Jun 2021 17:35:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJys6V5DZE1NOIQ9LoPVtMnCJvkY12YqGNTkYoFwiPXJFso/87ccDBg1UaDqC7sVLxxh6B63zw==
X-Received: by 2002:a62:8fd0:0:b029:30d:a7df:d63f with SMTP id n199-20020a628fd00000b029030da7dfd63fmr8950478pfd.67.1625013343928;
        Tue, 29 Jun 2021 17:35:43 -0700 (PDT)
Received: from [10.72.12.103] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m14sm20104472pgu.84.2021.06.29.17.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 17:35:43 -0700 (PDT)
Subject: Re: [PATCH 0/5] flush the mdlog before waiting on unsafe reqs
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20210629044241.30359-1-xiubli@redhat.com>
 <9d697fc5ed6a770f502d682d78ee418a19c2f246.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <ee391eac-980e-fa91-4ee2-a15bf7d7aaf1@redhat.com>
Date:   Wed, 30 Jun 2021 08:35:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <9d697fc5ed6a770f502d682d78ee418a19c2f246.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/29/21 11:27 PM, Jeff Layton wrote:
> On Tue, 2021-06-29 at 12:42 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For the client requests who will have unsafe and safe replies from
>> MDS daemons, in the MDS side the MDS daemons won't flush the mdlog
>> (journal log) immediatelly, because they think it's unnecessary.
>> That's true for most cases but not all, likes the fsync request.
>> The fsync will wait until all the unsafe replied requests to be
>> safely replied.
>>
>> Normally if there have multiple threads or clients are running, the
>> whole mdlog in MDS daemons could be flushed in time if any request
>> will trigger the mdlog submit thread. So usually we won't experience
>> the normal operations will stuck for a long time. But in case there
>> has only one client with only thread is running, the stuck phenomenon
>> maybe obvious and the worst case it must wait at most 5 seconds to
>> wait the mdlog to be flushed by the MDS's tick thread periodically.
>>
>> This patch will trigger to flush the mdlog in all the MDSes manually
>> just before waiting the unsafe requests to finish.
>>
>>
> This seems a bit heavyweight, given that you may end up sending
> FLUSH_MDLOG messages to mds's on which you're not waiting. What might be
> best is to scan the list of requests you're waiting on and just send
> these messages to those mds's.
>
> Is that possible here?

Yeah, possibly and let me try that.

Thanks.


>>
>> Xiubo Li (5):
>>    ceph: export ceph_create_session_msg
>>    ceph: export iterate_sessions
>>    ceph: flush mdlog before umounting
>>    ceph: flush the mdlog before waiting on unsafe reqs
>>    ceph: fix ceph feature bits
>>
>>   fs/ceph/caps.c               | 35 ++++----------
>>   fs/ceph/mds_client.c         | 91 +++++++++++++++++++++++++++---------
>>   fs/ceph/mds_client.h         |  9 ++++
>>   include/linux/ceph/ceph_fs.h |  1 +
>>   4 files changed, 88 insertions(+), 48 deletions(-)
>>

