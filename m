Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4B91260E1
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Dec 2019 12:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfLSLdB (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Dec 2019 06:33:01 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37989 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726656AbfLSLdB (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 06:33:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576755180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M2Fh/r5dktpQMZTXbXf4HQXZRFN2aGWHcfYxFnpQOrg=;
        b=DIriwBZmiejxe0xewTlhDINJEQmdQ2QXkZu9wzRfQ0N/GfrkC4bT77ilC63FVd3BB5Vyha
        0VRwXLE8v+SiH2nfN9xB2EvNVlg1LOnri/i28j47lsOq10GW8qVSVQ52i1yXNUaKWuiRw3
        83M1cCKY4UX6PBLiJLbR4mCUk/SAdH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-vdjdDlmoOEa6BywHyjcMDQ-1; Thu, 19 Dec 2019 06:32:58 -0500
X-MC-Unique: vdjdDlmoOEa6BywHyjcMDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7D6B802C9C;
        Thu, 19 Dec 2019 11:32:57 +0000 (UTC)
Received: from [10.72.12.95] (ovpn-12-95.pek2.redhat.com [10.72.12.95])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 369D326E46;
        Thu, 19 Dec 2019 11:32:52 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: rename get_session and switch to use
 ceph_get_mds_session
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, Sage Weil <sage@redhat.com>,
        "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20191219010716.60987-1-xiubli@redhat.com>
 <CAOi1vP8XJ4nm1esUaQEcu3pQgmb_MUuWRqg6Eeip5-TXVwKmPg@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7e6cb129-09d7-afb4-1d28-def9249ac4c1@redhat.com>
Date:   Thu, 19 Dec 2019 19:32:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8XJ4nm1esUaQEcu3pQgmb_MUuWRqg6Eeip5-TXVwKmPg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/12/19 18:45, Ilya Dryomov wrote:
> On Thu, Dec 19, 2019 at 2:07 AM <xiubli@redhat.com> wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> Just in case the session's refcount reach 0 and is releasing, and
>> if we get the session without checking it, we may encounter kernel
>> crash.
>>
>> Rename get_session to ceph_get_mds_session and make it global.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> Changed in V2:
>> - there has some conflict and rebase to upstream code.
> Hi Xiubo,
>
> There were two patches in the testing branch that weren't meant to be
> there, one of them touching con_get().  I've just rebased and removed
> them.  (5.5-rc2 is broken, so it is based on 5.5-rc2 plus the fix for
> the breakage for now.)
>
> It looks like neither v1 or v2 were based on testing though, so this is
> more of an FYI.  The reason I'm still sending this message is that both
> v1 and v2 appear to be whitespace corrupt and will need to be redone.

I am using the "testing" branch, so I will post it again later.

Thanks.


> Thanks,
>
>                  Ilya
>

