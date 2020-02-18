Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD8A162173
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 08:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgBRHTk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 02:19:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59234 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726072AbgBRHTk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 18 Feb 2020 02:19:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582010379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3ZmnTNDK/4Vu4ul9Uxr/Gdc+YY/L5exAzL9C1glUo4=;
        b=Sk6P/vASNfkjj76Ql1MGKh8Esjcr2lU0YxZqBHJaLwtswpdK0zfPBAibauO76BLHS+7Uer
        TgN4sKlb4gfC7R9sOGoh3/PXF/2G9ThU+Gphy8yAUBkzb1ThMpS/ZV4YIj1Fdk3zyHwm3l
        /CAC9Y/q2TUja6O/4mMuLQSNNZQc6FI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-qcXwit00MbaMMWfviVcOcA-1; Tue, 18 Feb 2020 02:19:30 -0500
X-MC-Unique: qcXwit00MbaMMWfviVcOcA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68F6218C43E9;
        Tue, 18 Feb 2020 07:19:29 +0000 (UTC)
Received: from [10.72.12.23] (ovpn-12-23.pek2.redhat.com [10.72.12.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9662590F6B;
        Tue, 18 Feb 2020 07:19:24 +0000 (UTC)
Subject: Re: [PATCH] ceph: add halt mount option support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20200216064945.61726-1-xiubli@redhat.com>
 <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com>
Date:   Tue, 18 Feb 2020 15:19:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/17 21:04, Jeff Layton wrote:
> On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> This will simulate pulling the power cable situation, which will
>> do:
>>
>> - abort all the inflight osd/mds requests and fail them with -EIO.
>> - reject any new coming osd/mds requests with -EIO.
>> - close all the mds connections directly without doing any clean up
>>    and disable mds sessions recovery routine.
>> - close all the osd connections directly without doing any clean up.
>> - set the msgr as stopped.
>>
>> URL: https://tracker.ceph.com/issues/44044
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> There is no explanation of how to actually _use_ this feature? I assume
> you have to remount the fs with "-o remount,halt" ? Is it possible to
> reenable the mount as well?  If not, why keep the mount around? Maybe we
> should consider wiring this in to a new umount2() flag instead?
>
> This needs much better documentation.
>
> In the past, I've generally done this using iptables. Granted that that
> is difficult with a clustered fs like ceph (given that you potentially
> have to set rules for a lot of addresses), but I wonder whether a scheme
> like that might be more viable in the long run.
>
How about fulfilling the DROP iptable rules in libceph ? Could you 
foresee any problem ? This seems the one approach could simulate pulling 
the power cable.

Any idea ?

Thanks

BRs


