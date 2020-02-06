Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 996E3153D06
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2020 03:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbgBFCv1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 21:51:27 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55746 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727474AbgBFCv1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Feb 2020 21:51:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580957485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nrOQtBSS6vAPUMKuRc2MW8/iE7DuRXjbj5bSjh+CCuM=;
        b=gSJ5YsrMQrntAOFS2XjdLxtNSrRrGHXnwl3o8ipDZKZfBiT8E375WW2AKgLq8KMtKyU+2j
        R0yf3oHSdTnzA3Sqin9HpCbnam6fR4ygPddjDg80mThNzAo6j9ikaLGSrYw3MS7TS++Hzk
        BgyPaHcuRdINGdGE67bx5Ph6uQEf31s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-47-iNhYrNAWN1GNz9UnDHVDpg-1; Wed, 05 Feb 2020 21:51:21 -0500
X-MC-Unique: iNhYrNAWN1GNz9UnDHVDpg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5F1E18AB2C0;
        Thu,  6 Feb 2020 02:51:20 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DB3F165FE;
        Thu,  6 Feb 2020 02:51:16 +0000 (UTC)
Subject: Re: [RFC PATCH] ceph: serialize the direct writes when couldn't
 submit in a single req
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200204015445.4435-1-xiubli@redhat.com>
 <06b35b716c6f158360f2a21f00c3c1c0232562cc.camel@kernel.org>
 <e9677dc33eecf80ee988e946cc84a4d9a9803d15.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9819b72a-f4fb-f45d-b1d8-c48359092faa@redhat.com>
Date:   Thu, 6 Feb 2020 10:51:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <e9677dc33eecf80ee988e946cc84a4d9a9803d15.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/6 0:38, Jeff Layton wrote:
> On Wed, 2020-02-05 at 11:24 -0500, Jeff Layton wrote:
>> On Mon, 2020-02-03 at 20:54 -0500, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> If the direct io couldn't be submit in a single request, for multiple
>>> writers, they may overlap each other.
>>>
>>> For example, with the file layout:
>>> ceph.file.layout="stripe_unit=4194304 stripe_count=1 object_size=4194304
>>>
>>> fd = open(, O_DIRECT | O_WRONLY, );
>>>
>>> Writer1:
>>> posix_memalign(&buffer, 4194304, SIZE);
>>> memset(buffer, 'T', SIZE);
>>> write(fd, buffer, SIZE);
>>>
>>> Writer2:
>>> posix_memalign(&buffer, 4194304, SIZE);
>>> memset(buffer, 'X', SIZE);
>>> write(fd, buffer, SIZE);
>>>
>>>  From the test result, the data in the file possiblly will be:
>>> TTT...TTT <---> object1
>>> XXX...XXX <---> object2
>>>
>>> The expected result should be all "XX.." or "TT.." in both object1
>>> and object2.
>>>
>> I really don't see this as broken. If you're using O_DIRECT, I don't
>> believe there is any expectation that the write operations (or even read
>> operations) will be atomic wrt to one another.
>>
>> Basically, when you do this, you're saying "I know what I'm doing", and
>> need to provide synchronization yourself between competing applications
>> and clients (typically via file locking).
>>
> In fact, here's a discussion about this from a couple of years ago. This
> one mostly applies to local filesystems, but the same concepts apply to
> CephFS as well:
>
>
> https://www.spinics.net/lists/linux-fsdevel/msg118115.html
>
Okay. So for the O_DIRECT write/read, we won't guarantee it will be 
atomic in fs layer.

Thanks,

